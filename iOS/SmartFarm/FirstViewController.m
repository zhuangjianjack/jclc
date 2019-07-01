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
#import "SensorParameter.h"

#define MainColor [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0]
#define BlackColor [UIColor blackColor]

//@interface SensorParameter:NSObject
//@property(nonatomic, copy) NSString* number;
//@property(nonatomic, copy) NSString* imageName;
//@end

@interface FirstViewController ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,MQTTSessionDelegate>

@property MQTTSession *m_Session;

@property NSMutableArray* m_data;

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSArray *datas;

//ID1
@property (nonatomic, strong) NSString *temp1;
@property (nonatomic, strong) NSString *light;
@property (nonatomic, strong) NSString *air1;

//ID2
@property (nonatomic, strong) NSString *temp2;
@property (nonatomic, strong) NSString *CO2;
@property (nonatomic, strong) NSString *air2;

//ID3
@property (nonatomic, strong) NSString *temp3;
@property (nonatomic, strong) NSString *soil3;

//ID4
@property (nonatomic, strong) NSString *temp4;
@property (nonatomic, strong) NSString *soil4;

//ID5
@property (nonatomic, strong) NSString *temp5;
@property (nonatomic, strong) NSString *soil5;

//ID10
@property (nonatomic, strong) NSString *conductivity;
@property (nonatomic, strong) NSString *salinity;

@property (weak, nonatomic) IBOutlet UISwitch *conID1;
@property (weak, nonatomic) IBOutlet UISlider *conID2;
@property (weak, nonatomic) IBOutlet UISlider *conID3;
@property (weak, nonatomic) IBOutlet UISlider *conID4;
@property (weak, nonatomic) IBOutlet UISwitch *conID5;

@property (weak, nonatomic) IBOutlet UILabel *weaTemp;
@property (weak, nonatomic) IBOutlet UILabel *weaPM;
@property (weak, nonatomic) IBOutlet UILabel *weaWea;
@property (weak, nonatomic) IBOutlet UILabel *weaWind;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewWea;
@property (weak, nonatomic) UIImage *imgWea;

@property (weak, nonatomic) IBOutlet UIButton *btnSensor;
@property (weak, nonatomic) IBOutlet UIButton *btnController;



