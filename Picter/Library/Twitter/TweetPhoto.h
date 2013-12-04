//
//  TweetPhoto.h
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TweetPhoto <NSObject>

@property (nonatomic, readonly) NSURL *thumbURL;
@property (nonatomic, readonly) NSURL *bigImageURL;

@end
