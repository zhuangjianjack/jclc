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
    [self.m_Session subscribeToTopic:@"jcsf/gh/iotdata" atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
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
        
        
        //订阅iotdata时
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
            NSNumber* nums = @([ID integerValue]);//NSString转化为NSNumber
            NSNumber* num1 = [NSNumber numberWithInteger:1];
            if([nums isEqualToNumber: num1])
            {
                NSLog(@"调试😎\n");
            }
            NSString* Type = [dic objectForKey:@"Type"];
            NSLog(@"Type is %@\n",Type);
            NSArray* DataArray = [dic objectForKey:@"Data"];
            int i=0;
            for(dic in DataArray){
                NSLog(@"Data is %@",DataArray[i]);
                i++;
            }
            
            
            
            
        }
        
        //                //订阅 control  时
        //                NSString* Cmd = [dic objectForKey:@"Cmd"];
        //                NSLog(@"Cmd is %@\n",Cmd);
        //                NSString* ID = [dic objectForKey:@"ID"];
        //                NSLog(@"ID is %@\n",ID);
        //                NSString* Obj = [dic objectForKey:@"Obj"];
        //                NSLog(@"Obj is %@\n",Obj);
        //                NSString* Param = [dic objectForKey:@"Param"];
        //                NSLog(@"Param is %@\n",Param);
        //
    }
}

-(void)getWheather{
    NSURL * url = [NSURL URLWithString:@"https://www.tianqiapi.com/api/?version=v6&cityid=101270107"];
    
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary* dic = (NSDictionary *)jsonObj;
    
    NSString* jsonStr = [self transformDic:dic];
    
    NSLog(@"%@\n😎",jsonStr);
    
    NSString* tem = [dic objectForKey:@"tem"];//当前温度
    
    NSLog(@"当前温度是%@\n",tem);
    
    NSString* wea = [dic objectForKey:@"wea"];//天气状况
    
    NSLog(@"天气状况是 %@ \n",wea);
    
}

- (NSString *)transformDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =[tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =[[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

@end
