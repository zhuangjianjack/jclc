//
//  TYCyclePagerViewCell.m
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/21.
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()

@property (nonatomic, weak) UIImage *temp;
@property (nonatomic, weak) UIImageView *viewTemp;

@property (nonatomic, weak) UIImage *light;
@property (nonatomic, weak) UIImageView *viewLight;

@property (nonatomic, weak) UIImage *air;
@property (nonatomic, weak) UIImageView *viewAir;

@property (nonatomic, weak) UIImage *co2;
@property (nonatomic, weak) UIImageView *viewCO2;

@property (nonatomic, weak) UIImage *soil;
@property (nonatomic, weak) UIImageView *viewSoil;

@property (nonatomic, weak) UIImage *conductivity;
@property (nonatomic, weak) UIImageView *viewConductivity;

@property (nonatomic, weak) UIImage *salinity;
@property (nonatomic, weak) UIImageView *viewSalinity;


@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addView];
    }
    return self;
}


- (void)addView {
    //    viewTemp.frame=CGRectMake(10, 266, temp.size.width, temp.size.height);
    //上面括号内的设置方式可以让图片以原图尺寸显示
    //    [self addLabel:_label color:BlackColor text:@"光照温湿度变送器" alignment:NSTextAlignmentLeft x:10 y:30 width:200 height:30];
}

-(void)addLabel:(UILabel *)fromLable toLabel:(UILabel *)toLabel color:(UIColor *)color alignment:(NSTextAlignment)alignment x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    fromLable.textColor = color;
    fromLable.font = [UIFont boldSystemFontOfSize:24];
    fromLable.textAlignment = alignment;
    fromLable.frame = CGRectMake(x, y, width, height);
    [self addSubview:fromLable];
}

-(void)addImageView:(UIImageView *)toImageView imgName:(NSString *)name x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    UIImage *img = [UIImage imageNamed:name];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(x, y, width, height);
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];
    toImageView = imgView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    _label.frame = self.bounds;
    //    _viewTemp.frame = self.bounds;
}

@end
