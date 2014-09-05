//
//  AWNTabBarController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/4/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNTabBarController.h"

/**
 Tab bar indicies
 */
typedef NS_ENUM(NSInteger, AWNTabBarIndex) {
    AWNTabBarEventIndex = 0,
    AWNTabBarAboutIndex
};

@implementation AWNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // Initially selected tab bar icon needs to have selected images
    UITabBarItem *tabBarItem = self.tabBar.items[0];
    tabBarItem.image = [UIImage imageNamed:@"ObjectTabBarIcon"];
    tabBarItem.selectedImage = [UIImage imageNamed:@"ObjectSelectedTabBarIcon"];
}

// Selected tab bar item should have selected tab bar item icons
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    switch ([tabBarController selectedIndex]) {
        case AWNTabBarEventIndex:
            viewController.tabBarItem.image = [UIImage imageNamed:@"ObjectTabBarIcon"];
            viewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ObjectSelectedTabBarIcon"];
            
            break;
        case AWNTabBarAboutIndex:
            viewController.tabBarItem.image = [UIImage imageNamed:@"AboutTabBarIcon"];
            viewController.tabBarItem.selectedImage = [UIImage imageNamed:@"AboutSelectedTabBarIcon"];
            
            break;
        default:
            
            break;
    }
}

@end