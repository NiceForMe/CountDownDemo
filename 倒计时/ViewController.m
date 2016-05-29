//
//  ViewController.m
//  倒计时
//
//  Created by NiceForMe on 16/3/19.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SDAutoLayout.h"
#define Margin 10
@interface ViewController ()
{
    dispatch_source_t _timer;
}
@property (nonatomic,strong) UILabel *dayLable;
@property (nonatomic,strong) UILabel *hourLable;
@property (nonatomic,strong) UILabel *minuteLable;
@property (nonatomic,strong) UILabel *secondLable;

@end

@implementation ViewController
/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
- (NSString *)getyyyymmdd
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc]init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
    NSDate *endDate_destiDate = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 25 * 24 * 3600)];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval = [endDate_destiDate timeIntervalSinceDate:startDate];
    if (_timer == nil) {
        //倒计时时间
        __block int timeout = timeInterval;
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);//每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout <= 0) {//倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLable.text = @"";
                        self.hourLable.text = @"00";
                        self.minuteLable.text = @"00";
                        self.secondLable.text = @"00";
                    });
                }else{
                    int days = (int)(timeout / (24 * 3600));
                    if (days == 0) {
                        self.dayLable.text = @"";
                    }
                    int hours = (int)((timeout - days * 24 * 3600)/3600);
                    int minute = (int)(timeout - days * 24 * 3600 - hours * 3600)/60;
                    int second = timeout - days * 24 * 3600 - hours * 3600 - minute * 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days == 0) {
                            self.dayLable.text = @"0天";
                        }else{
                            self.dayLable.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours < 10) {
                            self.hourLable.text = [NSString stringWithFormat:@"0%d时",hours];
                        }else{
                            self.hourLable.text = [NSString stringWithFormat:@"%d时",hours];
                        }
                        if (minute < 10) {
                            self.minuteLable.text = [NSString stringWithFormat:@"0%d分",minute];
                        }else{
                            self.minuteLable.text = [NSString stringWithFormat:@"%d分",minute];
                        }
                        if (second < 10) {
                            self.secondLable.text = [NSString stringWithFormat:@"0%d秒",second];
                        }else{
                            self.secondLable.text = [NSString stringWithFormat:@"%d秒",second];
                        }
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}
- (void)initUI
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 300, 50)];
    titleLable.text = @"距离决赛开始还有";
    [self.view addSubview:titleLable];
    //dayLable
    self.dayLable = [[UILabel alloc]init];
    self.dayLable.backgroundColor = [UIColor redColor];
    self.dayLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.dayLable];
    self.dayLable.sd_layout
    .topSpaceToView(titleLable,10)
    .leftSpaceToView(self.view,50)
    .widthIs(50)
    .heightIs(40);
    //hourLable
    self.hourLable = [[UILabel alloc]init];
    self.hourLable.backgroundColor = [UIColor lightGrayColor];
    self.hourLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hourLable];
    self.hourLable.sd_layout
    .leftSpaceToView(self.dayLable,Margin)
    .topSpaceToView(titleLable,Margin)
    .widthIs(50)
    .heightIs(40);
    //minuteLable
    self.minuteLable = [[UILabel alloc]init];
    self.minuteLable.textAlignment = NSTextAlignmentCenter;
    self.minuteLable.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.minuteLable];
    self.minuteLable.sd_layout
    .leftSpaceToView(self.hourLable,Margin)
    .topSpaceToView(titleLable,Margin)
    .widthIs(50)
    .heightIs(40);
    //secondLable
    self.secondLable = [[UILabel alloc]init];
    self.secondLable.textAlignment = NSTextAlignmentCenter;
    self.secondLable.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.secondLable];
    self.secondLable.sd_layout
    .leftSpaceToView(self.minuteLable,Margin)
    .topSpaceToView(titleLable,Margin)
    .widthIs(50)
    .heightIs(40);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
