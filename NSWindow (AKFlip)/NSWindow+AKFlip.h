//
//  AKWindowFlip.h
//  TrafficBot
//
//  Created by Adam Ko on 10/12/2010.
//  Copyright 2010 Imperial College. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (AKFlip)

- (void)flipToWindow:(NSWindow *)window;
- (void)flipBackToWindow:(NSWindow *)window;

@end
