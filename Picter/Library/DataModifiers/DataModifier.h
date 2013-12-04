//
//  DataModifier.h
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Abstract DataModifier class 
 */
@interface DataModifier : NSObject

- (void)applyForData:(NSArray *)data callback:(DataBlock)callback;

@end
