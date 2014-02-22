//
//  ESTViewController.m
//  ProximityDemo
//
//  Created by Marcin Klimek on 9/26/13.
//  Copyright (c) 2013 Estimote. All rights reserved.
//

#import "ESTViewController.h"
#import <ESTBeaconManager.h>

@interface ESTViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) ESTBeacon* selectedBeacon;
@property (nonatomic, strong) ESTBeacon* secondBeacon;

@end

@implementation ESTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    self.beaconColors = @{@43241:@"Dark Blue",
                            @34523:@"Light Blue"};
    
    NSLog(@"%@",[self.beaconColors objectForKey:@43241]);
    
    // craete manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    if([beacons count] > 0)
    {
        
        if(!self.selectedBeacon)
        {
            // initialy pick closest beacon
            self.selectedBeacon = [beacons objectAtIndex:0];
            self.secondBeacon = [beacons objectAtIndex:1];
        }
        else
        {
            for (ESTBeacon* cBeacon in beacons)
            {
                // update beacon it same as selected initially
                if([self.selectedBeacon.major unsignedShortValue] == [cBeacon.major unsignedShortValue] &&
                   [self.selectedBeacon.minor unsignedShortValue] == [cBeacon.minor unsignedShortValue])
                {
                    self.selectedBeacon = cBeacon;
                }
            }
        }
        
        
        
        // beacon array is sorted based on distance
        // closest beacon is the first one
        
        int firstColor = [self.selectedBeacon.major integerValue];
        int secondColor = [self.secondBeacon.major integerValue];
        
        NSString* labelText = [NSString stringWithFormat:
                               @"%@ Hill \nRegion: ",
                               [self.beaconColors objectForKey:[NSNumber numberWithInt:firstColor]]];
        
        NSString* secondLabelText = [NSString stringWithFormat:
                                    @"%@ Hill \nRegion: ",
                                    [self.beaconColors objectForKey:[NSNumber numberWithInt:secondColor]]
                                     ];
        
        
        // calculate and set new y position
        switch (self.selectedBeacon.proximity)
        {
            case CLProximityUnknown:
                labelText = [labelText stringByAppendingString: @"Unknown"];
                break;
            case CLProximityImmediate:
                labelText = [labelText stringByAppendingString: @"Immediate"];
                break;
            case CLProximityNear:
                labelText = [labelText stringByAppendingString: @"Near"];
                break;
            case CLProximityFar:
                labelText = [labelText stringByAppendingString: @"Far"];
                break;
                
            default:
                break;
        }
        
        // calculate and set new y position
        switch (self.secondBeacon.proximity)
        {
            case CLProximityUnknown:
                secondLabelText = [secondLabelText stringByAppendingString: @"Unknown"];
                break;
            case CLProximityImmediate:
                secondLabelText = [secondLabelText stringByAppendingString: @"Immediate"];
                break;
            case CLProximityNear:
                secondLabelText = [secondLabelText stringByAppendingString: @"Near"];
                break;
            case CLProximityFar:
                secondLabelText = [secondLabelText stringByAppendingString: @"Far"];
                break;
                
            default:
                break;
        }
        
        self.distanceLabel.text = labelText;
        self.secondLabel.text = secondLabelText;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
