//
//  NSDate+AKCachedDateString.m
//  TrafficBot
//
//  Created by Xitong Gao on 06/08/2011.
//  Copyright 2011 AK.Kloca. All rights reserved.
//

#import "NSDate+AKCachedDateString.h"

@interface _AKDateStringMapCache : NSObject
{
@private
    NSMutableDictionary *_map;
}

+ (_AKDateStringMapCache *)sharedCache;

- (NSDate *)dateWithString:(NSString *)string;
- (void)removeCachedDateString:(NSString *)string;

@end

@implementation _AKDateStringMapCache

+ (_AKDateStringMapCache *)sharedCache
{
	static dispatch_once_t pred;
	static _AKDateStringMapCache *_sharedCache = nil;
	dispatch_once(&pred, ^{
		_sharedCache = [[_AKDateStringMapCache alloc] init];
	});
	return _sharedCache;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;

    _map = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)dealloc
{
    [_map release], _map = nil;
    [super dealloc];
}

- (NSDate *)dateWithString:(NSString *)string
{
	NSDate *date = nil;
	@synchronized(self)
	{
		date = [_map objectForKey:string];
		if (!date)
		{
			date = [NSDate dateWithString:string];
			[_map setObject:date forKey:string];
		}
		[date retain];
	}
	return [date autorelease];
}

- (void)removeCachedDateString:(NSString *)string
{
	@synchronized(self)
	{
		[_map removeObjectForKey:string];
	}
}

@end

@implementation NSDate (NSDate_AKCachedDateString)

+ (NSDate *)ak_cachedDateWithString:(NSString *)string
{
    return [[_AKDateStringMapCache sharedCache] dateWithString:string];
}

+ (void)ak_removeCachedDateString:(NSString *)string
{
    [[_AKDateStringMapCache sharedCache] removeCachedDateString:string];
}

@end
