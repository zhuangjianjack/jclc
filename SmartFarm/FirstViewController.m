//
//  FirstViewController.m
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/4.
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import "FirstViewController.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "TYCyclePagerTransformLayout.h"
#import <MQTTClient.h>


@interface FirstViewController ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property MQTTSession *m_Session;

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *light;
@property (nonatomic, strong) NSString *air;

@property (weak, nonatomic) IBOutlet UILabel *weaTemp;
@property (weak, nonatomic) IBOutlet UILabel *weaPM;
@property (weak, nonatomic) IBOutlet UILabel *weaWea;
@property (weak, nonatomic) IBOutlet UILabel *weaWind;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewWea;
@property (weak, nonatomic) UIImage *imgWea;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    
    
    [self addPagerView];
    [self addPageControl];
    
    [self loadData];
    
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
    [self.m_Session subscribeToTopic:@"jcsf/gh/iotdata" atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
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
    
    [_pagerView reloadData];
    [self changePageViewStyle];
    
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
            
            //NSString转NSNumber
            NSNumber *numID = @([ID integerValue]);
            
            NSString* Type = [dic objectForKey:@"Type"];
            NSLog(@"Type is %@\n",Type);
            NSArray* DataArray = [dic objectForKey:@"Data"];
            int i=0;
            for(dic in DataArray){
                NSLog(@"Data is %@",DataArray[i]);
                i++;
            }
            if([numID isEqualToNumber:[NSNumber numberWithInteger:1]] && DataArray.count == 3)
            {
                //设置lbl的text
                _temp = [NSString stringWithFormat:@"%@",DataArray[0]];
                _air = [NSString stringWithFormat:@"%@",DataArray[1]];
                _light = [NSString stringWithFormat:@"%@",DataArray[2]];
            }
        }
    };
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self changePageViewStyle];
}

-(void)changePageViewStyle{
    _pagerView.layout.layoutType = TYCyclePagerTransformLayoutLinear;
    _pagerView.layout.itemHorizontalCenter = YES;
    [_pagerView setNeedUpdateLayout];
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.layer.borderWidth = 0;
    pagerView.isInfiniteLoop = NO;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.view addSubview:pagerView];
    _pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(8, 8);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:75.0/255.0 green:218.0/255.0 blue:100.0/255.0 alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:198.0/255.0 green:202.0/255.0 blue:204.0/255.0 alpha:1.0];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _pagerView.frame = CGRectMake(0, 276, CGRectGetWidth(self.view.frame), 300);
    //    _pagerView.layer.borderWidth = 0;
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 5, CGRectGetWidth(_pagerView.frame), 26);
}

- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 6; ++i) {
        if (i == 0) {
            [datas addObject:[UIColor redColor]];
            continue;
        }
        [datas addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0]];
    }
    _datas = [datas copy];
    _pageControl.numberOfPages = _datas.count;
    [_pagerView reloadData];
}

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _datas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    //    cell.backgroundColor _datas[index];
    //    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    cell.lblTemp.text = _temp;
    cell.lblLight.text = _light;
    cell.lblAir.text = _air;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 15;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
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
    _weaTemp.text = tem;
    
    NSString* wea = [dic objectForKey:@"wea"];//天气状况
    
    NSLog(@"天气状况是 %@ \n",wea);
    _weaWea.text = wea;
    [self changeImgWea:wea];
    
    NSString* pm = [dic objectForKey:@"air_pm25"];//PM2.5
    
    NSLog(@"PM2.5是 %@ \n",pm);
    _weaPM.text = pm;
    
    NSString* wind = [dic objectForKey:@"win"];//PM2.5
    
    NSLog(@"风向是 %@ \n",wind);
    _weaWind.text = wind;
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

-(void)changeImgWea:(NSString *)weather{
    if([weather  isEqualToString:@"雨"])
    {
        _imgWea = [UIImage imageNamed:@"yu"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 117, 70, 66.5);
    }
    else if([weather  isEqualToString:@"阴"])
    {
        _imgWea = [UIImage imageNamed:@"yin"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 117, 70, 43.8);
    }
    else if([weather  isEqualToString:@"云"])
    {
        _imgWea = [UIImage imageNamed:@"duoyun"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 130, 70, 43.8);
    }
    else if([weather  isEqualToString:@"雾"])
    {
        _imgWea = [UIImage imageNamed:@"wu"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 114, 70, 71.2);
    }
    else if([weather  isEqualToString:@"晴"])
    {
        _imgWea = [UIImage imageNamed:@"qing"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 117, 70, 70);
    }
    else if([weather  isEqualToString:@"雷"])
    {
        _imgWea = [UIImage imageNamed:@"lei"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(60, 117, 38.5, 70);
    }
    else if([weather  isEqualToString:@"沙尘"])
    {
        _imgWea = [UIImage imageNamed:@"shachen"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 135, 70, 36.7);
    }
    else if([weather  isEqualToString:@"雪"])
    {
        _imgWea = [UIImage imageNamed:@"xue"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 113, 70, 76);
    }
    else if([weather  isEqualToString:@"冰雹"])
    {
        _imgWea = [UIImage imageNamed:@"bingbao"];
        _imgViewWea.image = _imgWea;
        _imgViewWea.frame = CGRectMake(37, 113, 70, 74);
    }
}

@end
