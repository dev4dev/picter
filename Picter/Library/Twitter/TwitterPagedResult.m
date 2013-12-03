//
//  TwitterPagedResult.m
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "TwitterPagedResult.h"
#import "Tweet.h"

@interface TwitterPagedResult()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSMutableArray *innerData;

// for paging
@property (nonatomic, copy) NSString *sinceID;
@property (nonatomic, copy) NSString *maxID;

- (NSArray *)unserialize:(NSArray *)rawObjects;

@end

@implementation TwitterPagedResult

- (instancetype)
initWithURLRequest:(NSURLRequest *)request
{
	if (self = [super init]) {
		_request = request;
		_innerData = [NSMutableArray array];
	}

	return self;
}

- (NSArray *)
data
{
	return self.innerData;
}


- (void)
reset
{
	self.innerData = [NSMutableArray array];
	self.sinceID = nil;
	self.maxID = nil;
}

- (void)
load:(StatusDataBlock)callback
{
	[NSURLConnection sendAsynchronousRequest:self.request
									   queue:[NSOperationQueue mainQueue
											  ]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
	{
		id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		if ([jsonData isKindOfClass:[NSDictionary class]] && jsonData[@"error"]) {
			if (callback) {
				callback(NO, nil);
				return;
			}
		}

		if ([jsonData isKindOfClass:[NSArray class]]) {
			NSArray *tweets = [self unserialize:jsonData];
			[self.innerData addObjectsFromArray:tweets];
			if (callback) {
				callback(YES, tweets);
			}
		}
	}];
}

- (void)
loadNextPage:(StatusDataBlock)callback
{

}

- (void)
loadPrevPage:(StatusDataBlock)callback
{
	
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
