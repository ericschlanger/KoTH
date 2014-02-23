#import "LobbyViewController.h"
#import "CreateLobbyViewController.h"
#import <Parse/Parse.h>

@interface CreateLobbyViewController ()

@end

@implementation CreateLobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.lobbyName setDelegate:self];
    [self.lobbySize setDelegate:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finish:(id)sender {
    PFObject *lobby = [PFObject objectWithClassName:@"Lobby"];
    lobby[@"Name"] = [_lobbyName text];
    lobby[@"Progression"] = @[@43241,@34523,@42453,@43241,@34523,@42453,@43241,@34523,@42453];
    lobby[@"lobbySize"] = [_lobbySize text];
    
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    lobby[@"startTime"] = [NSNumber numberWithDouble:seconds+10];
    
    [lobby saveInBackground];
    
    [self performSegueWithIdentifier:@"createdLobby" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"createdLobby"]){
        
        
        
        LobbyViewController *vc = [segue destinationViewController];
        
        [vc setLobbyName:[self.lobbyName text]];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField{
    [aTextField resignFirstResponder];
    return YES;
}

@end
