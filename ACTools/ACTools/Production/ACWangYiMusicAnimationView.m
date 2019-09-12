//
//  ACWangYiMusicAnimationView.m
//  ACTools
//
//  Created by Alex on 2019/9/9.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACWangYiMusicAnimationView.h"
#import <CoreGraphics/CoreGraphics.h>

//刷新频率、帧频率
#define kAnimationCircleTime 60
//最大高峰点随机动画线的长度系数
#define kArcMaxPeaksLineHeight 5
//高峰动画线最小值长度
#define kMinPeaksLineHeight 2
//波峰最大值
#define kMaxPeaksLineHeight 30
//最大高峰点个数
#define kArcMaxPeaksPoints 5
//最少高峰点个数
#define kArcMinPeaksPoints 4
//相邻动画线的高度差基准
#define kPeaksLineSpace 4
//最小角度单元
#define ACAngleUnit (0.01 / (M_PI))

@interface ACPeaksPoint : NSObject

/** 动画线高度 */
@property (nonatomic, assign) CGFloat lineHeight;
/** 动画线下标 */
@property (nonatomic, assign) NSInteger lineIndex;
/** 波点宽度 */
@property (nonatomic, assign) NSInteger pointsNumber;
/** 依附的波峰index */
@property (nonatomic, strong) NSMutableArray <NSNumber *> *peaksLineIndexs;

@end

@implementation ACPeaksPoint

- (NSMutableArray<NSNumber *> *)peaksLineIndexs {
    if (!_peaksLineIndexs) {
        _peaksLineIndexs = @[].mutableCopy;
    }
    return _peaksLineIndexs;
}

@end

@interface ACWangYiMusicAnimationView ()

/** 绘制刷新时间 */
@property (nonatomic, strong) CADisplayLink *animationTimer;
/** 子线程处理 */
@property (nonatomic, strong) NSThread *animationThread;
/** 动画波峰数据 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, ACPeaksPoint *> *peaksDictionary;
/** 动画波峰附属数据 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, ACPeaksPoint *> *peaksLinesDictionary;
/** 动画方向 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *> *animationDirectDictionary;
/** 圆点个数 */
@property (nonatomic, assign) NSInteger pointsCount;

@end

@implementation ACWangYiMusicAnimationView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:54/255.0 green:117/255.0 blue:231/255.0 alpha:1.0];
        [self.animationThread start];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = MIN(center.x, center.y) - 50/*边距*/;
    //绘制内圆
    NSInteger i = 0;
    CGFloat beginAngle = M_PI;
    CGFloat startAngle = beginAngle;
    CGFloat endAngle = beginAngle;
    CGFloat arcAngleValue = ACAngleUnit;
    CGFloat strokeAngle = 0;
    while (YES) {
        startAngle = endAngle;
        endAngle = startAngle + arcAngleValue/*弧点宽度*/;
        [self redrawArcAnglePointWithContext:ctx
                                      center:center
                                  startAngle:startAngle
                                    endAngle:endAngle
                                      radius:radius];
        
        //绘制动画线
        CGFloat middleAngle = startAngle + arcAngleValue;
        CGFloat distance = 0;
        if (self.peaksDictionary && [self.peaksDictionary.allKeys containsObject:@(i).stringValue]) {
            ACPeaksPoint *animaModel = self.peaksDictionary[@(i).stringValue];
//            [self resetAnimationLineHeightWithAnimaModel:animaModel];
            distance = [self peaksModelLineHeightWith:animaModel];
            animaModel.lineHeight = distance;
        }
        distance = distance < 0 ? 2 : distance;
            [self redrawLineWithContext:ctx
                                 center:center
                                  angle:middleAngle
                                 radius:radius
                               distance:distance];
        //跳过绘制间距
        endAngle = endAngle + ACAngleUnit * 20/*弧点间距*/;
        //计算渲染角度
        strokeAngle = strokeAngle + arcAngleValue + ACAngleUnit * 20;
        i++;
        self.pointsCount = i;
//        NSLog(@"startAngle : %@ -- endAngle : %@", @(startAngle), @(endAngle));
        if (strokeAngle + arcAngleValue > M_PI * 2) {
//            NSLog(@"圆点园绘制结束！！！！！！！！！！！！");
            break;
        }
    }
}

#pragma mark - Public

- (void)startMusicAnimation {
    [self performSelector:@selector(addTimerToRunloop)
                 onThread:self.animationThread
               withObject:nil
            waitUntilDone:NO];
}

- (void)stopMusicAnimation {
    [self performSelector:@selector(removeTimerFromRunllop)
                 onThread:self.animationThread
               withObject:nil
            waitUntilDone:NO];
}

- (void)addTimerToRunloop {
    [self.animationTimer addToRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSRunLoopCommonModes];
}

- (void)removeTimerFromRunllop {
    [self.animationTimer removeFromRunLoop:[NSRunLoop currentRunLoop]
                                   forMode:NSRunLoopCommonModes];
}

#pragma mark - Private

