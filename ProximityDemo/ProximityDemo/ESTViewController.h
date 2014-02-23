//
//  ESTViewController.h
//  ProximityDemo
//
//  Created by Marcin Klimek on 9/26/13.
//  Copyright (c) 2013 Estimote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESTViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentHillLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) NSDictionary *beaconColors;

@property (strong, nonatomic) NSArray *progression;

@property (strong, nonatomic) NSNumber *startTime;

@property (strong, nonatomic)NSString *teamName;

@property (strong, nonatomic)NSString *playerName;

@property (strong, nonatomic)NSString *lobbyName;

@end
