//
//  CubicLineChartViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "CubicLineChartViewController.h"
#import "Charts-Swift.h"
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
#import "JJWIndexRecords.h"
#import "NSDate+Utility.h"

@interface CubicLineSampleFillFormatter : NSObject <ChartFillFormatter>
{
}

@end

@implementation CubicLineSampleFillFormatter

- (CGFloat)getFillLinePositionWithDataSet:(LineChartDataSet *)dataSet dataProvider:(id<LineChartDataProvider>)dataProvider
{
    return -10.f;
}

@end

@interface CubicLineChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SocketIOClient *client;
@property (nonatomic, strong) NSArray *records;
@end

@implementation CubicLineChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self connectToSever];
    
    self.title = @"Cubic Line Chart";
    
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
    //_chartView.backgroundColor = [UIColor orangeColor];

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
    yAxis.customAxisMin = 3500;
    yAxis.startAtZeroEnabled = NO;
    [yAxis setLabelCount:3];
    yAxis.labelTextColor = [UIColor redColor];
    yAxis.labelPosition = YAxisLabelPositionInsideChart;
    
//    ChartYAxis *yAxis = _chartView.leftAxis;
//    yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//    [yAxis setLabelCount:8 force:NO];
//    yAxis.startAtZeroEnabled = NO;
//    yAxis.labelTextColor = [UIColor redColor];
//    yAxis.labelPosition = YAxisLabelPositionInsideChart;
//    yAxis.drawGridLinesEnabled = NO;
//    yAxis.axisLineColor = UIColor.whiteColor;
//    _chartView.leftAxis.enabled = YES;
    
//    ChartYAxis *xAxis = _chartView.leftAxis;
//    yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//    [yAxis setLabelCount:6 force:NO];
//    yAxis.startAtZeroEnabled = NO;
//    yAxis.labelTextColor = [UIColor redColor];
//    yAxis.labelPosition = YAxisLabelPositionInsideChart;
//    yAxis.drawGridLinesEnabled = NO;
//    yAxis.axisLineColor = UIColor.whiteColor;
    
    _chartView.rightAxis.enabled = NO;
    _chartView.legend.enabled = NO;
    
    _sliderX.value = 44.0;
    _sliderY.value = 100.0;
    //[self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setxzhou
{
    
}

- (void)setDataCount:(NSInteger)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    NSArray *array = @[@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30"];
    for (int i = 0; i < count; i++)
    {
        //[xVals addObject:[@(i) stringValue]];
        //[xVals addObject:[@(i + 1990) stringValue]];
        NSInteger flag = i % 30;
        if(flag == 0 && i < 242)
        {
             NSInteger index = i / 30;
            [xVals addObject:array[index]];
            //[xVals addObject:[@(i) stringValue]];
        }
        else
        {
            [xVals addObject:[@(i) stringValue]];
        }
        //[xVals addObject:array[index]];
    }
    //[xVals addObjectsFromArray:array];
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    static BOOL bfisrt = NO;
    if(bfisrt)
    {
        [yVals1 addObjectsFromArray:self.array];
    }
    for (int i = 0; i < count; i++)
    {
        if(!bfisrt)
        {
//            double mult = (range + 1);
//            double val = (double) (arc4random_uniform(mult)) + 20;
            JJWIndexRecords *reco = self.records[i];
            double val = [reco.value doubleValue];
            NSLog(@"---->>>%@",@(val));
            [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
            self.array = yVals1;
            //[self performSelector:@selector(start) withObject:nil afterDelay:2.5];
            if(i == self.array.count - 1)
            {
                bfisrt = YES;
            }
        }
        else
        {
            if(i >= self.array.count)
            {
//                double mult = (range + 1);
//                double val = (double) (arc4random_uniform(mult)) + 20;
                //double val = range + arc4random() % 30;
                JJWIndexRecords *reco = self.records[i];
                double val = [reco.value doubleValue];
                NSLog(@"---->>>%@",@(val));
                [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
            }
        }
    }
    self.array = yVals1;
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
    set1.fillFormatter = [[CubicLineSampleFillFormatter alloc] init];
    set1.drawFilledEnabled = YES;
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSet:set1];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
    [data setDrawValues:NO];
    
    _chartView.data = data;
}


#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    _sliderTextX.text = [@((int)_sliderX.value + 1) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self setDataCount:self.records.count range:3600.0];
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

- (void)start
{
    //时间间隔
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                           target:self
                                                         selector:@selector(handleMaxShowTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    self.timer = timer;
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    //NSLog(@"handleMaxShowTimer");
    _sliderX.value += 1;
    [self slidersValueChanged:nil];
}

- (void)connectToSever
{
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:@"120.26.209.1:9090" options:@{@"log": @NO, @"forcePolling": @YES}];
    self.client =socket;
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [self.client emit:@"get_chart" withItems:nil];
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
    
    [socket on:@"chn_futures_real_info" callback:^(NSArray* data, SocketAckEmitter* ack) {
        //NSString *event = ack.
    }];
    
    [socket on:@"get_chart" callback:^(NSArray* data, SocketAckEmitter* ack) {
        //NSString *event = ack.
        NSString *result = [data lastObject];
        
        [self dealWithDataString:result];
        NSLog(@"%@",result);
    }];
    
    [socket connect];

}

- (void)dealWithDataString:(NSString*)result
{
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *recordArray = dict[@"records"];
    NSArray *records = [JJWIndexRecords indexRecordsWithArray:recordArray];
    self.records = records;
    NSLog(@"dealWithDataString");
    [self slidersValueChanged:nil];
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

@end
