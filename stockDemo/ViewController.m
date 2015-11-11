//
//  ViewController.m
//  stockDemo
//
//  Created by Wang on 15/11/5.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "ViewController.h"
#import "Charts-Swift.h"
#import "CubicLineChartViewController.h"
#import "AppDelegate.h"
#import "JJWViewController1.h"
#import "JJWBullFightingViewController.h"
#import "NSDate+Utility.h"
#import "AFNetworking.h"
#import "JJWBullFightingViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, strong) NSString *access_token;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self login];
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

- (IBAction)bullBartleBtnClicked:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JJWBullFightingViewController *vc =[sb instantiateViewControllerWithIdentifier:@"JJWBullFightingViewController"];
    vc.access_token = self.access_token;
    vc.user_id = self.user_id;
    [self .navigationController pushViewController:vc animated:YES];
}

- (void)login
{
    //http://dev.jijinwan.com/jijinwan/User/Login?mobile=hjh&login_pwd=1&user_id=&_=1447038766477
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //15202150609
    NSString *url = @"http://dev.jijinwan.com/jijinwan/User/Login";
    //NSString *url = @"http://www.jijinwan.com/jijinwan/User/Login";
    NSDictionary *parameters = @{@"mobile":@"15088629305",
                                 @"login_pwd":@"123456",
                                 @"_" : [NSDate stringSince1970]
                                 };
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject[@"data"];
        
        self.access_token = dict[@"access_token"];
        self.user_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[super touchesBegan:touches withEvent:event];
    NSLog(@"ViewController touchesBegan");
//    
//    UIResponder *tt = self.nextResponder;
//    //NSLog(@"%@",tt);
//    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    UIViewController *vc = app.window.rootViewController;
//    NSLog(@"%@",vc);
//    
//    JJWViewController1 *vvv = [[JJWViewController1 alloc]init];
//    vvv.view.backgroundColor = [UIColor redColor];
//    //[self.navigationController pushViewController:vvv animated:YES];
//    [self presentViewController:vvv animated:YES completion:nil];
}
@end
