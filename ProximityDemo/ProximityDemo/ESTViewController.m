#import <Parse/Parse.h>
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
    
    
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self
                                                      selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: YES];

    
    
    self.beaconColors = @{@43241:@"Dark Blue",
                            @34523:@"Light Blue"};
    
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
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:22];
    [comps setMonth:2];
    [comps setYear:2014];
    [comps setHour:17];
    [comps setMinute:32];
    [comps setSecond:30];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *endTime = [cal dateFromComponents:comps];
    
    [self startAtDate:endTime];
    
}

-(void)printHello{
    NSLog(@"hello");
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

-(void) callAfterSixtySecond:(NSTimer*) sender{
    static int count = 1;
    
    @try {
        
        NSLog(@"triggred %d time",count);
        
        if (count == 10){
            
            [sender invalidate];
            NSLog(@"invalidated");
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
    @finally {
        
        count ++;
    }
}

-(void)startAtDate:(NSDate *)date{
    NSDate *startTime = [NSDate date];
    
    NSTimeInterval secs = [date timeIntervalSinceDate:startTime];
    
    NSLog(@"Time Interval: %f", secs);
    
    [self performSelector:@selector(printHello) withObject:Nil afterDelay:secs];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end