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
#import "JJWTreasureViewController.h"
#import "MBProgressHUD+Utility.h"

// 服务器 api 相关
#define BEARER                  @"Bearer"

#define kUrlPrefix          @"http://dev.jijinwan.com/jijinwan/"

@interface JJWApplyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *applyAMBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyPMBtn;


@property (nonatomic, copy) NSNumber *if_stock_money_mm_id;
@end

@implementation JJWApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"夺宝场";
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBtnStatus
{
    if([NSDate isEarlyThanSomeTime:@"11:00"])
    {
        self.applyPMBtn.enabled = NO;
        if([self.if_stock_money_mm_id integerValue] > 0)
        {
            [self.applyAMBtn setTitle:@"已报名" forState:UIControlStateNormal];
            self.applyAMBtn.enabled = NO;
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            JJWTreasureViewController *vc =[sb instantiateViewControllerWithIdentifier:@"JJWTreasureViewController"];
            vc.access_token = self.access_token;
            vc.user_id = self.user_id;
            vc.if_stock_money_mm_id = self.if_stock_money_mm_id;
            [self .navigationController pushViewController:vc animated:YES];
            return;
        }
        else
        {
            if([NSDate isEarlyThanSomeTime:@"09:50"])
            {
                
            }
            else
            {
                self.applyAMBtn.enabled = NO;
            }
        }
    }
    else
    {
        [self.applyAMBtn setTitle:@"本场已结束" forState:UIControlStateNormal];
        self.applyAMBtn.enabled = NO;
        if([self.if_stock_money_mm_id integerValue] > 0)
        {
            [self.applyPMBtn setTitle:@"已报名" forState:UIControlStateNormal];
            self.applyAMBtn.enabled = NO;
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            JJWTreasureViewController *vc =[sb instantiateViewControllerWithIdentifier:@"JJWTreasureViewController"];
            vc.access_token = self.access_token;
            vc.user_id = self.user_id;
            vc.if_stock_money_mm_id = self.if_stock_money_mm_id;
            [self .navigationController pushViewController:vc animated:YES];
            return;
        }
        else
        {
            if([NSDate isEarlyThanSomeTime:@"13:50"])
            {
                
            }
            else
            {
                self.applyAMBtn.enabled = NO;
            }
        }
    }
}

- (void)getUserInfo
{
    //User/GetSelf
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //15202150609
    NSString *url = [NSString stringWithFormat:@"%@%@",kUrlPrefix,@"User/GetSelf"];
    
    NSString *accessToken = BEARER;
    accessToken = [accessToken stringByAppendingString:@" "];
    accessToken = [accessToken stringByAppendingString:self.access_token];
    
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject[@"data"];
        NSNumber *mm_id = dict[@"if_stock_money_mm_id" ];
        self.if_stock_money_mm_id = mm_id;
        [self setBtnStatus];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
        NSNumber *bSuccess = responseObject[@"success"];
        if([bSuccess isEqualToNumber:@(YES)])
        {
            [MBProgressHUD showSuccess:@"报名成功"];
        }
        else
        {
            [MBProgressHUD showError:@"报名失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"报名失败"];
    }];
}

@end
