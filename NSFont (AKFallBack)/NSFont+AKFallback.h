//
//  NSFont+AKFallback.h
//  TrafficBot
//
//  Created by Adam Ko on 03/04/2011.
//  Copyright 2011 Imperial College. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFont (NSFont_AKFallback)

+ (NSFont *)ak_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
