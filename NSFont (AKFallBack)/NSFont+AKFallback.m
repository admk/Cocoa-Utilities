//
//  NSFont+AKFallback.m
//  TrafficBot
//
//  Created by Adam Ko on 03/04/2011.
//  Copyright 2011 Imperial College. All rights reserved.
//

#import "NSFont+AKFallback.h"


@implementation NSFont (NSFont_AKFallback)

+ (NSFont *)ak_fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
	NSFont *font = [NSFont fontWithName:fontName size:fontSize];
	if (!font)
	{
		ALog(@"Missing font: %@", fontName);
		font = [NSFont systemFontOfSize:fontSize];
	}
	return font;
}

@end
