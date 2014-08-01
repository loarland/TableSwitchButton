//
//  CHViewController.m
//  TableSwitchButton
//
//  Created by Loarland_Yang on 14-7-31.
//  Copyright (c) 2014年 ChangHong. All rights reserved.
//

#import "CHViewController.h"

@interface CHViewController ()

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _btn = [[CHSwitchButton alloc]initWithFrame:CGRectMake(70, 50, 100, 30) isOn:NO];
    _btn.delegate = self;
    _btn.arrOptions = @[@"冷藏",@"冷藏2",@"冷藏3",@"冷藏4",@"冷藏5"];
    [self.view addSubview:_btn];
    
    _label.text = @"Ready!";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchButton:(CHSwitchButton *)sender valueDidChanged:(BOOL)boolValue{
    if (boolValue) {
        _label.text = _btn.lbOn.text;
    }else{
        _label.text = _btn.lbOff.text;
    }
}

- (void)switchButton:(CHSwitchButton *)sender didSelectedIndex:(NSInteger)index{
    _btn.lbOn.text = [_btn.arrOptions objectAtIndex:index];
    NSLog(@"%@",[_btn.tvOptions.superview.class description]);
}

@end
