//
//  FirstViewController.m
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/4.
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import "FirstViewController.h"
#import <MQTTClient.h>

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblConnect;
@property (weak, nonatomic) IBOutlet UILabel *lblSubscribe;
@property (weak, nonatomic) IBOutlet UILabel *lblPublish;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblSalinity;
@property (weak, nonatomic) IBOutlet UILabel *lblAir;
@property (weak, nonatomic) IBOutlet UILabel *lblLight;
@property (weak, nonatomic) IBOutlet UILabel *lblSoil;
@property (weak, nonatomic) IBOutlet UILabel *lblConductivity;


@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnSubscribe;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;

@property (weak, nonatomic) IBOutlet UITextField *txtPublish;



@property MQTTSession *m_Session;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeBtnStyle:self.btnConnect];
    [self changeBtnStyle:self.btnSubscribe];
    [self changeBtnStyle:self.btnPublish];
    
}

-(void) changeBtnStyle:(UIButton *)button
{
    //设置边框颜色
    button.layer.borderColor = [[UIColor colorWithRed:117.0/255.0 green:109.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
    //设置边框宽度
    button.layer.borderWidth = 1.8f;
    //给按钮设置角的弧度
    button.layer.cornerRadius = 15.0f;
    //设置背景颜色
    button.backgroundColor = [UIColor cyanColor];
    button.layer.masksToBounds = YES;}

- (IBAction)Connect:(id)sender {
    MQTTTransport *m_Transport = [[MQTTCFSocketTransport alloc] init];
    m_Transport.host = @"118.24.19.135";
    m_Transport.port = 1883;
    
    self.m_Session = [[MQTTSession alloc] init];
    self.m_Session.transport = m_Transport;
    self.m_Session.delegate = self;
    
    [self.m_Session connectWithConnectHandler:^(NSError *error) {
        // Do some work
        if(error)
        {
            NSLog(@"连接失败 %@",error.localizedDescription);
            self.lblConnect.text = @"连接失败";
        }
        else
        {
            NSLog(@"连接成功");
            self.lblConnect.text = @"连接成功";
        }
    }];
}

- (IBAction)SubScribe:(id)sender {
    [self.m_Session subscribeToTopic:@"jcsf/gh/iotdata" atLevel:MQTTQosLevelAtLeastOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"订阅失败 %@", error.localizedDescription);
            self.lblSubscribe.text = @"订阅失败";
        } else {
            NSLog(@"订阅成功 Granted Qos: %@", gQoss);
            self.lblSubscribe.text = @"订阅成功";
        }
    }];
}

- (IBAction)Publish:(id)sender {
    
    //模拟发布JSON信息
    NSDictionary *dict = @{@"温度" : @"25",
                           @"盐分" : @"543",
                           @"空气湿度" : @"79",
                           @"光照" : @"3495",
                           @"土壤湿度" : @"89",
                           @"电导率" : @"4236"
                           };
    
    // 当前对象是否能够转换成JSON数据.
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (!isValid) {
        NSLog(@"发布格式不正确");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //模拟发布String信息
    //NSString *msg = self.txtPublish.text;
    //data:[msg dataUsingEncoding:NSUTF8StringEncoding]
    
    //模拟发布JSON信息
    [self.m_Session publishData:jsonData onTopic:@"test" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
        if(error)
        {
            NSLog(@"发布失败 %@",error.localizedDescription);
            self.lblPublish.text = @"发布失败";
        }
        else
        {
            NSLog(@"发布成功");
            self.lblPublish.text = @"发布成功";
        }
        
    }];

}

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    // New message received in topic
    NSLog(@"订阅的主题是： %@",topic);
    //模拟接收String信息
    //把接收到的内容转为字符串
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
////    dataString = [dataString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
////    dataString = [dataString stringByReplacingOccurrencesOfString:@"\\d+" withString:@"\"$0\""];
    NSRange range = [dataString rangeOfString:@"Time"];
    NSString *str1 = [NSString stringWithFormat:@"%@", NSStringFromRange(range)];
    NSString *str2 = [str1 substringWithRange:NSMakeRange(1, 3)];
    NSUInteger numMon = (NSUInteger)[str2 integerValue] + 12;
    NSString *month1 = [dataString substringWithRange:NSMakeRange(numMon, 2)];
    NSUInteger numDate = (NSUInteger)[str2 integerValue] + 15;
    NSString *date1 = [dataString substringWithRange:NSMakeRange(numDate, 2)];
    NSUInteger numHour = (NSUInteger)[str2 integerValue] + 18;
    NSString *hour1 = [dataString substringWithRange:NSMakeRange(numHour, 2)];
    NSUInteger numMin = (NSUInteger)[str2 integerValue] + 21;
    NSString *minute1 = [dataString substringWithRange:NSMakeRange(numMin, 2)];
    NSUInteger numSec = (NSUInteger)[str2 integerValue] + 24;
    NSString *second1 = [dataString substringWithRange:NSMakeRange(numSec, 2)];
    if([month1 hasPrefix:@"0"])
    {
        NSString *month2;
        month2 = [month1 substringFromIndex:1];
        dataString = [dataString stringByReplacingOccurrencesOfString:month1 withString:month2];
    }
    if([date1 hasPrefix:@"0"])
    {
        NSString *date2;
        date2 = [date1 substringFromIndex:1];
        dataString = [dataString stringByReplacingOccurrencesOfString:date1 withString:date2];
    }
    if([hour1 hasPrefix:@"0"])
    {
        NSString *hour2;
        hour2 = [hour1 substringFromIndex:1];
        dataString = [dataString stringByReplacingOccurrencesOfString:hour1 withString:hour2];
    }
    if([minute1 hasPrefix:@"0"])
    {
        NSString *minute2;
        minute2 = [minute1 substringFromIndex:1];
        dataString = [dataString stringByReplacingOccurrencesOfString:minute1 withString:minute2];
    }
    if([second1 hasPrefix:@"0"])
    {
        NSString *second2;
        second2 = [second1 substringFromIndex:1];
        dataString = [dataString stringByReplacingOccurrencesOfString:second1 withString:second2];
    }
    
