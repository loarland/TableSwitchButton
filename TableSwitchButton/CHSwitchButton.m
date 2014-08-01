//
//  CHSwitchButton.m
//  RemoteControl
//
//  Created by Loarland_Yang on 14-7-24.
//  Copyright (c) 2014年 ChangHong. All rights reserved.
//

#import "CHSwitchButton.h"

#define CellHeight 30

@interface CHSwitchButton ()

@end

@implementation CHSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame isOn:NO];
}

- (id)initWithFrame:(CGRect)frame isOn:(BOOL)isOn{
    CGSize initialSize = CGSizeMake(140, 52);
    frame.size.height = frame.size.width / initialSize.width *  initialSize.height;
    self = [super initWithFrame:frame];
    if (self) {
        _ivHandle = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - frame.size.height, 0, frame.size.height, frame.size.height)];
        _ivHandle.backgroundColor = [UIColor blueColor];
        _ivHandle.userInteractionEnabled = YES;
        _ivHandle.tag = 100;
        
        _viewSwitch = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width*2, self.bounds.size.height)];
        _viewSwitch.userInteractionEnabled = YES;
        
        _ivOn = [[UIImageView alloc]initWithFrame:CGRectMake(-_ivHandle.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        _ivOn.backgroundColor = [UIColor yellowColor];
        _ivOn.tag = 101;
        _ivOn.userInteractionEnabled = YES;
        
        _ivOff = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        _ivOff.backgroundColor = [UIColor greenColor];
        _ivOff.tag = 102;
        _ivOff.userInteractionEnabled = YES;
        
        _lbOn = [[UILabel alloc]initWithFrame:CGRectMake(_ivOn.frame.size.height*5/4, _ivOn.frame.size.height/8, _ivOn.frame.size.width-_ivOn.frame.size.height*3/2, _ivOn.frame.size.height*3/4)];
        _lbOn.text = @"On";
        _lbOn.textAlignment = NSTextAlignmentCenter;
        
        _lbOff = [[UILabel alloc]initWithFrame:CGRectMake(_ivOff.frame.size.height/4, _ivOff.frame.size.height/8, _ivOff.frame.size.width-_ivOff.frame.size.height*3/2, _ivOff.frame.size.height*3/4)];
        _lbOff.text = @"Off";
        _lbOff.textAlignment = NSTextAlignmentCenter;
        
        [_ivOn addSubview:_lbOn];
        [_ivOff addSubview:_lbOff];
        
        [_viewSwitch addSubview:_ivOff];
        [_viewSwitch addSubview:_ivOn];
        _isOn = YES;
        
        CGRect frametv = [self convertRect:frame toView:[UIApplication sharedApplication].keyWindow];
        DLogRect(frametv);
        _tvOptions = [[UITableView alloc]initWithFrame:CGRectMake(frametv.origin.x, frametv.origin.y + frametv.size.height + 1, self.bounds.size.width, 0) style:UITableViewStylePlain];
        _tvOptions.delegate = self;
        _tvOptions.dataSource = self;
        _tvOptions.layer.cornerRadius = 3;
//        [self addSubview:_tvOptions];
        
        
        _isTableShown = NO;
        initialFrame = frame;
        _arrOptions = [NSArray array];
        
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        [self addSubview:_viewSwitch];
        [self addSubview:_ivHandle];
        
        [self setOn:isOn animated:NO withDelegate:NO];
    }
    return self;
}

- (void)setOn:(BOOL)on{
    if (_isOn == on) {
        return;
    }
    CGPoint center = _viewSwitch.center;
    CGPoint centerHandle = _ivHandle.center;
    CGFloat dx = self.bounds.size.width - _ivHandle.frame.size.width;
    if (on) {
        center.x += dx;
        centerHandle.x += dx;
        _viewSwitch.center = center;
        _ivHandle.center = centerHandle;
        [_viewSwitch insertSubview:_ivOn aboveSubview:_ivOff];
        
    }else{
        center.x -= dx;
        centerHandle.x -= dx;
        _viewSwitch.center = center;
        _ivHandle.center = centerHandle;
        [_viewSwitch insertSubview:_ivOff aboveSubview:_ivOn];
    }
    _isOn = on;
}
- (void)setOn:(BOOL)on animated:(BOOL)animated withDelegate:(BOOL)Bool{
    if (_isTableShown) {
        [self changeTableShowingState:NO];
    }
    
    if (animated) {
        [UIView animateWithDuration:.25 animations:^{
            [self setOn:on];
        }];
    }else{
        [self setOn:on];
    }
    if (Bool) {
        if ([_delegate respondsToSelector:@selector(switchButton:valueDidChanged:)]) {
            [_delegate switchButton:self valueDidChanged:on];
        }
    }
}

- (void)changeTableShowingState:(BOOL)show{
    NSInteger num = [_arrOptions count];
    if (num == 0) {
        return;
    }else if (show && _isTableShown){
        return;
    }else if (!show && !_isTableShown){
        return;
    }
    num = num<=6 ? num : 6;
    if (show) {
        [[UIApplication sharedApplication].keyWindow addSubview:_tvOptions];
        _isTableShown = show;
        [UIView animateWithDuration:.2 animations:^{
//            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+CellHeight*num)];
            _tvOptions.frame = CGRectMake(_tvOptions.frame.origin.x, _tvOptions.frame.origin.y, _tvOptions.frame.size.width, CellHeight*num);
        }];
        
    }else{
        _isTableShown = show;
        
        [UIView animateWithDuration:.2 animations:^{
            _tvOptions.frame = CGRectMake(_tvOptions.frame.origin.x, _tvOptions.frame.origin.y, _tvOptions.frame.size.width, 0);
//            [self setFrame:initialFrame];
        } completion:^(BOOL finished) {
            [_tvOptions removeFromSuperview];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (touch.view.tag == 101) {
        [self setOn:NO animated:YES withDelegate:YES];
    }else if (touch.view.tag == 102){
        [self setOn:YES animated:YES withDelegate:YES];
    }
    else if (touch.view.tag == 100){
        _startPoint = point;
        if (_isOn) {
            _isOnClicked = YES;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat dx = point.x - _startPoint.x;
    NSLog(@"%f",dx);
    if (touch.view.tag == 100) {
        _isOnClicked = NO;
        if (dx<-20) {
            if (_isOn) {
                [self setOn:NO animated:YES withDelegate:YES];
            }
        }else if (dx>20){
            if (!_isOn) {
                [self setOn:YES animated:YES withDelegate:YES];
            }
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch end");
    UITouch *touch = [touches anyObject];
    NSLog(@"%d",touch.view.tag);
    if (touch.view.tag == 100) {
        if (_isOnClicked && _isOn) {
            NSLog(@"callback");
            [self changeTableShowingState:!_isTableShown];
        }else{
            NSLog(@"callback cancel");
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch cancel");
    UITouch *touch = [touches anyObject];
    NSLog(@"%d",touch.view.tag);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrOptions count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifyer = @"MyCellIdentifyer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyer];
    }
    cell.imageView.image = nil;
    cell.textLabel.text = [_arrOptions objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(switchButton:didSelectedIndex:)]) {
        [_delegate switchButton:self didSelectedIndex:indexPath.row];
    }
    [self changeTableShowingState:NO];
}

@end
