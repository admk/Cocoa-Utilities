//
//  NSDate+AKCachedDateString.h
//  TrafficBot
//
//  Created by Xitong Gao on 06/08/2011.
//  Copyright 2011 AK.Kloca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_AKCachedDateString)

+ (NSDate *)ak_cachedDateWithString:(NSString *)string;
+ (void)ak_removeCachedDateString:(NSString *)string;

@end
