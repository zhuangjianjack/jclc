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
    [self.m_Session subscribeToTopic:@"jcsf/gh/iotdata" atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
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
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的是：%@",dataString);
    //NSData* jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    //解析 data 对象
    // 返回值可能会 字典，也可能为 数组，所以用 id 类型接受
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(jsonObj == nil){
        NSLog(@"为空！\n");
    }
    
    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        //强制转换为 NSDictionary
        NSDictionary * dic = (NSDictionary *)jsonObj;
        
        NSString* Obj = [dic objectForKey:@"Obj"];
        NSLog(@"Obj is %@\n", Obj);
        NSString* Num = [dic objectForKey:@"Num"];
        NSLog(@"Num is %@\n", Num);
        
        NSArray* TimeArray = [dic objectForKey:@"Time"];
        NSArray* PayLoadArray = [dic objectForKey:@"Payload"];
        int i = 0;
        for(dic in TimeArray){
            NSLog(@"Time is %@",TimeArray[i]);
            i++;
        }
        
        for (dic in PayLoadArray) {
            NSLog(@"!!!!!\n");
            NSString* ID = [dic objectForKey:@"ID"];
            NSLog(@"ID is %@\n",ID);
            NSString* Type = [dic objectForKey:@"Type"];
            NSLog(@"Type is %@\n",Type);
            NSArray* DataArray = [dic objectForKey:@"Data"];
            int i=0;
            for(dic in DataArray){
                NSLog(@"Data is %@",DataArray[i]);
                i++;
            }
        }
        
        

        
//        //订阅 control  时
//        NSString* Cmd = [dic objectForKey:@"Cmd"];
//        NSLog(@"Cmd is %@\n",Cmd);
//        NSString* ID = [dic objectForKey:@"ID"];
//        NSLog(@"ID is %@\n",ID);
//        NSString* Obj = [dic objectForKey:@"Obj"];
//        NSLog(@"Obj is %@\n",Obj);
//        NSString* Param = [dic objectForKey:@"Param"];
//        NSLog(@"Param is %@\n",Param);
        
    }
    
 
}


@end
