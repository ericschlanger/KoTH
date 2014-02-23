#import "LobbyViewController.h"
#import <Parse/Parse.h>
#import "ESTViewController.h"

@interface LobbyViewController ()

@end

@implementation LobbyViewController{
    __block NSNumber *startTime;
}

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
	
    if(_lobbyName){
        [self.lobbyField setText:_lobbyName];
    }
    
    [_lobbyField setDelegate:self];
    [_playerName setDelegate:self];
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerPlayer:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Lobby"];
    [query whereKey:@"Name" equalTo:[self.lobbyField text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            
            PFObject *lobby = (PFObject *)objects[0];
            startTime = lobby[@"startTime"];
            
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            if(lobby[@"Players"]){
                temp = lobby[@"Players"];
            }
            NSLog(@"empty array temp: %@",temp);
            [temp addObject:[_playerName text]];
            lobby[@"Players"] = temp;
            [lobby saveInBackground];
            
            [self performSegueWithIdentifier:@"startGame" sender:self];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"startGame"]){
        ESTViewController *destination = [segue destinationViewController];
        [destination setStartTime:startTime];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField*)aTextField{
    [aTextField resignFirstResponder];
    return YES;
}



@end
