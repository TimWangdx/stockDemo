//
//  ViewController.m
//  stockDemo
//
//  Created by Wang on 15/11/5.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "ViewController.h"
#import "Charts-Swift.h"
#import "AnotherBarChartViewController.h"
#import "CubicLineChartViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClicked:(UIButton *)sender {
    //AnotherBarChartViewController *vc = [[AnotherBarChartViewController alloc]init];
    CubicLineChartViewController *vc = [[CubicLineChartViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
