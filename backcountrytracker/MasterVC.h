//
//  MasterVC.h
//  backcountrytracker
//
//  Created by Matthew Propst on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <CoreLocation/CoreLocation.h>

@interface MasterVC : UIViewController<UITabBarDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) IBOutlet  UITabBar *tabbar;
@property (nonatomic, retain) IBOutlet  UITabBarItem *settings;
@property (nonatomic, retain) IBOutlet  UITabBarItem *stop;
@property (nonatomic, retain) IBOutlet  UIButton *help;

@end
