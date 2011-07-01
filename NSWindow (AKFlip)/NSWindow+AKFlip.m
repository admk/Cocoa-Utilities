//
//  AKWindowFlip.m
//  TrafficBot
//
//  Created by Adam Ko on 10/12/2010.
//  Copyright 2010 Imperial College. All rights reserved.
//

#import "NSWindow+AKFlip.h"
#import <QuartzCore/QuartzCore.h>

@class CALayer;

@interface LIEffect : NSObject {
	NSWindow *animationWindow;
}

#pragma mark -
#pragma mark Setup
- (id)initWithAnimationWindowFrame:(NSRect)aFrame;

#pragma mark -
#pragma mark Properties
@property (readonly) NSView *animationView;
@property (readonly) CALayer *animationLayer;
@property (readonly) NSWindow *animationWindow;

#pragma mark -
#pragma mark Actions
- (void)run;

#pragma mark -
#pragma mark Cleanup
- (void)dealloc;

@end

#pragma mark -
@interface NSView (LIEffects)
- (NSBitmapImageRep *)imageRep;
@end

extern NSRect LIRectToScreen(NSRect aRect, NSView *aView);
extern NSRect LIRectFromScreen(NSRect aRect, NSView *aView);
extern NSRect LIRectFromViewToView(NSRect aRect, NSView *fromView, NSView *toView);

#pragma mark -
@implementation LIEffect

#pragma mark -
#pragma mark Setup
- (id)initWithAnimationWindowFrame:(NSRect)aFrame {
	if ((self = [super init])) {
		animationWindow =  [[NSWindow alloc] initWithContentRect:aFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		
		[animationWindow setOpaque:NO];
		[animationWindow setHasShadow:NO];
		[animationWindow setBackgroundColor:[NSColor clearColor]];
		
		[animationWindow.contentView setWantsLayer:YES];
		
		CATransform3D transform = CATransform3DIdentity;  
		transform.m34 = 1.0 / -850; 
		
		[CATransaction begin];
		CALayer *layer = [animationWindow.contentView layer];	
		layer.sublayerTransform = transform;
		[CATransaction commit];
	}
	
	return self;
}

#pragma mark -
#pragma mark Properties
- (NSWindow *)animationWindow {
	return animationWindow;
}
- (NSView *)animationView {
	return [animationWindow contentView];
}
- (CALayer *)animationLayer {
	return [animationWindow.contentView layer];
}

#pragma mark -
#pragma mark Actions
- (void)run {
	[animationWindow orderFront:self];
}

#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	[animationWindow release], animationWindow = nil;
	[super dealloc];
}

@end

