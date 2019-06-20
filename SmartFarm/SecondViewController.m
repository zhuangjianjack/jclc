//
//  SecondViewController.m
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/4.
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import "SecondViewController.h"
#import <MQTTClient.h>

@interface SecondViewController ()


@property MQTTSession *m_Session;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mqttConnect];
    [self getWheather];
}

-(void)mqttConnect{
    //连接
    NSLog(@"mqttConnect😄\n");
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
        }
        else
        {
            NSLog(@"连接成功,哈哈！👌\n");
            //连接成功订阅
            [self mqttSubscribe];
        }
    }];
    
    
}

-(void)mqttSubscribe{
    //订阅
    NSLog(@"mqttSubscribe😄\n");
    [self.m_Session subscribeToTopic:@"jcsf/gh/control" atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"订阅失败 %@", error.localizedDescription);
        } else {
            NSLog(@"订阅成功 Granted Qos: %@👌", gQoss);
        }
    }];
}

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    // New message received in topic
    NSLog(@"订阅的主题是： %@",topic);
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的是：%@\n",dataString);
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
        
        
//        //订阅iotdata时
//        NSString* Obj = [dic objectForKey:@"Obj"];
//        NSLog(@"Obj is %@\n", Obj);
//        NSString* Num = [dic objectForKey:@"Num"];
//        NSLog(@"Num is %@\n", Num);
//
//        NSArray* TimeArray = [dic objectForKey:@"Time"];
//        NSArray* PayLoadArray = [dic objectForKey:@"Payload"];
//        int i = 0;
//        for(dic in TimeArray){
//            NSLog(@"Time is %@",TimeArray[i]);
//            i++;
//        }
//
//        for (dic in PayLoadArray) {
//            NSLog(@"!!!!!\n");
//            NSString* ID = [dic objectForKey:@"ID"];
//            NSLog(@"ID is %@\n",ID);
//            NSString* Type = [dic objectForKey:@"Type"];
//            NSLog(@"Type is %@\n",Type);
//            NSArray* DataArray = [dic objectForKey:@"Data"];
//            int i=0;
//            for(dic in DataArray){
//                NSLog(@"Data is %@",DataArray[i]);
//                i++;
//            }
//        }

                //订阅 control  时
                NSString* Cmd = [dic objectForKey:@"Cmd"];
                NSLog(@"Cmd is %@\n",Cmd);
                NSString* ID = [dic objectForKey:@"ID"];
                NSLog(@"ID is %@\n",ID);
                NSString* Obj = [dic objectForKey:@"Obj"];
                NSLog(@"Obj is %@\n",Obj);
                NSString* Param = [dic objectForKey:@"Param"];
                NSLog(@"Param is %@\n",Param);
        
    }
}

-(void)getWheather{
    NSURL * url = [NSURL URLWithString:@"https://free-api.heweather.net/s6/weather/now?location=chengdu&key=742f85879aff416c8e8e9d6d33dfd4cd"];
    NSString * jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"😍\n%@\n",jsonStr);
}

@end
