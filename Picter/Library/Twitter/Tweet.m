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
	_date = jsonData[@"created_at"];
}

- (NSString *)
description
{
	return [NSString stringWithFormat:@"%@: %@", self.author, self.text];
}

@end
