//
//  ZYqqViewController.m
//  ZYSideslip
//
//  Created by 曾宇 on 16/5/8.
//  Copyright © 2016年 qiongYou. All rights reserved.
//

#import "ZYqqViewController.h"
#import "oneViewController.h"
#import "ZYSideslipMenuViewController.h"


@interface ZYqqViewController ()
@property (nonatomic, strong) UIButton * button;

@end

@implementation ZYqqViewController
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.button.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view addSubview:self.button];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
}


-(void)clickButton{
    NSLog(@"按钮背点击了");
    [ZYSideslipMenuViewController pushController:[[oneViewController alloc]init]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)button{
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        [ _button setTitle:@"fdsfsg咖妃搜嘎发嘎嘎嘎嘎嘎覆盖撒嘎范德萨范德萨发打发的放大师傅嘎啊法规发生更改发噶舒服咖妃嘎嘎" forState:UIControlStateNormal];
        _button.titleLabel.numberOfLines = 0;
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
