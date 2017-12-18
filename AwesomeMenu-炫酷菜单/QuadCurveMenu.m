//
//  QuadCurveMenu.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Lunaapp.com. All rights reserved.
//

#import "QuadCurveMenu.h"
#import <QuartzCore/QuartzCore.h>

#define NEARRADIUS 130.0f
#define ENDRADIUS 140.0f
#define FARRADIUS 160.0f
#define BETWEENADIUS 50.0f
#define STARTPOINT CGPointMake(100, 130)
#define TIMEOFFSET 0.05f

#define USKEYWINDOW [UIApplication sharedApplication].keyWindow

@interface QuadCurveMenu ()
- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p;
- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p;

@end

@implementation QuadCurveMenu
@synthesize expanding = _expanding;
@synthesize delegate = _delegate;
@synthesize menusArray = _menusArray;
@synthesize type = _type;


#pragma mark - initialization & cleaning up
- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _startPoint = STARTPOINT;
        _menusArray = [aMenusArray copy];
        
        // add the menu buttons
        int count = [_menusArray count];
        for (int i = 0; i < count; i ++)
        {
            QuadCurveMenuItem *item = [_menusArray objectAtIndex:i];
            item.tag = 1000 + i;
            item.startPoint = STARTPOINT;
            item.endPoint = CGPointMake(_startPoint.x + ENDRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y - ENDRADIUS * cosf(i * M_PI_2 / (count - 1)));
            item.nearPoint = CGPointMake(_startPoint.x + NEARRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y - NEARRADIUS * cosf(i * M_PI_2 / (count - 1)));
            item.farPoint = CGPointMake(_startPoint.x + FARRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y - FARRADIUS * cosf(i * M_PI_2 / (count - 1)));
            item.center = item.startPoint;
            item.delegate = self;
            [self addSubview:item];
        }
        
        // add the "Add" Button.
        _addButton = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"story-add-button.png"]
                                       highlightedImage:[UIImage imageNamed:@"story-add-button-pressed.png"] 
                                           ContentImage:[UIImage imageNamed:@"story-add-plus.png"] 
                                highlightedContentImage:[UIImage imageNamed:@"story-add-plus-pressed.png"]];
        _addButton.delegate = self;
        _addButton.center = _startPoint;
        [self addSubview:_addButton];
    }
    return self;
}


- (void) setType:(QuadCureMenuType)type
{
    _type = type;
    int dx =1; 
    int dy =1;
    BOOL isTwoDirctions = YES;
  
    if (_menusArray !=nil) {
  
        switch (type) {
            case QuadCurveMenuTypeUpAndRight:
                break;
            case QuadCurveMenuTypeUpAndLeft:
                dx = -1;
                break;
            case QuadCurveMenuTypeDownAndRight:
                dy = -1;
                break;
            case QuadCurveMenuTypeDownAndLeft:
                dy = dx = -1;
                break;
            case QuadCurveMenuTypeUp:
                isTwoDirctions = NO; dx = 0; dy = -1;
                break;
            case QuadCurveMenuTypeDown:
                isTwoDirctions = NO; dx = 0; dy = 1;
                break;
            case QuadCurveMenuTypeLeft:
                isTwoDirctions = NO; dx = -1; dy = 0;
                break;
            case QuadCurveMenuTypeRight:
                isTwoDirctions = NO; dx = 1; dy = 0;
            default:
                break;
        }
        
        int count = [_menusArray count];
        for (int i = 0; i < count; i ++)
        {
            QuadCurveMenuItem *item = [_menusArray objectAtIndex:i];
            item.startPoint = _startPoint;
            if (isTwoDirctions) {
                item.endPoint = CGPointMake(_startPoint.x + dx * ENDRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y -dy * ENDRADIUS * cosf(i * M_PI_2 / (count - 1)));
                item.nearPoint = CGPointMake(_startPoint.x +dx *  NEARRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y -dy * NEARRADIUS * cosf(i * M_PI_2 / (count - 1)));
                item.farPoint = CGPointMake(_startPoint.x + dx * FARRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y -dy *  FARRADIUS * cosf(i * M_PI_2 / (count - 1)));
            }else
            {
                item.endPoint = CGPointMake(_startPoint.x + dx * i * BETWEENADIUS , _startPoint.y + dy * i * BETWEENADIUS);
                item.nearPoint = CGPointMake(_startPoint.x +dx * i * (BETWEENADIUS - 15), _startPoint.y + dy * i * (BETWEENADIUS - 15));
                item.farPoint = CGPointMake(_startPoint.x + dx * i * (BETWEENADIUS + 20), _startPoint.y + dy * i * (BETWEENADIUS + 20));
            
            }
            item.center = item.startPoint;
           
        }

    }
}

