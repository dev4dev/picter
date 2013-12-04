//
//  FlickrPhoto.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "FlickrPhoto.h"

// 0 - {farm-id}
// 1 - {server-id}
// 2 - {id}
// 3 - {secret}
// 4 - size [thumb - s, big - c]
NSString *const flickrPhotoUrlTemplate = @"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg";

NSString *const kFlickrThumbPhotoSizeFormat = @"s";
NSString *const kFlickrBigPhotoSizeFormat = @"c";

@interface FlickrPhoto()

@property (nonatomic, strong) NSDictionary *jsonData;

- (NSURL *)imageURLForSizeFormat:(NSString *)sizeFormat;

@end

@implementation FlickrPhoto

- (instancetype)
initWithJSONData:(NSDictionary *)jsonData
{
	if (self = [super init]) {
		_jsonData = jsonData;
	}

	return self;
}

- (NSURL *)
imageURLForSizeFormat:(NSString *)sizeFormat
{
	return [NSURL URLWithString:[NSString stringWithFormat:flickrPhotoUrlTemplate, self.jsonData[@"farm"], self.jsonData[@"server"], self.jsonData[@"id"], self.jsonData[@"secret"], sizeFormat]];
}

#pragma mark - Prop Getters

- (NSURL *)
thumbURL
{
	return [self imageURLForSizeFormat:kFlickrThumbPhotoSizeFormat];
}

- (NSURL *)
bigImageURL
{
	return [self imageURLForSizeFormat:kFlickrBigPhotoSizeFormat];
}

@end
