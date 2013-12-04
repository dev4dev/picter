//
//  TwitterService.m
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "TwitterService.h"

@interface TwitterService()

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *accountType;

@end

@implementation TwitterService

+ (instancetype)
sharedService
{
    static dispatch_once_t once;
    static TwitterService *instance;
    dispatch_once(&once, ^ {
        instance = [[TwitterService alloc] init];
    });
    return instance;
}

- (instancetype)
init
{
	if (self = [super init]) {
        _accountStore = [ACAccountStore new];
		_accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	}

	return self;
}

- (void)
hasAccess:(StatusBlock)callback
{
	[self.accountStore requestAccessToAccountsWithType:self.accountType options:nil completion:^(BOOL granted, NSError *error) {
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(granted);
			});
		}
	}];
}

- (void)
systemTwitterUsers:(StatusDataBlock)callback
{
	[self hasAccess:^(BOOL status) {
		id data;
		if (status) {
			data = [self.accountStore accountsWithAccountType:self.accountType];
		}
		if (callback) {
			callback(status, data);
		}
	}];
}

#pragma mark - Datasources

+ (TwitterPagedResult *)
timeLineForAccount:(ACAccount *)account
{
	SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
											requestMethod:SLRequestMethodGET
													  URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"]
											   parameters:nil];
	request.account = account;
	return [[TwitterPagedResult alloc] initWithRequest:request];
}

@end
