//
//  JJWTreasureViewController.h
//  stockDemo
//
//  Created by Wang on 15/11/11.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"
#import "Charts.h"

#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
@interface JJWTreasureViewController : DemoBaseViewController

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, strong) NSString *access_token;

@end
