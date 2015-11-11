//
//  JJWTreasureViewController.m
//  stockDemo
//
//  Created by Wang on 15/11/11.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "JJWTreasureViewController.h"
#import "Charts-Swift.h"
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
#import "JJWIndexRecords.h"
#import "NSDate+Utility.h"
#import "AFNetworking.h"

#define kCount          250
// 服务器 api 相关
#define BEARER                  @"Bearer"

#define kUrlPrefix          @"http://dev.jijinwan.com/jijinwan/"
@interface CubicLineSampleFillFormatter3 : NSObject <ChartFillFormatter>
{
}

@end

@implementation CubicLineSampleFillFormatter3

- (CGFloat)getFillLinePositionWithDataSet:(LineChartDataSet *)dataSet dataProvider:(id<LineChartDataProvider>)dataProvider
{
    return -10.f;
}
@end


@interface JJWTreasureViewController ()<ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;


@property (nonatomic, strong) SocketIOClient *client;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, strong) NSArray *displayTime;
@end

@implementation JJWTreasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"夺宝场";
    [self setupChartsView];
    [self connectToSever];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectToSever
{
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:@"120.26.209.1:9090" options:@{@"log": @NO, @"forcePolling": @YES}];
    self.client =socket;
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [self.client emit:@"get_chart" withItems:nil];
        NSArray *items = [NSArray arrayWithObjects:self.access_token, nil];
        [self.client emit:@"set_user_id" withItems:items];
    }];
    [socket on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket error");
    }];
    [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket disconnect");
    }];
    [socket on:@"reconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket reconnect");
    }];
    [socket on:@"add_user" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"add_user");
    }];
    //OnStart
    [socket on:@"OnStart" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"OnStart");
    }];
    //rem_user
    [socket on:@"rem_user" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"rem_user");
    }];
    [socket on:@"set_user_id" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"set_user_id");
    }];
    [self.client on:@"get_chart" callback:^(NSArray* data, SocketAckEmitter* ack) {
        //NSString *event = ack.
        NSString *result = [data lastObject];
        
        [self dealWithDataString:result];
        
        [self setDataCount:self.records.count range:2600.0];
        
        //[self start];
        NSLog(@"%@",result);
    }];
    // chn_futures_chart_push_data
    [self.client on:@"chn_futures_chart_push_data" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [self parsechn_futures_chart_push_data:data];
    }];
    
    //chn_futures_real_info
    [self.client on:@"chn_futures_real_info" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [self parsechn_futures_real_info:data];
    }];
    [socket connect];
    
}

- (void)parsechn_futures_chart_push_data:(NSArray*)data
{
    NSDictionary *dict = [data lastObject];
    NSArray *array = dict[@"records"];
    array = [array lastObject];
    NSInteger count = self.records.count;
    JJWIndexRecords *record = [[JJWIndexRecords alloc]initWithArray:array];
    [NSDate locationForTimeInterval:record.timeStamp];
    [self.records addObject:record];
    [self updatekLine:record];
    //    for(int i = 0; i < 50; ++i)
    //    {
    //        [self.records addObject:record];
    //        [self updatekLine:record];
    //        [NSThread sleepForTimeInterval:0.01];
    //    }
}

- (void)parsechn_futures_real_info:(NSArray*)data
{
    NSDictionary *dict = [data lastObject];
    NSNumber *newIndex = dict[@"New"];
    self.indexLabel.text = [NSString stringWithFormat:@"%@",newIndex];
    NSNumber *hal = dict[@"hal"];
    self.label1.text = [NSString stringWithFormat:@"%@",hal];
    
    NSNumber *halRate = dict[@"halRate"];
    self.label2.text = [NSString stringWithFormat:@"%@%%",halRate];
}

- (void)updatekLine:(JJWIndexRecords*)record
{
    LineChartData *data = (LineChartData*)self.chartView.data;
    LineChartDataSet *set1 = (LineChartDataSet*)[data.dataSets lastObject];
    double value = [record.value doubleValue];
    ChartDataEntry *ent = [[ChartDataEntry alloc] initWithValue:value xIndex:self.records.count - 1];
    [set1 addEntry:ent];
    self.chartView.data = data;
}

