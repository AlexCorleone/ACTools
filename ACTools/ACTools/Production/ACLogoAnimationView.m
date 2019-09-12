//
//  ACLogoAnimationView.m
//  ACTools
//
//  Created by arges on 2019/9/7.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACLogoAnimationView.h"
#import <CoreGraphics/CoreGraphics.h>

#define ACAngleUnit (0.15 / (M_PI))

@interface ACLogoAnimationView ()
{
    NSInteger displayCounter;
}

/** <#注释#> */
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ACLogoAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:54/255.0 green:117/255.0 blue:231/255.0 alpha:1.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.0, CGRectGetHeight(rect) / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat outerCircleRadius = MIN(center.x, center.y) - 10/*边距*/;
//    NSLog(@"%lf", - M_PI_2);
//    NSLog(@"%lf", M_PI_2);
//    NSLog(@"%lf", -M_PI);
//    NSLog(@"%lf", M_PI);
    
//    CFArrayRef cfColors = CFArrayCreate(kCFAllocatorDefault, (const void *[]){UIColor.redColor.CGColor, UIColor.purpleColor.CGColor, UIColor.yellowColor.CGColor}, 3, nil);
//    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), cfColors, nil);
//    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsBeforeStartLocation);
//    CFRelease(cfColors);
//    CFRelease(gradient);
    
    //右侧 0 下方 M_PI_2  左侧  M_PI  上方 -M_PI_2  clockwise 0 顺时针 1 逆时针
    //绘制外圆
    NSInteger counter = (displayCounter / 1);
    CGFloat leftAngle = counter * ACAngleUnit;
    if (leftAngle <= M_PI_2) {
        leftAngle = -M_PI_2 - leftAngle;
    } else if(leftAngle < M_PI_2 + M_PI_4) {
        leftAngle = M_PI - (leftAngle - M_PI_2);
    } else {
        leftAngle = M_PI_2 + M_PI_4;
    }
    CGContextAddArc(ctx, center.x, center.y, outerCircleRadius, -M_PI_2, leftAngle, 1);
    CGContextSetLineWidth(ctx, 6.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextStrokePath(ctx);
    
    CGFloat rightAngle = counter * ACAngleUnit;
    if (rightAngle <= M_PI_2) {
        rightAngle = -M_PI_2 + 1 * rightAngle;
    } else if(rightAngle < M_PI_2 + M_PI_4) {
        rightAngle =  rightAngle - M_PI_2;
    } else {
        rightAngle = M_PI_4;
    }
    CGContextAddArc(ctx, center.x, center.y, outerCircleRadius, -M_PI_2, rightAngle, 0);
    CGContextSetLineWidth(ctx, 6.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextStrokePath(ctx);
    
    CGPoint currentPoint = CGPointMake(center.x, center.y - outerCircleRadius);
    
    CGFloat lineHeight = displayCounter;
    if (lineHeight > 10) {
        lineHeight = 10;
    }
    //绘制外圆与内圆的连接线
    CGContextMoveToPoint(ctx, currentPoint.x, currentPoint.y);
    CGContextAddLineToPoint(ctx, center.x, center.y - (outerCircleRadius - 10));
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextStrokePath(ctx);
    currentPoint = CGPointMake(center.x, center.y - (outerCircleRadius - 10));
    
    CGFloat innerCircleRadius = (outerCircleRadius - 10);
    //绘制内圆
    CGContextAddArc(ctx, center.x, center.y, innerCircleRadius, -M_PI_2, counter * (ACAngleUnit / 3 * 8), 0);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextStrokePath(ctx);

    //绘制内部圆点
    CGFloat pointRadius = innerCircleRadius - 6;
    CGContextAddArc(ctx, center.x, center.y, pointRadius, -M_PI_2, M_PI_2, 0);
    CGContextSetFillColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextFillPath(ctx);
    
    CGContextAddArc(ctx, center.x, center.y, pointRadius, M_PI_2, -M_PI_2, 0);
    CGContextSetFillColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextFillPath(ctx);
    
    if ((leftAngle == M_PI_2 + M_PI_4 && rightAngle == M_PI_4)
        && lineHeight == 10
        && (counter * ACAngleUnit > M_PI * 2)) {
        [self stopAnimation];
    }
}

#pragma mark - Public

- (void)startAnimation {
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}
- (void)stopAnimation {
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Private

- (void)displayPerformAction:(CADisplayLink *)displayLink {
//    NSLog(@"------------%@ counter:(%@)", @(displayLink.duration), @(displayCounter));
    displayCounter ++;
    [self setNeedsDisplay];
}

#pragma mark - Setter && Getter

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(displayPerformAction:)];
    }
    return _displayLink;
}
@end
