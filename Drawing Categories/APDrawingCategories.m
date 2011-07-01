#import "APDrawingCategories.h"


@implementation NSAffineTransform (RectMapping)

- (NSAffineTransform *)mapFrom:(NSRect)srcBounds to:(NSRect)dstBounds {
	NSAffineTransformStruct at;
	at.m11 = (dstBounds.size.width/srcBounds.size.width);
	at.m12 = 0.0;
	at.tX = dstBounds.origin.x - at.m11*srcBounds.origin.x;
	at.m21 = 0.0;
	at.m22 = (dstBounds.size.height/srcBounds.size.height);
	at.tY = dstBounds.origin.y - at.m22*srcBounds.origin.y;
	[self setTransformStruct:at];
	return self;
}

- (NSAffineTransform*)scaleBounds:(NSRect)bounds 
						 toHeight:(float)height 
				 centeredDistance:(float)distance 
					   abovePoint:(NSPoint)location {
	NSRect dst = bounds;
	float scale = height / (float)dst.size.height;
	dst.size.width *= scale;
	dst.size.height *= scale;
	dst.origin.x = location.x - dst.size.width/2.0;
	dst.origin.y = location.y + distance;
	return [self mapFrom:bounds to:dst];
}

- (NSAffineTransform*)scaleBounds:(NSRect)bounds
						 toHeight:(float)height
			  centeredAboveOrigin:(float)distance {
	return [self scaleBounds:bounds toHeight:height centeredDistance:distance abovePoint:NSZeroPoint];
}

- (NSAffineTransform *)flipVertical:(NSRect)bounds {
	NSAffineTransformStruct at;
	at.m11 = 1.0;
	at.m12 = 0.0;
	at.tX = 0;
	at.m21 = 0.0;
	at.m22 = -1.0;
	at.tY = bounds.size.height;
	[self setTransformStruct: at];
	return self;
}
@end


@implementation NSBezierPath (ShadowDrawing)

/* fill a bezier path, but draw a shadow under it offset by the
 given angle (counter clockwise from the x-axis) and distance. */
- (void)fillWithShadowAtDegrees:(float)angle 
						  color:(NSColor *)color 
					 blurRadius:(float)blurRadius 
					   distance:(float)distance {
	
	float radians = angle*(3.141592f/180.0f);
	NSShadow* theShadow = [[NSShadow alloc] init];
	[theShadow setShadowOffset:NSMakeSize(cosf(radians)*distance, sinf(radians)*distance)];
	[theShadow setShadowBlurRadius:blurRadius]; // 3.0
	[theShadow setShadowColor:color]; // [[NSColor blackColor] colorWithAlphaComponent:0.3]
	
	[NSGraphicsContext saveGraphicsState];
	[theShadow set];
	[self fill];
	[NSGraphicsContext restoreGraphicsState];
	[theShadow release];
}
@end


@implementation BezierNSLayoutManager

- (void)dealloc {
	[self setTheBezierPath: nil];
	[super dealloc];
}
- (NSBezierPath *)theBezierPath {
    return [[theBezierPath retain] autorelease];
}
- (void)setTheBezierPath:(NSBezierPath *)value {
	if (theBezierPath == value) return;
	[theBezierPath release];
	theBezierPath = [value retain];
}
/* convert the NSString into a NSBezierPath using a specific font. */
- (void)showPackedGlyphs:(char *)glyphs length:(unsigned)glyphLen
			  glyphRange:(NSRange)glyphRange atPoint:(NSPoint)point font:(NSFont *)font
				   color:(NSColor *)color printingAdjustment:(NSSize)printingAdjustment {
	
	/* if there is a NSBezierPath associated with this layout, then append the glyphs to it. */
	NSBezierPath *bezier = [self theBezierPath];
	if (!bezier) return;
	
	/* add the glyphs to the bezier path */
	[bezier moveToPoint:point];
	[bezier appendBezierPathWithPackedGlyphs:glyphs];
}
@end


@implementation NSString (BezierConversions)

- (NSBezierPath *)bezierWithFont:(NSFont *)theFont {
	/* put the string's text into a text storage so we can access the glyphs through a layout. */
	NSTextStorage *textStore = [[NSTextStorage alloc] initWithString: self];
	NSTextContainer *textContainer = [[NSTextContainer alloc] init];
	BezierNSLayoutManager *myLayout = [[BezierNSLayoutManager alloc] init];
	[myLayout addTextContainer:textContainer];
	[textStore addLayoutManager:myLayout];
	[textStore setFont:theFont];
	
	/* create a new NSBezierPath and add it to the custom layout */
	[myLayout setTheBezierPath:[NSBezierPath bezierPath]];
	
	/* to call drawGlyphsForGlyphRange, we need a destination so we'll set up a temporary one.  Size is unimportant and can be small.  */
	NSImage* theImage = [[NSImage alloc] initWithSize:NSMakeSize(10.0, 10.0)];
	/* lines are drawn in reverse order, so we will draw the text upside down and then flip the resulting NSBezierPath right side up again to achieve our final result with the lines in the right order and the text with proper orientation.  */
	[theImage setFlipped:YES];
	[theImage lockFocus];
	
	/* draw all of the glyphs to collecting them into a bezier path using our custom layout class. */
	NSRange glyphRange = [myLayout glyphRangeForTextContainer:textContainer];
	[myLayout drawGlyphsForGlyphRange:glyphRange atPoint:NSMakePoint(0.0, 0.0)];
	
	[theImage unlockFocus];
	[theImage release];
	
	NSBezierPath *bezier = [myLayout theBezierPath];
	
	[textStore release];
	[textContainer release];
	[myLayout release];
	
	[bezier transformUsingAffineTransform:[[NSAffineTransform transform] flipVertical:[bezier bounds]]];
	
	return bezier;
}
@end




