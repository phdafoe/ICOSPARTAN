/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import "REFrostedViewController.h"


@interface WelcomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;


// Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginOutlet;
@property (weak, nonatomic) IBOutlet UIButton *facebookOutlet;
@property (weak, nonatomic) IBOutlet UIButton *signUpOutlet;


- (IBAction)showMenuSpartano:(id)sender;


@end