@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    self.m_data = [NSMutableArray arrayWithCapacity:6];
    
    //光照温湿度变送器
    NSMutableArray* sensor1 = [NSMutableArray arrayWithCapacity:3];
    //温度
    SensorParameter* sp = [SensorParameter new];
    sp.number = @"1";
    sp.imageName = @"temp";
    [sensor1 addObject:sp];
    //光照
    sp = [SensorParameter new];
    sp.number = @"2";
    sp.imageName = @"light";
    [sensor1 addObject:sp];
    //空气湿度
    sp = [SensorParameter new];
    sp.number = @"3";
    sp.imageName = @"air_humidity";
    [sensor1 addObject:sp];
    [self.m_data addObject:sensor1];
    
    //CO2温湿度变送器
    
    
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
                _temp1 = [NSString stringWithFormat:@"%@",DataArray[0]];
                _air1 = [NSString stringWithFormat:@"%@",DataArray[1]];
                _light = [NSString stringWithFormat:@"%@",DataArray[2]];
            }
            if([numID isEqualToNumber:[NSNumber numberWithInteger:2]] && DataArray.count == 3)
            {
                //设置lbl的text
                _temp2 = [NSString stringWithFormat:@"%@",DataArray[0]];
                _air2 = [NSString stringWithFormat:@"%@",DataArray[1]];
                _CO2 = [NSString stringWithFormat:@"%@",DataArray[2]];
            }
            if([numID isEqualToNumber:[NSNumber numberWithInteger:3]] && DataArray.count == 2)
            {
                //设置lbl的text
                _temp3 = [NSString stringWithFormat:@"%@",DataArray[0]];
                _soil3 = [NSString stringWithFormat:@"%@",DataArray[1]];
            }
            if([numID isEqualToNumber:[NSNumber numberWithInteger:4]] && DataArray.count == 2)
            {
                //设置lbl的text
                _temp4 = [NSString stringWithFormat:@"%@",DataArray[0]];
                _soil4 = [NSString stringWithFormat:@"%@",DataArray[1]];
            }
            if([numID isEqualToNumber:[NSNumber numberWithInteger:5]] && DataArray.count == 2)
            {
                //设置lbl的text
                _temp5 = [NSString stringWithFormat:@"%@",DataArray[0]];
                _soil5 = [NSString stringWithFormat:@"%@",DataArray[1]];
            }
            if([numID isEqualToNumber:[NSNumber numberWithInteger:10]] && DataArray.count == 2)
            {
                //设置lbl的text
                _conductivity = [NSString stringWithFormat:@"%@",DataArray[0]];
                _salinity = [NSString stringWithFormat:@"%@",DataArray[1]];
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
    //防止Cell复用
    for(id subView in cell.subviews){
        if(subView){
            [subView removeFromSuperview];
        }
    }
    switch (index) {
        case 0:
            [self setCell0:cell];
            break;
        case 1:
            [self setCell1:cell];
            break;
        case 2:
            [self setCell2:cell];
            break;
        case 3:
            [self setCell3:cell];
            break;
        case 4:
            [self setCell4:cell];
            break;
        case 5:
            [self setCell5:cell];
            break;
        default:
            break;
    }
    //    cell.backgroundColor _datas[index];
    //    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    
    
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

- (void)setCell0:(TYCyclePagerViewCell *)cell{
    UILabel *lblTitle = [[UILabel alloc]init];
    [cell addLabel:lblTitle toLabel:cell.lblTitle color:BlackColor alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
    cell.lblTitle = lblTitle;
    cell.lblTitle.text = @"光照温湿度变送器";
    
    [cell addImageView:cell.viewTemp imgName:@"temp" x:10 y:80 width:165 height:90];
    UILabel *lblTemp1 = [[UILabel alloc]init];
    [cell addLabel:lblTemp1 toLabel:cell.lblTemp1 color:MainColor alignment:NSTextAlignmentRight x:62 y:112.5 width:100 height:25];
    cell.lblTemp1 = lblTemp1;
    
    [cell addImageView:cell.viewLight imgName:@"light" x:200 y:80 width:165 height:90];
    UILabel *lblLight = [[UILabel alloc]init];
    [cell addLabel:lblLight toLabel:cell.lblLight color:MainColor alignment:NSTextAlignmentRight x:252 y:112.5 width:100 height:25];
    cell.lblLight = lblLight;
    
    [cell addImageView:cell.viewAir imgName:@"air_humidity" x:10 y:190 width:165 height:90];
    UILabel *lblAir1 = [[UILabel alloc]init];
    [cell addLabel:lblAir1 toLabel:cell.lblAir1 color:MainColor alignment:NSTextAlignmentRight x:62 y:222 width:100 height:25];
    cell.lblAir1 = lblAir1;
    cell.lblTemp1.text = _temp1;
    cell.lblLight.text = _light;
    cell.lblAir1.text = _air1;
}

- (void)setCell1:(TYCyclePagerViewCell *)cell{
    UILabel *lblTitle = [[UILabel alloc]init];
    [cell addLabel:lblTitle toLabel:cell.lblTitle color:BlackColor alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
    cell.lblTitle = lblTitle;
    cell.lblTitle.text = @"CO2温湿度变送器";
    
    [cell addImageView:cell.viewTemp imgName:@"temp" x:10 y:80 width:165 height:90];
    UILabel *lblTemp2 = [[UILabel alloc]init];
    [cell addLabel:lblTemp2 toLabel:cell.lblTemp2 color:MainColor alignment:NSTextAlignmentRight x:62 y:112.5 width:100 height:25];
    cell.lblTemp2 = lblTemp2;
    
    [cell addImageView:cell.viewCO2 imgName:@"co2" x:200 y:80 width:165 height:90];
    UILabel *lblCO2 = [[UILabel alloc]init];
    [cell addLabel:lblCO2 toLabel:cell.lblCO2 color:MainColor alignment:NSTextAlignmentRight x:252 y:112.5 width:100 height:25];
    cell.lblCO2 = lblCO2;
    
    [cell addImageView:cell.viewAir imgName:@"air_humidity" x:10 y:190 width:165 height:90];
    UILabel *lblAir2 = [[UILabel alloc]init];
    [cell addLabel:lblAir2 toLabel:cell.lblAir2 color:MainColor alignment:NSTextAlignmentRight x:62 y:222 width:100 height:25];
    cell.lblAir2 = lblAir2;
    cell.lblTemp2.text = _temp2;
    cell.lblCO2.text = _CO2;
    cell.lblAir2.text = _air2;
}

- (void)setCell2:(TYCyclePagerViewCell *)cell{
    UILabel *lblTitle = [[UILabel alloc]init];
    [cell addLabel:lblTitle toLabel:cell.lblTitle color:BlackColor alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
    cell.lblTitle = lblTitle;
    cell.lblTitle.text = @"土壤水分传感器1";
    
    [cell addImageView:cell.viewTemp imgName:@"temp" x:10 y:80 width:165 height:90];
    UILabel *lblTemp3 = [[UILabel alloc]init];
    [cell addLabel:lblTemp3 toLabel:cell.lblTemp3 color:MainColor alignment:NSTextAlignmentRight x:62 y:112.5 width:100 height:25];
    cell.lblTemp3 = lblTemp3;
    
    [cell addImageView:cell.viewSoil imgName:@"soil_humidity" x:200 y:80 width:165 height:90];
    UILabel *lblSoil3 = [[UILabel alloc]init];
    [cell addLabel:lblSoil3 toLabel:cell.lblSoil3 color:MainColor alignment:NSTextAlignmentRight x:252 y:112.5 width:100 height:25];
    cell.lblSoil3 = lblSoil3;
    cell.lblTemp3.text = _temp3;
    cell.lblSoil3.text = _soil3;
}

- (void)setCell3:(TYCyclePagerViewCell *)cell{
    UILabel *lblTitle = [[UILabel alloc]init];
    [cell addLabel:lblTitle toLabel:cell.lblTitle color:BlackColor alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
    cell.lblTitle = lblTitle;
    cell.lblTitle.text = @"土壤水分传感器2";
    
    [cell addImageView:cell.viewTemp imgName:@"temp" x:10 y:80 width:165 height:90];
    UILabel *lblTemp4 = [[UILabel alloc]init];
    [cell addLabel:lblTemp4 toLabel:cell.lblTemp4 color:MainColor alignment:NSTextAlignmentRight x:62 y:112.5 width:100 height:25];
    cell.lblTemp4 = lblTemp4;
    
    [cell addImageView:cell.viewSoil imgName:@"soil_humidity" x:200 y:80 width:165 height:90];
    UILabel *lblSoil4 = [[UILabel alloc]init];
    [cell addLabel:lblSoil4 toLabel:cell.lblSoil4 color:MainColor alignment:NSTextAlignmentRight x:252 y:112.5 width:100 height:25];
    cell.lblSoil4 = lblSoil4;
    cell.lblTemp4.text = _temp4;
    cell.lblSoil4.text = _soil4;
}

- (void)setCell4:(TYCyclePagerViewCell *)cell{
    UILabel *lblTitle = [[UILabel alloc]init];
    [cell addLabel:lblTitle toLabel:cell.lblTitle color:BlackColor alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
    cell.lblTitle = lblTitle;
    cell.lblTitle.text = @"土壤水分传感器3";
    
    [cell addImageView:cell.viewTemp imgName:@"temp" x:10 y:80 width:165 height:90];
    UILabel *lblTemp5 = [[UILabel alloc]init];
    [cell addLabel:lblTemp5 toLabel:cell.lblTemp5 color:MainColor alignment:NSTextAlignmentRight x:62 y:112.5 width:100 height:25];
    cell.lblTemp5 = lblTemp5;
    
    [cell addImageView:cell.viewSoil imgName:@"soil_humidity" x:200 y:80 width:165 height:90];
    UILabel *lblSoil5 = [[UILabel alloc]init];
    [cell addLabel:lblSoil5 toLabel:cell.lblSoil5 color:MainColor alignment:NSTextAlignmentRight x:252 y:112.5 width:100 height:25];
    cell.lblSoil5 = lblSoil5;
    cell.lblTemp5.text = _temp5;
    cell.lblSoil5.text = _soil5;
}

- (void)setCell5:(TYCyclePagerViewCell *)cell{
    UILabel *lblTitle = [[UILabel alloc]init];
    [cell addLabel:lblTitle toLabel:cell.lblTitle color:BlackColor alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
    cell.lblTitle = lblTitle;
    cell.lblTitle.text = @"土壤检测传感器";
    
    [cell addImageView:cell.viewConductivity imgName:@"conductivity" x:10 y:80 width:165 height:90];
    UILabel *lblConductivity = [[UILabel alloc]init];
    [cell addLabel:lblConductivity toLabel:cell.lblConductivity color:MainColor alignment:NSTextAlignmentRight x:62 y:112.5 width:100 height:25];
    cell.lblConductivity = lblConductivity;
    
    [cell addImageView:cell.viewSalinity imgName:@"salinity" x:200 y:80 width:165 height:90];
    UILabel *lblSalinity = [[UILabel alloc]init];
    [cell addLabel:lblSalinity toLabel:cell.lblSalinity color:MainColor alignment:NSTextAlignmentRight x:252 y:112.5 width:100 height:25];
    cell.lblSalinity = lblSalinity;
    cell.lblConductivity.text = _conductivity;
    cell.lblSalinity.text = _salinity;
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
        _imgViewWea.frame = CGRectMake(37, 127, 70, 48.4);
    }
    else if([weather  isEqualToString:@"多云"])
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

- (IBAction)publicID1:(id)sender {
}

- (IBAction)publicID2:(id)sender {
}

- (IBAction)publicID3:(id)sender {
}

- (IBAction)publicID4:(id)sender {
}

- (IBAction)publicID5:(id)sender {
}



- (IBAction)actSensor:(id)sender {
    _btnSensor.selected = true;
    _btnController.selected = false;
    [self switchSubview];
}

- (IBAction)actController:(id)sender {
    _btnSensor.selected = false;
    _btnController.selected = true;
    [self switchSubview];
}

-(void)switchSubview{
    if(_btnSensor.selected == true)
    {
        _pagerView.hidden = false;
        
    }
    else
    {
        _pagerView.hidden = true;
        
    }
}


@end
