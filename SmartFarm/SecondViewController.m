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
@property (weak, nonatomic) IBOutlet UISwitch *conID1;
@property (weak, nonatomic) IBOutlet UISlider *conID2;
@property (weak, nonatomic) IBOutlet UISlider *conID3;
@property (weak, nonatomic) IBOutlet UISlider *conID4;
@property (weak, nonatomic) IBOutlet UISwitch *conID5;
- (IBAction)publicID1:(id)sender;
- (IBAction)publicID5:(id)sender;
- (IBAction)publicID2:(id)sender;
- (IBAction)publicID3:(id)sender;
- (IBAction)publicID4:(id)sender;




@property MQTTSession *m_Session;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mqttConnect];
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
//
//
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
//
//        for (dic in PayLoadArray) {
//            NSLog(@"!!!!!\n");
//            NSString* ID = [dic objectForKey:@"ID"];
//            NSLog(@"ID is %@\n",ID);
//            NSNumber* nums = @([ID integerValue]);//NSString转化为NSNumber
//            NSNumber* num1 = [NSNumber numberWithInteger:1];
//            if([nums isEqualToNumber: num1])
//            {
//                NSLog(@"调试😎\n");
//            }
//            NSString* Type = [dic objectForKey:@"Type"];
//            NSLog(@"Type is %@\n",Type);
//            NSArray* DataArray = [dic objectForKey:@"Data"];
//            int i=0;
//            for(dic in DataArray){
//                NSLog(@"Data is %@",DataArray[i]);
//                i++;
//            }
//
//
//
//
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
    
        int intID = [ID intValue];
        int intParam = [Param intValue];
        switch (intID) {
            case 0:
                _conID1.on = intParam;
                _conID2.value = intParam;
                _conID3.value = intParam;
                _conID4.value = intParam;
                _conID5.on = intParam;
                break;
            case 1:
                _conID1.on = intParam;
                break;
            case 2:
                _conID2.value = intParam;
                break;
            case 3:
                _conID3.value = intParam;
                break;
            case 4:
                _conID4.value = intParam;
                break;
            case 5:
                _conID5.on = intParam;
                break;
            default:
                break;
        }
        
    }
}


- (IBAction)publicID1:(id)sender {
    NSDictionary *dict;
    if(_conID1.on == 0){
        dict = @{@"Obj":@"SW",@"ID":@"1",@"Cmd":@"Action",@"Param":@"0"};
    }else{
        dict = @{@"Obj":@"SW",@"ID":@"1",@"Cmd":@"Action",@"Param":@"1"};
    }
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (!isValid) {
        NSLog(@"发布格式不正确");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //发布信息
    [self.m_Session publishData:jsonData onTopic:@"jcsf/gh/control" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
        if(error)
        {
            NSLog(@"发布失败 %@",error.localizedDescription);
        }
        else
        {
            NSLog(@"发布成功");
        }
    }];
    
}

- (IBAction)publicID5:(id)sender {
    NSDictionary *dict;
    if(_conID5.on == 0){
        dict = @{@"Obj":@"SW",@"ID":@"5",@"Cmd":@"Action",@"Param":@"0"};
    }else{
        dict = @{@"Obj":@"SW",@"ID":@"5",@"Cmd":@"Action",@"Param":@"1"};
    }
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (!isValid) {
        NSLog(@"发布格式不正确");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //发布信息
    [self.m_Session publishData:jsonData onTopic:@"jcsf/gh/control" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
        if(error)
        {
            NSLog(@"发布失败 %@",error.localizedDescription);
        }
        else
        {
            NSLog(@"发布成功");
        }
    }];
}

- (IBAction)publicID2:(id)sender {
    if(_conID2.value != 0 && _conID2.value != 2){
        _conID2.value = 1;
    }
    NSDictionary *dict;
    if(_conID2.value == 0){
        dict = @{@"Obj":@"SW",@"ID":@"2",@"Cmd":@"Action",@"Param":@"0"};
    }else if(_conID2.value == 1){
        dict = @{@"Obj":@"SW",@"ID":@"2",@"Cmd":@"Action",@"Param":@"1"};
    }else{
        dict = @{@"Obj":@"SW",@"ID":@"2",@"Cmd":@"Action",@"Param":@"2"};
    }
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (!isValid) {
        NSLog(@"发布格式不正确");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //发布信息
    [self.m_Session publishData:jsonData onTopic:@"jcsf/gh/control" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
        if(error)
        {
            NSLog(@"发布失败 %@",error.localizedDescription);
        }
        else
        {
            NSLog(@"发布成功");
        }
    }];
}

- (IBAction)publicID3:(id)sender {
    if(_conID3.value != 0 && _conID3.value != 2){
        _conID3.value = 1;
    }
    NSDictionary *dict;
    if(_conID3.value == 0){
        dict = @{@"Obj":@"SW",@"ID":@"3",@"Cmd":@"Action",@"Param":@"0"};
    }else if(_conID3.value == 1){
        dict = @{@"Obj":@"SW",@"ID":@"3",@"Cmd":@"Action",@"Param":@"1"};
    }else{
        dict = @{@"Obj":@"SW",@"ID":@"3",@"Cmd":@"Action",@"Param":@"2"};
    }
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (!isValid) {
        NSLog(@"发布格式不正确");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //发布信息
    [self.m_Session publishData:jsonData onTopic:@"jcsf/gh/control" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
        if(error)
        {
            NSLog(@"发布失败 %@",error.localizedDescription);
        }
        else
        {
            NSLog(@"发布成功");
        }
    }];
}

- (IBAction)publicID4:(id)sender {
    if(_conID4.value != 0 && _conID4.value != 2){
        _conID4.value = 1;
    }
    NSDictionary *dict;
    if(_conID4.value == 0){
        dict = @{@"Obj":@"SW",@"ID":@"4",@"Cmd":@"Action",@"Param":@"0"};
    }else if(_conID4.value == 1){
        dict = @{@"Obj":@"SW",@"ID":@"4",@"Cmd":@"Action",@"Param":@"1"};
    }else{
        dict = @{@"Obj":@"SW",@"ID":@"4",@"Cmd":@"Action",@"Param":@"2"};
    }
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (!isValid) {
        NSLog(@"发布格式不正确");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //发布信息
    [self.m_Session publishData:jsonData onTopic:@"jcsf/gh/control" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
        if(error)
        {
            NSLog(@"发布失败 %@",error.localizedDescription);
        }
        else
        {
            NSLog(@"发布成功");
        }
    }];
}
@end
