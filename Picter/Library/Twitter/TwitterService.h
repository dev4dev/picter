//
//  TwitterService.h
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterPagedResult.h"

@interface TwitterService : NSObject

+ (instancetype)sharedService;

- (void)hasAccess:(StatusBlock)callback;
- (void)systemTwitterUsers:(StatusDataBlock)callback;

+ (TwitterPagedResult *)timeLineForAccount:(ACAccount *)account;

@end
