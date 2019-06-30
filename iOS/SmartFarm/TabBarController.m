//
//  TabBarController.m
//  SmartFarm
//
//  Created by Ssiswent on 2019/6/23.b0
//  Copyright © 2019年 Ssiswent. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UITabBar *tabBar = self.tabBar;
    //    for (UITabBarItem *item in tabBar.items) {item.imageInsets = UIEdgeInsetsMake(18, 18, 18,18);}
    
    
    tabBar.tintColor=[UIColor colorWithRed:75.0/255.0 green:218.0/255.0 blue:100.0/255.0 alpha:1.0];
    
    
}


@end
