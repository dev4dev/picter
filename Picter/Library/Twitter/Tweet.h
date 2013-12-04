//
//  Tweet.h
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetPhoto.h"

@interface Tweet : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, assign) unsigned long long ID;
@property (nonatomic, copy) NSString *strID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) id<TweetPhoto> photo;

- (instancetype)initWithJSONData:(NSDictionary *)jsonData;
- (CGFloat)contentHeightForWidth:(CGFloat)width withFont:(UIFont *)font;

@end
