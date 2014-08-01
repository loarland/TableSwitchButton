//
//  CHSwitchButton.h
//  RemoteControl
//
//  Created by Loarland_Yang on 14-7-24.
//  Copyright (c) 2014年 ChangHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchButtonDelegate;

@interface CHSwitchButton : UIView<UITableViewDelegate,UITableViewDataSource>{
    CGRect initialFrame;
}

@property (assign, nonatomic) id<SwitchButtonDelegate> delegate;
@property (strong, nonatomic) UIView        *viewSwitch;
@property (strong, nonatomic) UIImageView   *ivOn;
@property (strong, nonatomic) UIImageView   *ivOff;
@property (strong, nonatomic) UIImageView   *ivHandle;
@property (strong, nonatomic) UILabel      *lbOn;
@property (strong, nonatomic) UILabel      *lbOff;
@property (assign, nonatomic) BOOL          isOn;
@property (assign, nonatomic) CGPoint       startPoint;
@property (assign, nonatomic) BOOL          isOnClicked;
@property (strong, nonatomic) NSArray       *arrOptions;
@property (strong, nonatomic) UITableView       *tvOptions;

@property (assign, nonatomic) BOOL          isTableShown;

- (void)changeTableShowingState:(BOOL)show;

- (id)initWithFrame:(CGRect)frame isOn:(BOOL)isOn;
- (void)setOn:(BOOL)on animated:(BOOL)animated withDelegate:(BOOL)Bool;
@end

@protocol SwitchButtonDelegate <NSObject>

@optional
- (void)switchButton:(CHSwitchButton *)sender valueDidChanged:(BOOL)boolValue;
- (void)switchButton:(CHSwitchButton *)sender didSelectedIndex:(NSInteger)index;
@end