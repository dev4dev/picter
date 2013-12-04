//
//  ZOMFGDataModifier.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "ZOMFGDataModifier.h"
#import "FlickrDataModifier.h"
#import "RainbowDataModifier.h"

@implementation ZOMFGDataModifier

- (void)
applyForData:(NSArray *)data callback:(DataBlock)callback
{
	RainbowDataModifier *rainbow = [RainbowDataModifier new];
	[rainbow applyForData:data callback:^(id data) {
		FlickrDataModifier *flickr = [FlickrDataModifier new];
		[flickr applyForData:data callback:callback];
	}];
}

@end
