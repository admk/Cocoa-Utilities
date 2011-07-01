//
//  NSDate+AKMidnight.m
//
//  Created by Adam Ko on 26/11/2010.
//  Copyright 2010 Loca Apps. All rights reserved.
//

#import "NSDate+AKMidnight.h"

#define NEXT_HOUR_FLAGS  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit
#define NEXT_DAY_FLAGS   NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
#define NEXT_MONTH_FLAGS NSYearCalendarUnit | NSMonthCalendarUnit

@interface NSDate (AKMidnight_Private)
- (NSDate *)_dateWithMidnightFlags:(NSUInteger)flags;
@end


@implementation NSDate (AKMidnight)
- (NSDate *)nextHour {
	return [self _dateWithMidnightFlags:NEXT_HOUR_FLAGS];
}

- (NSDate *)midnightTomorrow {
	return [self _dateWithMidnightFlags:NEXT_DAY_FLAGS];
}

- (NSDate *)midnightNextMonth {
	return [self _dateWithMidnightFlags:NEXT_MONTH_FLAGS];
}
@end


@implementation NSDate (AKMidnight_Private)

// a sad memory/performance trade-off
static NSCalendar *gregorian = nil;

- (NSDate *)_dateWithMidnightFlags:(NSUInteger)flags {
	if (!gregorian) gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	switch (flags) {
		case NEXT_HOUR_FLAGS:  components.hour  = 1; break;
		case NEXT_DAY_FLAGS:   components.day   = 1; break;
		case NEXT_MONTH_FLAGS: components.month = 1; break;
		default: break;
	}
	NSDate *nextNow = [gregorian dateByAddingComponents:components toDate:self options:0]; // now + 1 hour/day/month
	components = [gregorian components:flags fromDate:nextNow];
	return [gregorian dateFromComponents:components];
}

@end
