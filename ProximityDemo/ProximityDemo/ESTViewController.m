#import <Parse/Parse.h>
#import "ESTViewController.h"
#import <ESTBeaconManager.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ResultsViewController.h"

@interface ESTViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) ESTBeacon* selectedBeacon;
@property (nonatomic, strong) ESTBeacon* secondBeacon;
@property (nonatomic, strong) ESTBeacon* thirdBeacon;


@end

@implementation ESTViewController{
    int currentHillID;
    int currentScore;
    NSTimer *timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentScore = 0;
    
    [_scoreLabel setText:@"Your Score: 0"];
    
    self.progression = @[@43241,@34523,@42453,@43241,@34523,@42453,@43241,@34523,@42453];
    
    self.beaconColors = @{@43241:@"Purple",
                        @34523:@"Sea Green",
                        @42453:@"Sky Blue"};
    
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
    
//    
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setDay:22];
//    [comps setMonth:2];
//    [comps setYear:2014];
//    [comps setHour:17];
//    [comps setMinute:32];
//    [comps setSecond:30];
//    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *endTime = [cal dateFromComponents:comps];
    
    [self startAtDate:_startTime];
}

-(void)startGame{
    timer = [NSTimer scheduledTimerWithTimeInterval: 4 target: self
                                                      selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: YES];
}

-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    
    if([beacons count] > 0)
    {
        if(!self.selectedBeacon || !self.secondBeacon || !self.thirdBeacon){
            @try {
                self.selectedBeacon = [beacons objectAtIndex:0];
                self.secondBeacon = [beacons objectAtIndex:1];
                self.thirdBeacon = [beacons objectAtIndex:2];
            }
            @catch (NSException *exception) {
                
            }
            
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
        
        int firstColor = [self.selectedBeacon.major integerValue];
        int secondColor = [self.secondBeacon.major integerValue];
        int thirdColor = [self.thirdBeacon.major integerValue];
        
//        NSLog(@"first major: %@\nSecond Major: %@\n Third Major:%@",self.selectedBeacon.major,self.secondBeacon.major, self.thirdBeacon.major);
        
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
            case CLProximityImmediate:
                labelText = [labelText stringByAppendingString: @"Immediate"];
                if(currentHillID == [self.selectedBeacon.major integerValue]){
                    currentScore++;
                    [self.scoreLabel setText:[NSString stringWithFormat:@"Your Score: %d",currentScore]];
                    NSLog(@"scoring at %@", [self.beaconColors objectForKey:[NSNumber numberWithInt:[self.selectedBeacon.major integerValue]]]);
                }
                break;
                
            default:
                break;
        }
        
        // calculate and set new y position
        switch (self.secondBeacon.proximity)
        {
            case CLProximityImmediate:
                secondLabelText = [secondLabelText stringByAppendingString: @"Immediate"];
                if(currentHillID == [self.secondBeacon.major integerValue]){
                    currentScore++;
                    [self.scoreLabel setText:[NSString stringWithFormat:@"Your Score: %d",currentScore]];
                    NSLog(@"scoring at %@", [self.beaconColors objectForKey:[NSNumber numberWithInt:[self.secondBeacon.major integerValue]]]);
                }
                break;
                
            default:
                break;
        }
        
        switch (self.thirdBeacon.proximity)
        {
            case CLProximityImmediate:
                //secondLabelText = [secondLabelText stringByAppendingString: @"Immediate"];
                if(currentHillID == [self.thirdBeacon.major integerValue]){
                    currentScore++;
                    [self.scoreLabel setText:[NSString stringWithFormat:@"Your Score: %d",currentScore]];
                    NSLog(@"scoring at %@", [self.beaconColors objectForKey:[NSNumber numberWithInt:[self.thirdBeacon.major integerValue]]]);
                }
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
        
        currentHillID = [self.progression[count-1] integerValue];
        [self.currentHillLabel setText:[NSString stringWithFormat:@"Current Hill: %@", [self.beaconColors objectForKey:[NSNumber numberWithInt: currentHillID]]]];
        [self vibratePhone];
        
        if (count == 6){
            
            [timer invalidate];
            [self performSegueWithIdentifier:@"endGame" sender:self];
        }
    }
    @catch (NSException *exception){
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
    @finally {
        
        count ++;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"endGame"]) {
        ResultsViewController *destination = [segue destinationViewController];
        [destination setTeamName:_teamName];
        [destination setPlayerName:_playerName];
        [destination setScore:[NSNumber numberWithInt:currentScore]];
        [destination setLobbyName:_lobbyName];
    }
}

-(void)startAtDate:(NSNumber*)time{
    
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval secs = [time doubleValue] - current;
    
    
    [self performSelector:@selector(startGame) withObject:Nil afterDelay:secs];

}

-(void)vibratePhone{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
