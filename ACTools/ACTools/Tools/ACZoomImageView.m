//
//  ACZoomImageView.m
//  ACTools
//
//  Created by arges on 2019/8/8.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACZoomImageView.h"

@interface ACZoomImageView ()

/**  */
@property (nonatomic,assign) CGFloat pinchScale;

@end

@implementation ACZoomImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configZoomImage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configZoomImage];
    }
    return self;
}

#pragma mark - Private

- (void)configZoomImage {
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    //捏合手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(pinchGestureActionWithGesture:)];
    [self addGestureRecognizer:pinchGesture];
    
    //点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureActionWithGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(doubleTapGestureActionWithGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
}


#pragma mark - Target Action

- (void)pinchGestureActionWithGesture:(UIPinchGestureRecognizer *)gesture {
    
    NSLog(@"%@ == %@", @(gesture.scale), @(self.pinchScale));
    self.pinchScale = gesture.scale;
    self.layer.transform = CATransform3DMakeScale(self.pinchScale, self.pinchScale, self.pinchScale);
}

- (void)tapGestureActionWithGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"单点");
    }
}

- (void)doubleTapGestureActionWithGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.layer.transform = CATransform3DIdentity;
        NSLog(@"双击 %@", @(gesture.numberOfTouches));
    }
}


@end
