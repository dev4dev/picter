//
//  TwitterPagedResult.m
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "TwitterPagedResult.h"
#import "Tweet.h"
#import "DataModifier.h"

@interface TwitterPagedResult()

@property (nonatomic, strong) SLRequest *request;
@property (nonatomic, strong) NSMutableArray *innerData;
@property (nonatomic, assign) BOOL loaded;

- (NSArray *)unserialize:(NSArray *)rawObjects;
- (void)loadRequest:(NSURLRequest *)request appendData:(BOOL)appendData callback:(StatusDataBlock)callback;
- (SLRequest *)requestWithParams:(NSDictionary *)params;

@end

@implementation TwitterPagedResult

- (instancetype)
initWithRequest:(SLRequest *)request
{
	if (self = [super init]) {
		_request = request;
		_innerData = [NSMutableArray array];
		_order = TwitterPagedResultOrderByAsIs;
		_loaded = NO;
		_loaded = NO;
	}

	return self;
}

- (NSArray *)
data
{
	switch (self.order) {
		case TwitterPagedResultOrderByAlpha:
			return [self.innerData sortedArrayUsingComparator:^NSComparisonResult(Tweet *obj1, Tweet *obj2) {
				return [obj1.text compare:obj2.text];
			}];
			break;

		// isn't really useful ASC sort, but stream is already DESC sorted
		case TwitterPagedResultOrderByDate:
			return [self.innerData sortedArrayUsingComparator:^NSComparisonResult(Tweet *obj1, Tweet *obj2) {
				return [obj1.date compare:obj2.date];
			}];
			break;

		case TwitterPagedResultOrderByAsIs:
		default:
			return self.innerData;
			break;
	}

	return nil;
}


- (void)
reset
{
	self.innerData = [NSMutableArray array];
	self.loaded = NO;
}

- (SLRequest *)
requestWithParams:(NSDictionary *)params
{
	NSMutableDictionary *parameters = [self.request.parameters mutableCopy];
	if (params) {
		[parameters addEntriesFromDictionary:params];
	}
	SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
											requestMethod:self.request.requestMethod
													  URL:self.request.URL
											   parameters:parameters];
	request.account = self.request.account;
	return request;
}

- (void)
load:(StatusDataBlock)callback
{
	[self loadRequest:self.request.preparedURLRequest appendData:YES callback:callback];
}

- (void)
loadNextPage:(StatusDataBlock)callback
{
	if (!self.loaded || self.loading) {
		if (callback) {
			callback(NO, nil);
		}
		return;
	}

	Tweet *firstTweet = self.innerData.firstObject;
	SLRequest *request = [self requestWithParams:@{@"since_id": @(firstTweet.ID)}];
	[self loadRequest:request.preparedURLRequest appendData:NO callback:callback];
}

- (void)
loadPrevPage:(StatusDataBlock)callback
{
	if (!self.loaded || self.loading) {
		if (callback) {
			callback(NO, nil);
		}
		NSLog(@"PagedResult: load before paging");
		return;
	}

	Tweet *lastTweet = self.innerData.lastObject;
	SLRequest *request = [self requestWithParams:@{@"max_id": @(lastTweet.ID - 1)}];
	[self loadRequest:request.preparedURLRequest appendData:YES callback:callback];
}

- (void)
loadRequest:(NSURLRequest *)request appendData:(BOOL)appendData callback:(StatusDataBlock)callback
{
	_loading = YES;
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
	 {
		 id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		 if ([jsonData isKindOfClass:[NSDictionary class]] && jsonData[@"errors"]) {
			 if (callback) {
				 callback(NO, nil);
				 return;
			 }
		 }

		 DataBlock complete = ^(NSArray *tweets) {
			 if (appendData) {
				 [self.innerData addObjectsFromArray:tweets];
			 } else {
				 NSMutableArray *tempData = [tweets mutableCopy];
				 [tempData addObjectsFromArray:self.innerData];
				 self.innerData = tempData;
			 }
			 self.loaded = YES;
			 _loading = NO;
			 if (callback) {
				 callback(YES, tweets);
			 }
		 };

		 if ([jsonData isKindOfClass:[NSArray class]]) {
			 NSArray *tweets = [self unserialize:jsonData];
			 if (self.dataModifier) {
				 [self.dataModifier applyForData:tweets callback:complete];
			 } else {
				 complete(tweets);
			 }
		 }
	 }];
}

- (NSArray *)
unserialize:(NSArray *)rawObjects
{
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:rawObjects.count];
	[rawObjects enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
		[objects addObject:[[Tweet alloc] initWithJSONData:dict]];
	}];
	return objects;
}

@end
