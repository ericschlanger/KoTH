#include <Parse/Parse.h>

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)findWinner{
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"Lobby" equalTo:@"q"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableDictionary *tally = [[NSMutableDictionary alloc]init];
        
        [tally setObject:@"" forKey:@"teamOne"];
        [tally setObject:@"" forKey:@"teamTwo"];
        [tally setObject:@0 forKey:@"teamOneScore"];
        [tally setObject:@0 forKey:@"teamTwoScore"];
        
        if (!error) {
            //fill in names
            for (PFObject *object in objects) {
                if([[tally objectForKey:@"teamOne"] isEqualToString:@""]){
                    [tally setObject:object[@"Team"] forKey:@"teamOne"];
                    NSLog(@"setting team one as %@", object[@"Team"]);
                }else if([[tally objectForKey:@"teamTwo"] isEqualToString:@""]){
                    if(!([object[@"Team"] isEqualToString:[tally objectForKey:@"teamOne"]])){
                        [tally setObject:object[@"Team"] forKey:@"teamTwo"];
                    }
                }else{NSLog(@"both were assigned");}
            }
            
            //log scores for names
            for (PFObject *object in objects){
                if ([object[@"Team"] isEqualToString:[tally objectForKey:@"teamOne"]]){
                    NSNumber *temp = [tally objectForKey:@"teamOneScore"];
                    int sum = [(NSNumber *)object[@"Score"] intValue]+[temp intValue];
                    [tally setObject:[NSNumber numberWithInt:sum] forKey:@"teamOneScore"];
                }
                
                if ([object[@"Team"] isEqualToString:[tally objectForKey:@"teamTwo"]]){
                    NSNumber *temp = [tally objectForKey:@"teamTwoScore"];
                    int sum = [(NSNumber *)object[@"Score"] intValue]+[temp intValue];
                    [tally setObject:[NSNumber numberWithInt:sum] forKey:@"teamTwoScore"];
                }
                
            }
            
            NSLog(@"Final Tally: %@",tally);
            
            //show the alert of who won
            NSString *message =@"";
            
            NSNumber *tOne = [tally objectForKey:@"teamOneScore"];
            NSNumber *tTwo = [tally objectForKey:@"teamTwoScore"];
            
            NSLog(@"tOne value: %d, tTwo val: %d", [tOne intValue], [tTwo intValue]);
            
//            if([@"w" isEqualToString:[tally objectForKey:@"teamOne"]]){
//                NSLog(@"Team one on this phone.");
//                if([tOne intValue] > [tTwo intValue]){
//                    message = [NSString stringWithFormat:@"Congrats %@ from %@, You guys won! Final: %d - %d", _playerName, _teamName, [tOne intValue], [tTwo intValue] ];
//                } else {
//                    message = [NSString stringWithFormat:@"Sorry %@ from %@, You guys lost! Final: %d - %d", _playerName, _teamName, [tTwo intValue], [tOne intValue] ];
//                }
//            }
//            else {//they are on team two
//                NSLog(@"team two on this phone.");
//                if([tOne intValue] < [tTwo intValue]){
//                    message = [NSString stringWithFormat:@"Congrats %@ from %@, You guys won! Final: %d - %d", _playerName, _teamName, [tOne intValue], [tTwo intValue] ];
//                } else {
//                    message = [NSString stringWithFormat:@"Sorry %@ from %@, You guys lost! Final: %d - %d", _playerName, _teamName, [tTwo intValue], [tOne intValue] ];
//                }
//            }
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Results" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