//    dataString = [dataString stringByReplacingOccurrencesOfString:@"06" withString:@"6"];
    NSLog(@"收到的消息是： %@",dataString);
    
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
                NSLog(@"json解析失败：%@",err);
                return;
            }
    NSLog(@"输出%@",dict);

    NSArray *payloadArr = [dict objectForKey:@"Payload"];
    NSLog(@"消息体：%@",payloadArr);
    NSMutableArray *dataArr;
//
    for(NSDictionary *dic in payloadArr)
    {
        NSString *data = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Data"]];
        NSLog(@"数据是：%@",data);
        [dataArr addObject:data];
    }
    NSLog(@"数据：%@",dataArr);
    NSMutableArray *data1 = dataArr[0];
    NSString *temp = [NSString stringWithFormat:@"%@",data1[0]];
    NSLog(@"温度：%@",temp);
//    self.lblMessages.text = dataString;

//    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
//        NSLog(@"接收格式1");
//        NSMutableArray *id1 = [(NSDictionary*)[jsonObj objectAtIndex:0] objectForKey:@"Payload"];
//        self.lblTemperature.text = [NSString stringWithFormat:@"%@",[(NSDictionary*)[id1 objectAtIndex:0] objectForKey:@"Data"]];
//    }
//        //强制转换为 NSDictionary
//        NSDictionary * dic = (NSDictionary *)jsonObj;
//        //将解析出来的数据赋给 UITextView 并设置为追加内容
//        self.lblTemperature.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"温度"]];
//        self.lblSalinity.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"盐分"]];
//        self.lblAir.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"空气湿度"]];
//        self.lblLight.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"光照"]];
//        self.lblSoil.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"土壤湿度"]];
//        self.lblConductivity.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"电导率"]];
//    }
//    else if([jsonObj isKindOfClass:[NSArray class]])
//    {
//        NSLog(@"接收格式2");
//        NSMutableArray *id1 = [(NSDictionary*)[jsonObj objectAtIndex:0] objectForKey:@"Payload"];
//
//        self.lblTemperature.text = [NSString stringWithFormat:@"%@",[(NSDictionary*)[id1 objectAtIndex:0] objectForKey:@"Data"]];
//    }
//    else if ([jsonObj isKindOfClass:[NSMutableArray class]])
//    {
//        NSLog(@"接收格式3");
//    }
//    else if ([jsonObj isKindOfClass:[NSMutableDictionary class]])
//    {
//        NSLog(@"接收格式4");
//    }
//    else if([jsonObj isKindOfClass:[NSString class]])
//    {
//        NSLog(@"接收格式5");
//    }
//    else
//    {
//        NSLog(@"接收格式不正确");
//    }
//    }
}

@end
