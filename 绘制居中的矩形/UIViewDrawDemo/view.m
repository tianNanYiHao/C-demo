//
//  view.m
//  UIViewDrawDemo
//
//  Created by tianNanYiHao on 2017/5/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "view.h"

@implementation view

CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
    //
    // Create the boundary path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
    // Top left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
    // Top right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
    // Close the path at the rounded rect
    CGPathCloseSubpath(path);
    
    return path;
}



- (void)drawRect:(CGRect)rect
{
//    rect.size.height = 140;
//    rect.size.width  = 180;
    
    const CGFloat RECT_PADDING = 8.0;
    rect = CGRectInset(rect, (rect.size.width-180)/2, (rect.size.height-140)/2);
    
    const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
    CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat BACKGROUND_OPACITY = 0.85;
    CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextFillPath(context);
    
    const CGFloat STROKE_OPACITY = 0.25;
    CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextStrokePath(context);
    
    CGPathRelease(roundRectPath);
}


@end
