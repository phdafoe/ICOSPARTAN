/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/



#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Nosotros";
    
    // Round image corners
    _logoImage.layer.cornerRadius = 22;

    // Round button's corners
    _contactUsOutlet.layer.cornerRadius = 5;
    _helpOutlet.layer.cornerRadius = 5;
}


#pragma mark - CONTACT US BUTTON ==============================
- (IBAction)contactButt:(id)sender {
    NSString *emailTitle = @"iCoSpartanChat";
    NSString *messageBody = @"Hola, por favor proporcionarnos algún tipo de apoyo";
    
    // Alloc the Mail composer controller
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:true];
    // Presents Email View Controller
    [self presentViewController:mc animated:true completion:nil];
}
// Email results ================
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)results error:(NSError *)error {
    switch (results) {
            
        case MFMailComposeResultCancelled: {
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Cancelled!"
            message:nil delegate:self
            cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultSaved:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Saved!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultSent:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Sent!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultFailed:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email error, try again!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
            
        default: break;
    }
    
    // Dismiss the Email View Controller
    [self dismissViewControllerAnimated:true completion: nil];
}




#pragma mark - HELP BUTTON ==============================
- (IBAction)helpButt:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL
    // Set here your own website link to a support page (if you don't have any web support page, then delete this button or build it)
    URLWithString:@"http://www.icospartan.com"]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
