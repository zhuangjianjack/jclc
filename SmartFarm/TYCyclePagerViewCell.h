//
//  TYCyclePagerViewCell.h
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/21.
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYCyclePagerViewCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *lblTitle;

@property (nonatomic, weak) UILabel *lblTemp1;
@property (nonatomic, weak) UILabel *lblLight;
@property (nonatomic, weak) UILabel *lblAir1;

@property (nonatomic, weak) UILabel *lblTemp2;
@property (nonatomic, weak) UILabel *lblCO2;
@property (nonatomic, weak) UILabel *lblAir2;

@property (nonatomic, weak) UILabel *lblTemp3;
@property (nonatomic, weak) UILabel *lblSoil3;

@property (nonatomic, weak) UILabel *lblTemp4;
@property (nonatomic, weak) UILabel *lblSoil4;

@property (nonatomic, weak) UILabel *lblTemp5;
@property (nonatomic, weak) UILabel *lblSoil5;

@property (nonatomic, weak) UILabel *lblConductivity;
@property (nonatomic, weak) UILabel *lblSalinity;

@property (nonatomic, weak, readonly) UIImage *temp;
@property (nonatomic, weak, readonly) UIImageView *viewTemp;

@property (nonatomic, weak, readonly) UIImage *light;
@property (nonatomic, weak, readonly) UIImageView *viewLight;

@property (nonatomic, weak, readonly) UIImage *air;
@property (nonatomic, weak, readonly) UIImageView *viewAir;

@property (nonatomic, weak, readonly) UIImage *co2;
@property (nonatomic, weak, readonly) UIImageView *viewCO2;

@property (nonatomic, weak, readonly) UIImage *soil;
@property (nonatomic, weak, readonly) UIImageView *viewSoil;

@property (nonatomic, weak, readonly) UIImage *conductivity;
@property (nonatomic, weak, readonly) UIImageView *viewConductivity;

@property (nonatomic, weak, readonly) UIImage *salinity;
@property (nonatomic, weak, readonly) UIImageView *viewSalinity;


-(void)addLabel:(UILabel *)fromLable toLabel:(UILabel *)toLabel color:(UIColor *)color alignment:(NSTextAlignment)alignment x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
-(void)addImageView:(UIImageView *)toImageView imgName:(NSString *)name x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end
