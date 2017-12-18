//
//  QuadCurveMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenuItem.h"

@protocol QuadCurveMenuDelegate;

//defult type is like this
/*
 *       O
 *           O
 *              O 
 *                O   
 *       0         O     
 */
typedef enum
{
    QuadCurveMenuTypeUpAndRight = 0,                 
    QuadCurveMenuTypeUpAndLeft,
    QuadCurveMenuTypeDownAndRight,
    QuadCurveMenuTypeDownAndLeft,
    QuadCurveMenuTypeUp,
    QuadCurveMenuTypeDown,
    QuadCurveMenuTypeLeft,
    QuadCurveMenuTypeRight,
    QuadCurveMenuTypeDefault = QuadCurveMenuTypeUpAndRight
} QuadCureMenuType;

@interface QuadCurveMenu : UIView <QuadCurveMenuItemDelegate>
{
    NSArray *_menusArray;
    int _flag;
    NSTimer *_timer;
    QuadCurveMenuItem *_addButton;
    QuadCureMenuType _type;
    id<QuadCurveMenuDelegate> _delegate;
    
    CGPoint _startPoint;

}
@property (nonatomic, copy) NSArray *menusArray;
@property (nonatomic) QuadCureMenuType type;
@property (nonatomic, getter = isExpanding)     BOOL expanding;
@property (nonatomic, assign) id<QuadCurveMenuDelegate> delegate;
- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray;
- (void) setType:(QuadCureMenuType)type;
- (void) setStartPoint:(CGPoint) startpoint;
#pragma mark 展开菜单选项
- (void)_expand;
#pragma mark 关闭菜单选项
- (void)_close;
@end

@protocol QuadCurveMenuDelegate <NSObject>
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx;
-(void)removeBackGroundView;
@end