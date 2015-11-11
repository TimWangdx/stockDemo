//
//  JJWBullRoomViewController.h
//  stockDemo
//
//  Created by Wang on 15/11/10.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"
#import "Charts.h"

#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>

@interface JJWBullRoomViewController : DemoBaseViewController

@property (nonatomic, strong) SocketIOClient *client;

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, copy) NSString *selleID;
@property (nonatomic, copy) NSString *ID;

@end
