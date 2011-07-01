#import <Cocoa/Cocoa.h>


@interface NSAffineTransform (RectMapping)

- (NSAffineTransform *)mapFrom:(NSRect)srcBounds to:(NSRect)dstBounds;

- (NSAffineTransform*)scaleBounds:(NSRect)bounds 
						 toHeight:(float)height 
				 centeredDistance:(float)distance 
					   abovePoint:(NSPoint)location;

- (NSAffineTransform*)scaleBounds:(NSRect)bounds
						 toHeight:(float)height
			  centeredAboveOrigin:(float)distance;

- (NSAffineTransform*)flipVertical:(NSRect)bounds;

@end


@interface NSBezierPath (ShadowDrawing)

- (void)fillWithShadowAtDegrees:(float)angle 
						  color:(NSColor *)color 
					 blurRadius:(float)blurRadius 
					   distance:(float)distance;
@end


@interface BezierNSLayoutManager : NSLayoutManager {
	NSBezierPath *theBezierPath;
}
- (void)dealloc;

- (NSBezierPath *)theBezierPath;
- (void)setTheBezierPath:(NSBezierPath *)value;

- (void)showPackedGlyphs:(char *)glyphs length:(unsigned)glyphLen
		glyphRange:(NSRange)glyphRange atPoint:(NSPoint)point font:(NSFont *)font
		color:(NSColor *)color printingAdjustment:(NSSize)printingAdjustment;
@end

@interface NSString (BezierConversions)

- (NSBezierPath *)bezierWithFont:(NSFont *)theFont;

@end