- (void)redrawArcAnglePointWithContext:(CGContextRef)ctx
                                center:(CGPoint)center
                                 startAngle:(CGFloat)startAngle
                              endAngle:(CGFloat)endAngle
                                radius:(CGFloat)radius {
    CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextStrokePath(ctx);
}

- (void)redrawLineWithContext:(CGContextRef)ctx
                       center:(CGPoint)center
                        angle:(CGFloat)angle
                       radius:(CGFloat)radius distance:(CGFloat)distance {
    CGFloat lineHeight = distance;
    CGFloat outerCircleRadius = radius + lineHeight;
    
    CGPoint startPoint = [self.class calcCircleCoordinateWithCenter:center
                                                       andWithAngle:angle
                                                      andWithRadius:radius];
    CGPoint endPoint = [self.class calcCircleCoordinateWithCenter:center
                                                     andWithAngle:angle
                                                    andWithRadius:outerCircleRadius];
    
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor.CGColor);
    CGContextStrokePath(ctx);
}

/* https://blog.csdn.net/t59651090t/article/details/81189043
 * 已知圆心、半径、角度、获取圆弧上的点坐标
 */
+ (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center
                             andWithAngle:(CGFloat)angle
                            andWithRadius:(CGFloat)radius {
    CGFloat x2 = radius * cos(angle);
    CGFloat y2 = radius * sin(angle);
    return CGPointMake(center.x + x2, center.y + y2);
}

- (void)animationThreadRunSelector {
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (NSDictionary <NSString *, ACPeaksPoint *> *)peaksPointsDictionary {
    NSMutableDictionary <NSString *, ACPeaksPoint *> *peaksDictionary = @{}.mutableCopy;
    self.animationDirectDictionary = @{}.mutableCopy;
    NSInteger peaksNumber = (arc4random() % kArcMaxPeaksPoints) + kArcMinPeaksPoints/*最小值*/;//高峰点个数
    //获取波峰顶点
//    NSArray <NSNumber *> *peakIndexArray =  @[@(5), @(7), @(10), @(16), @(20), @(48), @(53), @(60), @(80)];
//    NSArray <NSNumber *> *peakNumberArray = @[@(5), @(7), @(5),  @(9),  @(5),  @(5),  @(4),  @(3),  @(5)];

    for (NSInteger i = 0; i < peaksNumber; i++) {
        @autoreleasepool {
            ACPeaksPoint *peaksModel = [ACPeaksPoint new];
            peaksModel.lineIndex = (arc4random() % ((int)(self.pointsCount)));//高峰点下标;
            peaksModel.pointsNumber = (arc4random() % 5) + 5/*最小波点宽度*/;//波点宽度;
            NSInteger spaceCount = (peaksModel.pointsNumber % 2) == 0 ? (peaksModel.pointsNumber / 2 ) : ((peaksModel.pointsNumber) / 2 + 1);
            peaksModel.lineHeight = (kPeaksLineSpace * (spaceCount)) + kMinPeaksLineHeight/*最小值*/;
            [peaksModel.peaksLineIndexs addObject:@(peaksModel.lineIndex)];
            [peaksDictionary setValue:peaksModel forKey:@(peaksModel.lineIndex).stringValue];
            [self.animationDirectDictionary setValue:@(1) forKey:@(peaksModel.lineIndex).stringValue];
        }
    }    
    //获取波峰附近的动画点
    NSArray *peaksAllKeys = peaksDictionary.allKeys;
    for (NSInteger i = 0; i < peaksAllKeys.count; i++) {
        NSString *peaksKey = peaksAllKeys[i];
        //波峰
        ACPeaksPoint *peaksModel = [peaksDictionary valueForKey:peaksKey];
        NSInteger firstIndex = peaksModel.lineIndex - (int)(peaksModel.pointsNumber / 2);
        for (NSInteger j = 0; j < peaksModel.pointsNumber; j++) {
            NSInteger peaksIndex = firstIndex + j;
            NSInteger spaceCount = abs((int)(peaksIndex - peaksModel.lineIndex));
            CGFloat newLineHeight = peaksModel.lineHeight - spaceCount * kPeaksLineSpace/*相邻动画线的长度差*/;
            if ([peaksDictionary.allKeys containsObject:@(peaksIndex).stringValue]) {
                ACPeaksPoint *peaksLineModel = [peaksDictionary valueForKey:@(peaksIndex).stringValue];
                if (peaksLineModel.lineIndex == peaksLineModel.peaksLineIndexs.firstObject.integerValue) {
                    continue;
                }
                newLineHeight = peaksLineModel.lineHeight > newLineHeight ? peaksLineModel.lineHeight : newLineHeight;
                peaksLineModel.lineHeight = newLineHeight;
                [peaksLineModel.peaksLineIndexs removeAllObjects];
                [peaksLineModel.peaksLineIndexs addObject:@(peaksModel.lineIndex)];
            } else {
                ACPeaksPoint *peaksLineModel = [ACPeaksPoint new];
                peaksLineModel.lineIndex = peaksIndex;
                peaksLineModel.lineHeight = newLineHeight;
                [peaksLineModel.peaksLineIndexs addObject:@(peaksModel.lineIndex)];
                [peaksDictionary setValue:peaksLineModel forKey:@(peaksIndex).stringValue];
            }
        }
    }
    return peaksDictionary.copy;
}

- (void)resetAnimationDirection {
    NSArray *animationKeys = self.animationDirectDictionary.allKeys;
    for (NSInteger i = 0; i < animationKeys.count; i++) {
        NSString *animaKey = animationKeys[i];
        if (self.animationDirectDictionary && [self.animationDirectDictionary.allKeys containsObject:animaKey]) {
            NSInteger arcRandomValue = (arc4random() % 2000);
            NSInteger direction = ((arcRandomValue % 2) == 0) ? -1 : 1;
            NSInteger directValue = (((arc4random() % 2000) % 5) < 4) ? (((arc4random() % 2000) % 2) + 1) : (((arc4random() % 2000) % 3) + 1);
            [self.animationDirectDictionary setValue:@(direction * directValue) forKey:animaKey];
        }
    }
}

- (void)resetAnimationLineHeightWithAnimaModel:(ACPeaksPoint *)animaModel {
    ACPeaksPoint *peaksModel = [self.peaksDictionary valueForKey:@(animaModel.peaksLineIndexs.firstObject.integerValue).stringValue];
    CGFloat peaksHeight = peaksModel.lineHeight;
    if (peaksModel.lineHeight > kMaxPeaksLineHeight) {
        NSArray *peaksKeys = self.peaksDictionary.allKeys;
        for (NSInteger i = 0; i < peaksKeys.count; i++) {
            NSString *key = peaksKeys[i];
            ACPeaksPoint *pointModel = [self.peaksDictionary valueForKey:key];
            if (pointModel.peaksLineIndexs.firstObject.integerValue == animaModel.peaksLineIndexs.firstObject.integerValue
                && pointModel.peaksLineIndexs.firstObject.integerValue != pointModel.lineIndex) {
                //高点附近动画线减半
                NSInteger spaceCount = abs((int)(peaksModel.lineIndex - pointModel.lineIndex));
                CGFloat newLineHeightValue = ((peaksHeight - kMinPeaksLineHeight) / 1.5 - spaceCount * kPeaksLineSpace);
                if (newLineHeightValue < 0) {
                    newLineHeightValue = 2;
                }
                pointModel.lineHeight = newLineHeightValue;
            }
        }
        peaksModel.lineHeight = (peaksHeight - kMinPeaksLineHeight) / 1.5;
    }
    
    NSNumber *animaValue = [self.animationDirectDictionary valueForKey:@(animaModel.peaksLineIndexs.firstObject.integerValue).stringValue];
    if (animaValue) {
        animaModel.lineHeight = animaModel.lineHeight + animaValue.integerValue;
    }
}

static int const animationKeyNumber = 8;
- (NSInteger)peaksModelLineHeightWith:(ACPeaksPoint *)peaksModel {
    NSInteger randomValue = (0);
    if (displayTimeCounter % animationKeyNumber == 0) {
        return peaksModel.lineHeight + randomValue;
    } else if (displayTimeCounter % animationKeyNumber  == 1) {
        return peaksModel.lineHeight + randomValue ;
    } else if (displayTimeCounter % animationKeyNumber  == 2) {
        return peaksModel.lineHeight - randomValue;
    } else if (displayTimeCounter % animationKeyNumber  == 3) {
        return peaksModel.lineHeight - randomValue;
    } else if (displayTimeCounter % animationKeyNumber  == 4) {
        return peaksModel.lineHeight + randomValue ;
    } else if (displayTimeCounter % animationKeyNumber  == 5) {
        return peaksModel.lineHeight - randomValue;
    } else if (displayTimeCounter % animationKeyNumber  == 6) {
        return peaksModel.lineHeight - randomValue;
    } else if (displayTimeCounter % animationKeyNumber  == 7) {
        return peaksModel.lineHeight + randomValue ;
    }
    return peaksModel.lineHeight;
}

#pragma mark - Target Action

static NSInteger displayTimeCounter = 0;
- (void)displayPerformAction:(CADisplayLink *)displayLink {
    if (displayTimeCounter % (kAnimationCircleTime * 3) == 0) {
        self.peaksDictionary = [self peaksPointsDictionary];
    }
    displayTimeCounter = displayTimeCounter + 1;
    if (displayTimeCounter % 2 == 0) {
//        [self resetAnimationDirection];
        [self setNeedsDisplay];
    }
}

#pragma mark - Setter && Getter

- (CADisplayLink *)animationTimer {
    if (!_animationTimer) {
        self.animationTimer = [CADisplayLink displayLinkWithTarget:self
                                                          selector:@selector(displayPerformAction:)];
    }
    return _animationTimer;
}

- (NSThread *)animationThread {
    if (!_animationThread) {
        self.animationThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(animationThreadRunSelector)
                                                         object:nil];
        _animationThread.name = @"Alex.AnimationThread";
    }
    return _animationThread;
}

@end

