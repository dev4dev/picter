//
//  FlickrDataModifier.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "FlickrDataModifier.h"
#import "Tweet.h"
#import "FlickrService.h"
#import "FlickrPhoto.h"

@interface FlickrDataModifier()

- (NSString *)getAnythingFromTweet:(Tweet *)tweet;

@end

@implementation FlickrDataModifier

- (void)
applyForData:(NSArray *)data callback:(DataBlock)callback
{
	NSMutableArray *tags = [NSMutableArray arrayWithCapacity:data.count];
	[data enumerateObjectsUsingBlock:^(Tweet *tweet, NSUInteger idx, BOOL *stop) {
		[tags addObject:[self getAnythingFromTweet:tweet]];
		if (idx > 2) {
			*stop = YES;
		}
	}];
	// :3
	[tags addObject:@"cat"];

	[[FlickrService sharedService] searchForImagesByTags:tags count:data.count callback:^(NSArray *photos) {
		if (photos) {
			[photos enumerateObjectsUsingBlock:^(FlickrPhoto *photo, NSUInteger idx, BOOL *stop) {
				if (idx < data.count) {
					Tweet *tweet = data[idx];
					tweet.photo = photo;
				} else {
					*stop = YES;
				}
			}];
		}

		if (callback) {
			callback(data);
		}
	}];
}

- (NSString *)
getAnythingFromTweet:(Tweet *)tweet
{
	NSArray *words = [tweet.text componentsSeparatedByString:@" "];
	return [words.firstObject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
