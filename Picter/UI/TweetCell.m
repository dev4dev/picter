//
//  TweetCell.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)
awakeFromNib
{
	[super awakeFromNib];
	self.tweetImageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)
prepareForReuse
{
	[super prepareForReuse];

	self.tweetLabel.attributedText = nil;
	self.tweetImageView.image = [UIImage imageNamed:@"placeholder"];
}

@end
