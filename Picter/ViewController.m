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

@interface ViewController ()
	<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) TwitterPagedResult *tweets;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)selectAccountAction:(id)sender;
- (IBAction)orderAction:(id)sender;
- (void)loadTweetsForAccount:(ACAccount *)account;

@end

@implementation ViewController

#pragma mark - Prop Setters

- (void)
setTweets:(TwitterPagedResult *)tweets
{
	_tweets = tweets;
	[tweets load:^(BOOL status, NSArray *data) {
		[self.tableView reloadData];
	}];
}

- (void)
viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)
didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)
loadTweetsForAccount:(ACAccount *)account
{
	self.tweets = [TwitterService timeLineForAccount:account];
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
	NSLog(@"order");
}

#pragma mark - ActionSheet Delegate

- (void)
actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (actionSheet.cancelButtonIndex == buttonIndex) {
		return;
	}
	[self loadTweetsForAccount:self.accounts[buttonIndex]];
	self.accounts = nil;
}

#pragma mark - UITableView DD

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.tweets.data.count;
}

- (UITableViewCell *)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
	if (indexPath.row < self.tweets.data.count) {
		Tweet *tweet = self.tweets.data[indexPath.row];
		cell.textLabel.text = tweet.text;
	}
	return cell;
}

@end
