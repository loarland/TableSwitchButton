//
//  CHViewController.h
//  TableSwitchButton
//
//  Created by Loarland_Yang on 14-7-31.
//  Copyright (c) 2014年 ChangHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSwitchButton.h"

@interface CHViewController : UIViewController<SwitchButtonDelegate>

@property (strong, nonatomic) CHSwitchButton        *btn;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
