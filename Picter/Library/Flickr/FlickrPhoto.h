//
//  FlickrPhoto.h
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetPhoto.h"

@interface FlickrPhoto : NSObject
	<TweetPhoto>

- (instancetype)initWithJSONData:(NSDictionary *)jsonData;

@end
