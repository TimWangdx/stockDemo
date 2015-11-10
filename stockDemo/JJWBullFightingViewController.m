//
//  JJWBullFightingViewController.m
//  stockDemo
//
//  Created by Wang on 15/11/10.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "JJWBullFightingViewController.h"

@interface JJWBullFightingViewController ()

@end

@implementation JJWBullFightingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)matchPlayerBtnClicked:(UIButton *)sender {
    NSLog(@"斗牛场匹配对手- %@",@(sender.tag));
}

@end
