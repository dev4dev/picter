//
//  TwitterPagedResult.h
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataModifier;

typedef NS_ENUM(NSUInteger, TwitterPagedResultOrder) {
	TwitterPagedResultOrderByAsIs,
	TwitterPagedResultOrderByDate,
	TwitterPagedResultOrderByAlpha
};

@interface TwitterPagedResult : NSObject

@property (nonatomic, readonly) NSArray *data;
@property (nonatomic, assign) TwitterPagedResultOrder order;
@property (nonatomic, strong) DataModifier *dataModifier;
@property (nonatomic, readonly) BOOL loading;

- (instancetype)initWithRequest:(SLRequest *)request;
- (void)reset;
- (void)load:(StatusDataBlock)callback;
- (void)loadNextPage:(StatusDataBlock)callback;
- (void)loadPrevPage:(StatusDataBlock)callback;

@end
