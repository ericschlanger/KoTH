//
//  LobbyViewController.h
//  ProximityDemo
//
//  Created by Eric Schlanger on 2/22/14.
//  Copyright (c) 2014 Estimote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LobbyViewController : UIViewController

@property (strong,nonatomic)NSString *lobbyName;
@property (weak, nonatomic) IBOutlet UITextField *lobbyField;

@end
