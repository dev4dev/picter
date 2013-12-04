//
//  FlickrService.h
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrService : NSObject

+ (instancetype)sharedService;
- (void)searchForImagesByTags:(NSArray *)tags count:(NSInteger)count callback:(DataBlock)callback;

@end
