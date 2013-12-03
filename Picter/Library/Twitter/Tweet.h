//
//  Tweet.h
//  Picter
//
//  Created by Alex Antonyuk on 12/3/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, assign) unsigned long long ID;
@property (nonatomic, copy) NSString *strID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *date;

- (instancetype)initWithJSONData:(NSDictionary *)jsonData;

@end
