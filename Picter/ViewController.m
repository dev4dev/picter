//
//  ViewController.m
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "ViewController.h"
#import "TwitterService.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "RainbowDataModifier.h"
#import "FlickrDataModifier.h"
#import "ZOMFGDataModifier.h"

#define USERS_ACTION_SHEET	0
#define ORDER_ACTION_SHEET	1

@interface ViewController ()
	<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) TwitterPagedResult *tweets;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweetsCache;
@property (nonatomic, strong) NSCache *imagesCache;
@property (nonatomic, weak) IBOutlet UIView *loadingView;

- (IBAction)selectAccountAction:(id)sender;
- (IBAction)orderAction:(id)sender;
- (void)loadTweetsForAccount:(ACAccount *)account;
- (void)refreshData:(id)sender;
- (void)loadTweets:(StatusBlock)callback;
- (void)refreshTableView;

@end

@implementation ViewController

- (void)
viewDidLoad
{
	[super viewDidLoad];
	self.imagesCache = [NSCache new];

	UIRefreshControl *refreshControl = [UIRefreshControl new];
	[refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
}

#pragma mark - Prop Setters

- (void)
setTweets:(TwitterPagedResult *)tweets
{
	_tweets = tweets;
	[self loadTweets:nil];
}

- (void)
loadTweets:(StatusBlock)callback
{
	self.loadingView.hidden = NO;
	[self.tweets load:^(BOOL status, NSArray *freshData) {
		if (status) {
			[self refreshTableView];
			self.loadingView.hidden = YES;
			if (callback) {
				callback(status);
			}
		} else {
			NSLog(@"oops");
		}
	}];
}

- (void)
refreshData:(UIRefreshControl *)sender
{
	if (!self.tweets) {
		[sender endRefreshing];
		return;
	}
	[self.tweets reset];
	[self loadTweets:^(BOOL status) {
		[sender endRefreshing];
	}];
}

- (void)
loadTweetsForAccount:(ACAccount *)account
{
	TwitterPagedResult *result = [TwitterService timeLineForAccount:account];
	result.dataModifier = [ZOMFGDataModifier new];
	self.tweets = result;
}

- (void)
refreshTableView
{
	self.tweetsCache = self.tweets.data;
	[self.tableView reloadData];
}

#pragma mark - UI Actions

- (IBAction)
selectAccountAction:(id)sender
{
	[[TwitterService sharedService] systemTwitterUsers:^(BOOL access, NSArray *account) {
		if (access) {
			self.accounts = account;
			if (account.count > 0) {
				UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Show tweets for..."
																   delegate:self
														  cancelButtonTitle:nil
													 destructiveButtonTitle:nil
														  otherButtonTitles:nil];
				sheet.tag = USERS_ACTION_SHEET;
				[account enumerateObjectsUsingBlock:^(ACAccount *account, NSUInteger idx, BOOL *stop) {
					[sheet addButtonWithTitle:account.username];
				}];
				[sheet addButtonWithTitle:@"Cancel"];
				[sheet setCancelButtonIndex:account.count];
				[sheet showInView:self.view];
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																message:@"You don't have any twitter accounts logged in. You can log in iPhone Settings"
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
			}
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:@"Access denied. You can allow access in Settings > Privacy"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
	}];
}

- (IBAction)
orderAction:(id)sender
{
	UIActionSheet *orderSheet = [[UIActionSheet alloc] initWithTitle:@"Order by..."
															delegate:self
												   cancelButtonTitle:@"Cancel"
											  destructiveButtonTitle:nil
												   otherButtonTitles:@"By Alphabet", @"By Date (old first)", @"As Is (fresh first)", nil];
	orderSheet.tag = ORDER_ACTION_SHEET;
	[orderSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate

- (void)
actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (actionSheet.cancelButtonIndex == buttonIndex) {
		return;
	}

	switch (actionSheet.tag) {
		case USERS_ACTION_SHEET:
			[self loadTweetsForAccount:self.accounts[buttonIndex]];
			self.accounts = nil;
			break;

		case ORDER_ACTION_SHEET:
			switch (buttonIndex) {
				case 0:
					self.tweets.order = TwitterPagedResultOrderByAlpha;
					break;

				case 1:
					self.tweets.order = TwitterPagedResultOrderByDate;
					break;

				case 2:
					self.tweets.order = TwitterPagedResultOrderByAsIs;
					break;
			}
			[self refreshTableView];
			break;

		default:
			NSLog(@"unknown action sheet appers");
			break;
	}

}

#pragma mark - UITableView DD

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.tweetsCache.count;
}

- (UITableViewCell *)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
	if (indexPath.row < self.tweetsCache.count) {
		Tweet *tweet = self.tweetsCache[indexPath.row];
		if (tweet.attributedText) {
			cell.tweetLabel.attributedText = tweet.attributedText;
		} else {
			cell.tweetLabel.text = tweet.text;
		}

		UIImage *cachedImage = [self.imagesCache objectForKey:tweet.photo.thumbURL];
		if (cachedImage) {
			cell.tweetImageView.image = cachedImage;
		} else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:tweet.photo.thumbURL]];
				dispatch_async(dispatch_get_main_queue(), ^{
					if (image) {
						[self.imagesCache setObject:image forKey:tweet.photo.thumbURL];
						TweetCell *cell = (TweetCell *)[tableView cellForRowAtIndexPath:indexPath];
						if (cell) {
							cell.tweetImageView.image = image;
						}
					}
				});
			});
		}
	}
	return cell;
}

- (CGFloat)
tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.tweetsCache.count) {
		Tweet *tweet = self.tweetsCache[indexPath.row];
		return [tweet contentHeightForWidth:210.0 withFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]] + 20.0;
	} else {
		return self.tableView.rowHeight;
	}
}

@end
