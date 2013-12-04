//
//  RainbowDataModifier.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "RainbowDataModifier.h"
#import "Tweet.h"

@interface RainbowDataModifier()

- (NSAttributedString *)colorizeText:(NSString *)text;

@end

@implementation RainbowDataModifier

- (void)
applyForData:(NSArray *)data callback:(DataBlock)callback
{
	[data enumerateObjectsUsingBlock:^(Tweet *tweet, NSUInteger idx, BOOL *stop) {
		tweet.attributedText = [self colorizeText:tweet.text];
	}];

	if (callback) {
		callback(data);
	}
}

- (NSAttributedString *)
colorizeText:(NSString *)text
{
	static NSArray *rainbowColors;
	if (!rainbowColors) {
		rainbowColors = @[
			[UIColor redColor],
			[UIColor orangeColor],
			[UIColor yellowColor],
			[UIColor greenColor],
			[UIColor cyanColor],
			[UIColor blueColor],
			[UIColor purpleColor]
		];
	}
	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
	if (text.length < 7) {
		[attrStr setAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]} range:NSMakeRange(0, text.length)];
	} else {
		// raw loop, can leave black tail %)
		NSInteger length = text.length / 7;
		for (int i = 0; i < 7; ++i) {
			[attrStr setAttributes:@{
				NSForegroundColorAttributeName: rainbowColors[i]
			} range:NSMakeRange(i * length, length)];
		}
	}

	return attrStr;
}

@end
