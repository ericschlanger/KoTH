#import <Parse/Parse.h>
#import "ResultsViewController.h"

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ResultsViewController

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
	
    [self.label setText:_teamName];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"Name" equalTo:_playerName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            PFObject *player = (PFObject *)objects[0];
            player[@"Score"] = _score;
            
            NSLog(@"updated player before updating: %@",player);
            
            [player saveInBackground];
            
            [self performSelector:@selector(findWinner) withObject:Nil afterDelay:10];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)findWinner{
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"Lobby" equalTo:_lobbyName];
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
                }else if([[tally objectForKey:@"teamTwo"] isEqualToString:@""]){
                    [tally setObject:object[@"Team"] forKey:@"teamTwo"];
                }
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
