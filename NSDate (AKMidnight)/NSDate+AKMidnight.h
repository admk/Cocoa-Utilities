//
//  NSDate+AKMidnight.h
//
//  Created by Adam Ko on 26/11/2010.
//  Copyright 2010 Loca Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSDate (AKMidnight) 

- (NSDate *)nextHour;
- (NSDate *)midnightTomorrow;
- (NSDate *)midnightNextMonth;

@end
