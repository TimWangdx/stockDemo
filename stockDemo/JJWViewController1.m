//
//  JJWViewController1.m
//  stockDemo
//
//  Created by Wang on 15/11/9.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "JJWViewController1.h"
#import "AppDelegate.h"

@interface JJWViewController1 ()

@end

@implementation JJWViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIViewController *vc = app.window.rootViewController;
    NSLog(@"%@",vc);
}

@end