#pragma mark -
@implementation NSView (LIEffects)
- (NSBitmapImageRep *)imageRep {
	BOOL visible = self.window.isVisible;
	NSRect oldFrame = self.window.frame;
	
	if (! visible) {		
		NSDisableScreenUpdates();
		[self.window setFrame:NSOffsetRect(oldFrame, -10000, -10000) display:NO];
		[self.window orderFront:self];
	}
	
	NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
	[self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
	
	if (! visible) {
		[self.window orderOut:self];
		[self.window setFrame:oldFrame display:NO];
		NSEnableScreenUpdates();
	}
	
	return rep;
}
@end

NSRect LIRectToScreen(NSRect aRect, NSView *aView) {
	aRect = [aView convertRect:aRect toView:nil];
	aRect.origin = [aView.window convertBaseToScreen:aRect.origin];
	return aRect;
}
NSRect LIRectFromScreen(NSRect aRect, NSView *aView) {
	aRect.origin = [aView.window convertScreenToBase:aRect.origin];
	aRect = [aView convertRect:aRect fromView:nil];
	return aRect;
}

NSRect LIRectFromViewToView(NSRect aRect, NSView *fromView, NSView *toView) {
	aRect = LIRectToScreen(aRect, fromView);
	aRect = LIRectFromScreen(aRect, toView);
	
	return aRect;
}

#pragma mark -
@interface LIFlipEffect : LIEffect {
	NSUInteger done;
	NSWindow *fromWindow, *toWindow;
	NSBitmapImageRep *fromImage, *toImage;
}

#pragma mark -
#pragma mark Setup
- (id)initFromWindow:(NSWindow *)aFromWindow toWindow:(NSWindow *)aToWindow;

#pragma mark -
#pragma mark PRoperties
@property (readonly) NSWindow *fromWindow, *toWindow;

#pragma mark -
#pragma mark Actions
- (void)run:(BOOL)mirrored;

#pragma mark -
#pragma mark Cleanup
- (void)dealloc;

@end

#pragma mark -
@implementation LIFlipEffect

- (id)initFromWindow:(NSWindow *)w1 toWindow:(NSWindow *)w2 {
	CGFloat maxWidth = MAX(NSWidth(w1.frame), NSWidth(w2.frame));
	CGFloat maxHeight = MAX(NSHeight(w1.frame), NSHeight(w2.frame));
	
	// add some slop for our rotation
	maxWidth += 2;
	maxHeight += 200;
	
	NSRect animationFrame;
	animationFrame.origin.x = NSMidX(w1.frame) - (maxWidth / 2);
	animationFrame.origin.y = NSMidY(w1.frame) - (maxHeight / 2);
	animationFrame.size.width = maxWidth;
	animationFrame.size.height = maxHeight;
	
	if ((self = [super initWithAnimationWindowFrame:animationFrame])) {
		fromWindow = [w1 retain];
		toWindow = [w2 retain];
		
		// fix window positions so that toWindow is positioned similarly to fromWindow
		
		NSRect fromFrame = fromWindow.frame;
		NSRect toFrame = toWindow.frame;
		
		toFrame.origin.x = NSMidX(fromFrame) - (NSWidth(toFrame) / 2);
		toFrame.origin.y = NSMaxY(fromFrame) - NSHeight(toFrame);
		
		[toWindow setFrame:toFrame display:NO];
	}
	return self;
}

#pragma mark -
#pragma mark Properties
@synthesize fromWindow, toWindow;

#pragma mark -
#pragma mark Actions

#define PI 3.14159

- (void)run:(BOOL)mirrored {
	NSView *fromView, *toView;
	fromView = [fromWindow.contentView superview];
	toView = [toWindow.contentView superview];
	
	fromImage = [fromView.imageRep retain];
	
	[toWindow setAlphaValue:0.0];
	[toWindow makeKeyAndOrderFront:self];
	
	toImage = [toView.imageRep retain];
	
	CATransform3D fromStart, fromEnd, toStart, toEnd;
	if (mirrored) {
		fromStart = CATransform3DMakeRotation(0, 0, 1, 0);
		fromEnd = CATransform3DMakeRotation(PI, 0, 1, 0);
		toStart = CATransform3DMakeRotation(PI, 0, 1, 0);
		toEnd = CATransform3DMakeRotation(PI * 2, 0, 1, 0);
	}
	else {
		fromStart = CATransform3DMakeRotation(PI * 2, 0, 1, 0);
		fromEnd = CATransform3DMakeRotation(PI, 0, 1, 0);
		toStart = CATransform3DMakeRotation(PI, 0, 1, 0);
		toEnd = CATransform3DMakeRotation(0, 0, 1, 0);
	}

	
	CALayer *fromLayer = [CALayer layer];
	fromLayer.contents = (id)fromImage.CGImage;
	fromLayer.frame = NSRectToCGRect(LIRectFromViewToView(fromView.frame, fromView, self.animationView));
	fromLayer.transform = fromStart;
	fromLayer.doubleSided = NO;
	
	[self.animationLayer addSublayer:fromLayer];
	
	CALayer *toLayer = [CALayer layer];
	toLayer.contents = (id)toImage.CGImage;
	toLayer.frame = NSRectToCGRect(LIRectFromViewToView(toView.frame, toView, self.animationView));
	toLayer.transform = toStart;
	toLayer.doubleSided = NO;
	
	[self.animationLayer addSublayer:toLayer];
	
	[super run];
	
	[fromWindow orderOut:self];
	
	CABasicAnimation *fromAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	fromAnimation.duration = 0.35;
	fromAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	fromAnimation.toValue = [NSValue valueWithBytes:&fromEnd objCType:@encode(CATransform3D)];
	
	fromAnimation.fillMode = kCAFillModeForwards;
	fromAnimation.removedOnCompletion = NO;
	
	CABasicAnimation *toAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	toAnimation.duration = 0.35;
	toAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	toAnimation.toValue = [NSValue valueWithBytes:&toEnd objCType:@encode(CATransform3D)];
	
	toAnimation.fillMode = kCAFillModeForwards;
	toAnimation.removedOnCompletion = NO;
	
	toAnimation.delegate = self;
	
	[CATransaction begin];
	[fromLayer addAnimation:fromAnimation forKey:@"flip"];
	[toLayer addAnimation:toAnimation forKey:@"flip"];
	[CATransaction commit];
	
	done = 0;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if (flag) {
		[toWindow setAlphaValue:1.0];
		[self.animationWindow orderOut:self];
		//[self release];
	}
}

#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	[fromWindow release], fromWindow = nil;
	[toWindow release], toWindow = nil;
	
	[fromImage release], fromImage = nil;
	[toImage release], toImage = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark Category
@implementation NSWindow (AKWindowFlip)

- (void)flipToWindow:(NSWindow *)window {
	NSAssert(![window isVisible], @"cannot flip, window is already on screen");
	NSAssert([self isVisible], @"cannot flip without self being visible");
	[[[[LIFlipEffect alloc] initFromWindow:self toWindow:window] autorelease] run:NO];
}
- (void)flipBackToWindow:(NSWindow *)window {
	NSAssert(![window isVisible], @"cannot flip, window is already on screen");
	NSAssert([self isVisible], @"cannot flip without self being visible");
	[[[[LIFlipEffect alloc] initFromWindow:self toWindow:window] autorelease] run:YES];
}

@end
