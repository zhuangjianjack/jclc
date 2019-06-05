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
@property (weak, nonatomic) IBOutlet UILabel *lblMessages;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnSubscribe;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;
@property (weak, nonatomic) IBOutlet UITextField *txtPublish;

@property (weak, nonatomic) IBOutlet UILabel *lblPublish;

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
    [self.m_Session subscribeToTopic:@"test" atLevel:MQTTQosLevelAtLeastOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
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
    
    NSString *msg = self.txtPublish.text;
    [self.m_Session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:@"test" retain:NO qos:MQTTQosLevelAtLeastOnce publishHandler:^(NSError *error) {
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
    //把接收到的内容转为字符串
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的消息是： %@",dataString);
    self.lblMessages.text = dataString;
}


@end
