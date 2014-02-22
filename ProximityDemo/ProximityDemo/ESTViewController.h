//
//  ESTViewController.h
//  ProximityDemo
//
//  Created by Marcin Klimek on 9/26/13.
//  Copyright (c) 2013 Estimote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESTViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (strong, nonatomic) NSDictionary *beaconColors;

@end
