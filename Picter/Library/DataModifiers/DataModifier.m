//
//  DataModifier.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "DataModifier.h"

@implementation DataModifier

- (void)
applyForData:(NSArray *)data callback:(DataBlock)callback
{
	NSLog(@"override in child class");
}

@end
