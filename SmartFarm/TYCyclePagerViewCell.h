//
//  TYCyclePagerViewCell.h
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/21.
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYCyclePagerViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UILabel *label;

@property (nonatomic, weak, readonly) UILabel *lblTemp;
@property (nonatomic, weak, readonly) UILabel *lblLight;
@property (nonatomic, weak, readonly) UILabel *lblAir;

@property (nonatomic, weak, readonly) UIImage *temp;
@property (nonatomic, weak, readonly) UIImageView *viewTemp;

@property (nonatomic, weak, readonly) UIImage *light;
@property (nonatomic, weak, readonly) UIImageView *viewLight;


@property (nonatomic, weak, readonly) UIImage *air;
@property (nonatomic, weak, readonly) UIImageView *viewAir;



@end
