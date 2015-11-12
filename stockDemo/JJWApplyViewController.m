//
//  JJWApplyViewController.m
//  stockDemo
//
//  Created by Wang on 15/11/12.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "JJWApplyViewController.h"
#import "Charts-Swift.h"
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
#import "JJWIndexRecords.h"
#import "NSDate+Utility.h"
#import "AFNetworking.h"

// 服务器 api 相关
#define BEARER                  @"Bearer"

#define kUrlPrefix          @"http://dev.jijinwan.com/jijinwan/"

@interface JJWApplyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *applyAMBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyPMBtn;

@end

@implementation JJWApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"夺宝场";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyAMBtnClicked:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //15202150609
    NSString *url = [NSString stringWithFormat:@"%@%@",kUrlPrefix,@"IfStockMMUser/Applying"];
    
    NSString *accessToken = BEARER;
    accessToken = [accessToken stringByAppendingString:@" "];
    accessToken = [accessToken stringByAppendingString:self.access_token];
    
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)applyPMBtnClicked:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //15202150609
    NSString *url = [NSString stringWithFormat:@"%@%@",kUrlPrefix,@"IfStockMMUser/Applying"];
    
    NSString *accessToken = BEARER;
    accessToken = [accessToken stringByAppendingString:@" "];
    accessToken = [accessToken stringByAppendingString:self.access_token];
    
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];

    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"%@",error);
    }];
}

@end
