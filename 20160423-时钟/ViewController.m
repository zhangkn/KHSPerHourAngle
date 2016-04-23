//
//  ViewController.m
//  20160423-时钟
//
//  Created by devzkn on 4/23/16.
//  Copyright © 2016 hisun. All rights reserved.
//

#import "ViewController.h"
#define KHSPerSecondAngle 6
#define KHSPerMinuteAngle 6
#define KHSPerHourAngle 30
#define angle2radian(x) ((x)/180.0*M_PI)
#define  KclockViewWidth  self.clockView.bounds.size.width
#define  KclockViewHeight  self.clockView.bounds.size.height


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *clockView;
@property (weak,nonatomic) CALayer *secondLayer;
@property (weak,nonatomic) CALayer *minuteLayer;
@property (weak,nonatomic) CALayer *hourLayer;


@end

@implementation ViewController

- (CALayer *)secondLayer{
    if (nil == _secondLayer) {
        CALayer *tmpLayer = [CALayer layer];
        [tmpLayer setAnchorPoint:CGPointMake(0.5, 0.9)];
        //设置在父Layer的位置
        [tmpLayer setPosition:CGPointMake(KclockViewWidth*0.5, KclockViewHeight*0.5)];
        //设置颜色
        [tmpLayer setBackgroundColor:[UIColor redColor].CGColor];
        //设置宽度和高度
        [tmpLayer setBounds:CGRectMake(0, 0, 1, KclockViewHeight*0.5-10)];
        _secondLayer = tmpLayer;
        [self.clockView.layer addSublayer:_secondLayer];
    }
    return _secondLayer;
}

- (CALayer *)minuteLayer{
    if (nil == _minuteLayer) {
        CALayer *tmpLayer = [CALayer layer];
        [tmpLayer setAnchorPoint:CGPointMake(0.5, 1)];//锚点
        //设置在父Layer的位置
        [tmpLayer setPosition:CGPointMake(KclockViewWidth*0.5, KclockViewHeight*0.5)];
        //设置颜色
        [tmpLayer setBackgroundColor:[UIColor blueColor].CGColor];
        //设置宽度和高度
        [tmpLayer setBounds:CGRectMake(0, 0, 3, KclockViewHeight*0.5-30)];
        [tmpLayer setCornerRadius:3];
        _minuteLayer = tmpLayer;
        [self.clockView.layer addSublayer:_minuteLayer];
    }
    return _minuteLayer;
}


- (CALayer *)hourLayer{
    if (nil == _hourLayer) {
        CALayer *tmpLayer = [CALayer layer];
        [tmpLayer setAnchorPoint:CGPointMake(0.5, 1)];
        //设置在父Layer的位置
        [tmpLayer setPosition:CGPointMake(KclockViewWidth*0.5, KclockViewHeight*0.5)];
        //设置颜色
        [tmpLayer setBackgroundColor:[UIColor blackColor].CGColor];
        //设置宽度和高度
        [tmpLayer setBounds:CGRectMake(0, 0, 4, KclockViewHeight*0.5-35)];
        [tmpLayer setCornerRadius:4];
        _hourLayer = tmpLayer;
        [self.clockView.layer addSublayer:_hourLayer];
    }
    return _hourLayer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layerRotation];
    //开启定时器
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(layerRotation) userInfo:nil repeats:YES];
    
}
#pragma mark - 秒针旋转
- (void)layerRotation {
    //获取秒数
    NSCalendar *calendar = [NSCalendar currentCalendar];//获取日历对象
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond| NSCalendarUnitHour|NSCalendarUnitMinute  fromDate:[NSDate date]];
    CGFloat second = components.second;
    //计算当前的秒针对应的弧度
    CGFloat secondAngle = second *KHSPerSecondAngle;
    //1、旋转秒针
    [self.secondLayer setTransform:CATransform3DMakeRotation(angle2radian(secondAngle), 0, 0, 1)];
    //KVC--有bug
//    [self.secondLayer setValue:@angle2radian(secondAngle) forKeyPath:@"transform.rotation"];
    //2、旋转分针
    CGFloat minute = components.minute;
    CGFloat minuteAngle = minute *KHSPerMinuteAngle +second*(KHSPerMinuteAngle/60.0);//整分＋秒的弧度(每秒对应的0.1弧度)
    [self.minuteLayer setTransform:CATransform3DMakeRotation(angle2radian(minuteAngle), 0, 0, 1)];
    //3、旋转时针
    CGFloat hour = components.hour;
    //计算当前的秒针对应的弧度
    CGFloat hourAngle = hour *KHSPerHourAngle + minute*(KHSPerHourAngle/60.0) +second*(KHSPerHourAngle/360.0);//整点的角度＋分钟的角度+秒的弧度（2分钟＝1弧度＝》1个小时＝30弧度）
    [self.hourLayer setTransform:CATransform3DMakeRotation(angle2radian(hourAngle), 0, 0, 1)];
}

@end
