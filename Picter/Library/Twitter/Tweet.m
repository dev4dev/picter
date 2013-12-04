//
//  Tweet.m
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "Tweet.h"

@interface Tweet()

- (void)assignData:(NSDictionary *)jsonData;
- (NSDateFormatter *)dateFormatter;

@end

@implementation Tweet

- (instancetype)
initWithJSONData:(NSDictionary *)jsonData
{
	if (self = [super init]) {
		[self assignData:jsonData];
	}

	return self;
}

- (void)
assignData:(NSDictionary *)jsonData
{
	_text = jsonData[@"text"];
	_ID = [jsonData[@"id"] unsignedLongLongValue];
	_strID = jsonData[@"id_str"];
	_author = jsonData[@"user"][@"name"];
	if (jsonData[@"created_at"]) {
		_date = [[self dateFormatter] dateFromString:jsonData[@"created_at"]];
	}
}

- (NSString *)
description
{
	return [NSString stringWithFormat:@"%@: %@", self.author, self.text];
}

- (NSDateFormatter *)
dateFormatter
{
	static NSDateFormatter *tweetDateFormatter;
	if (!tweetDateFormatter) {
		tweetDateFormatter = [NSDateFormatter new];
		tweetDateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
	}

	return tweetDateFormatter;
}

- (CGFloat)
contentHeightForWidth:(CGFloat)width withFont:(UIFont *)font
{
	return CGRectGetHeight([self.text boundingRectWithSize:CGSizeMake(width, 0.0)
												   options:NSStringDrawingUsesLineFragmentOrigin
												attributes:@{NSFontAttributeName: font}
												   context:nil]);
}

@end
