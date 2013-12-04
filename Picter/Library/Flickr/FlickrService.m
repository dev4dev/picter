//
//  FlickrService.m
//  Picter
//
//  Created by Alex Antonyuk on 12/4/13.
//  Copyright (c) 2013 Alex Antonyuk. All rights reserved.
//

#import "FlickrService.h"
#import "FlickrPhoto.h"

NSString *const FlickrAPIEndpoint = @"http://api.flickr.com/services/rest/?";

@interface FlickrService()

@property (nonatomic, copy) NSString *apiKey;

@end

@implementation FlickrService

+ (instancetype)
sharedService
{
    static dispatch_once_t once;
    static FlickrService *instance;
    dispatch_once(&once, ^ {
        instance = [[FlickrService alloc] initWithAPIKey:FlickrAPIKey];
    });
    return instance;
}

- (instancetype)
initWithAPIKey:(NSString *)apiKey
{
	if (self = [super init]) {
		_apiKey = apiKey;
	}

	return self;
}

- (void)
searchForImagesByTags:(NSArray *)tags count:(NSInteger)count callback:(DataBlock)callback
{
	NSString *requestURLString = [FlickrAPIEndpoint stringByAppendingFormat:@"method=flickr.photos.search&api_key=%@&tags=%@&per_page=%@&format=json", self.apiKey, [tags componentsJoinedByString:@","], @(count)];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
	{
		NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
		if (httpResp.statusCode != 200 || connectionError || data.length == 0) {
			if (callback) {
				callback(nil);
				return;
			}
		}

		NSString *jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"jsonFlickrApi(" withString:@""];
		jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@")"]];
		NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
																 options:0
																   error:nil];
		if (jsonData && jsonData[@"photos"] && [jsonData[@"stat"] isEqualToString:@"ok"]) {
			NSArray *jsonPhotos = jsonData[@"photos"][@"photo"];
			NSMutableArray *photos = [NSMutableArray arrayWithCapacity:jsonPhotos.count];
			[jsonPhotos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
				[photos addObject:[[FlickrPhoto alloc] initWithJSONData:obj]];
			}];
			if (callback) {
				callback(photos);
			}
		} else {
			NSLog(@"flickr error %@", jsonData[@"message"]);
		}
	}];
}

@end