- (void)dealWithDataString:(NSString*)result
{
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *recordArray = dict[@"records"];
    NSArray *records = [JJWIndexRecords indexRecordsWithArray:recordArray];
    
    [self.records addObjectsFromArray:records];
}

- (IBAction)buyUpBtnClicked:(UIButton *)sender {
}
- (IBAction)buyFallBtnClicked:(UIButton *)sender {
}
- (IBAction)sellBtnClicked:(UIButton *)sender {
}

-(void)setupChartsView
{
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    _chartView.delegate = self;
    
    [_chartView setViewPortOffsetsWithLeft:20.f top:0.f right:0.f bottom:20.f];
    _chartView.backgroundColor = [UIColor colorWithRed:104/255.f green:241/255.f blue:175/255.f alpha:1.f];
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.enabled = YES;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    [xAxis setLabelsToSkip:29];
    //xAxis.spaceBetweenLabels = 100;
    
    ChartYAxis *yAxis = _chartView.leftAxis;
    yAxis.enabled = YES;
    yAxis.customAxisMin = 2300;
    yAxis.startAtZeroEnabled = NO;
    [yAxis setLabelCount:3];
    yAxis.labelTextColor = [UIColor redColor];
    yAxis.labelPosition = YAxisLabelPositionInsideChart;
    
    _chartView.rightAxis.enabled = NO;
    _chartView.legend.enabled = NO;
    
    //[self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
}

- (void)setDataCount:(NSInteger)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < kCount; i++)
    {
        NSInteger flag = i % 30;
        if(flag == 0 && i <= 240)
        {
            NSInteger index = i / 30;
            [xVals addObject:self.displayTime[index]];
        }
        else
        {
            [xVals addObject:@""];
        }
    }
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        JJWIndexRecords *reco = self.records[i];
        double val = [reco.value doubleValue];
        NSLog(@"---->>>%@",@(val));
        [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals1 label:@"DataSet 1"];
    set1.drawCubicEnabled = YES;
    set1.cubicIntensity = 0.2;
    set1.drawCirclesEnabled = NO;
    set1.lineWidth = 1.8;
    set1.circleRadius = 4.0;
    [set1 setCircleColor:UIColor.whiteColor];
    set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    [set1 setColor:UIColor.whiteColor];
    set1.fillColor = [UIColor whiteColor];
    set1.fillAlpha = 0.5f;
    set1.drawHorizontalHighlightIndicatorEnabled = NO;
    set1.fillFormatter = [[CubicLineSampleFillFormatter3 alloc] init];
    set1.drawFilledEnabled = YES;
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSet:set1];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
    [data setDrawValues:NO];
    
    
    _chartView.data = data;
}


#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected dataSetIndex = %@ %lf",@(dataSetIndex),entry.value);
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (ChartDataSet *set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (LineChartDataSet *set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (LineChartDataSet *set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (LineChartDataSet *set in _chartView.data.dataSets)
        {
            set.drawCubicEnabled = !set.isDrawCubicEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateXY"])
    {
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {
        _chartView.pinchZoomEnabled = !_chartView.isPinchZoomEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleAutoScaleMinMax"])
    {
        _chartView.autoScaleMinMaxEnabled = !_chartView.isAutoScaleMinMaxEnabled;
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - 重写set和get函数
- (NSMutableArray *)records
{
    if(_records == nil)
    {
        _records = [NSMutableArray array];
    }
    return _records;
}

- (NSArray*)displayTime
{
    if(_displayTime == nil)
    {
        _displayTime = @[@"9:30",@"10:00",@"10:30",@"11:00",
                         @"11:30",@"13:30",@"14:00",@"14:30",
                         @"15:00",@"15:30"];
    }
    return _displayTime;
}

@end
