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
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"createdLobby"]){
        
        PFObject *lobby = [PFObject objectWithClassName:@"Lobby"];
        lobby[@"Name"] = [_lobbyName text];
        lobby[@"Progression"] = @[@"blue",@"green",@"black"];
        //lobby[@"cheatMode"] = @NO;
        [lobby saveInBackground];
        
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