- (void) setStartPoint:(CGPoint) startpoint
{
    _startPoint = startpoint;
     _addButton.center = _startPoint;
    [self setType: _type];
};

- (void)dealloc
{
    [_addButton release];
    [_menusArray release];
    [super dealloc];
}

                               
#pragma mark - UIView's methods
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // if the menu state is expanding, everywhere can be touch
    // otherwise, only the add button are can be touch
    if (YES == _expanding) 
    {
        return YES;
    }
    else
    {
        return CGRectContainsPoint(_addButton.frame, point);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.expanding = !self.isExpanding;
}

#pragma mark - QuadCurveMenuItem delegates
- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item
{
    if (item == _addButton) 
    {
        self.expanding = !self.isExpanding;
    }
}
- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item
{
    // exclude the "add" button
    if (item == _addButton) 
    {
        return;
    }
    // blowup the selected menu button
    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    // shrink other menu buttons
    for (int i = 0; i < [_menusArray count]; i ++)
    {
        QuadCurveMenuItem *otherItem = [_menusArray objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag) {
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];

        otherItem.center = otherItem.startPoint;
    }
    _expanding = NO;
    
    // rotate "add" button
    float angle = self.isExpanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        _addButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if ([_delegate respondsToSelector:@selector(quadCurveMenu:didSelectIndex:)])
    {
        [_delegate quadCurveMenu:self didSelectIndex:item.tag - 1000];
    }
}

#pragma mark - instant methods
- (void)setMenusArray:(NSArray *)aMenusArray
{
    if (aMenusArray == _menusArray)
    {
        return;
    }
    [_menusArray release];
    _menusArray = [aMenusArray copy];
    
    
    // clean subviews
    for (UIView *v in self.subviews) 
    {
        if (v.tag >= 1000) 
        {
            [v removeFromSuperview];
        }
    }
    
    // add the menu buttons
    int count = [_menusArray count];
    for (int i = 0; i < count; i ++)
    {
        QuadCurveMenuItem *item = [_menusArray objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = _startPoint;
        item.endPoint = CGPointMake(_startPoint.x + ENDRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y - ENDRADIUS * cosf(i * M_PI_2 / (count - 1)));
        item.nearPoint = CGPointMake(_startPoint.x + NEARRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y - NEARRADIUS * cosf(i * M_PI_2 / (count - 1)));
        item.farPoint = CGPointMake(_startPoint.x + FARRADIUS * sinf(i * M_PI_2 / (count - 1)), _startPoint.y - FARRADIUS * cosf(i * M_PI_2 / (count - 1)));
        item.center = item.startPoint;
        item.delegate = self;
        [self addSubview:item];
    }
}
- (BOOL)isExpanding
{
    return _expanding;
}
- (void)setExpanding:(BOOL)expanding
{
    _expanding = expanding;    
    
    // rotate add button
    float angle = self.isExpanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        _addButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    // expand or close animation
    if (!_timer) 
    {
        _flag = self.isExpanding ? 0 : 5;
        SEL selector = self.isExpanding ? @selector(_expand) : @selector(_close);
        _timer = [[NSTimer scheduledTimerWithTimeInterval:TIMEOFFSET target:self selector:selector userInfo:nil repeats:YES] retain];
    }
}
#pragma mark 展开菜单选项
- (void)_expand
{
    [self becomeFirstResponder];
    if (_flag == 6)
    {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
    QuadCurveMenuItem *item = (QuadCurveMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3], 
                                [NSNumber numberWithFloat:.4], nil]; 
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
}
#pragma mark 关闭菜单选项
- (void)_close
{
    if (_flag == -1)
    {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
     QuadCurveMenuItem *item = (QuadCurveMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0], 
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil]; 
        
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    _flag --;
    
#pragma mark 删除灰色背景图
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate removeBackGroundView];
    });
}

- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;

    return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}


@end
