/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import "Settings.h"

#import "ProfileVC.h"
#import "WelcomeVC.h"
#import "ChatWallpapersVC.h"
#import "AboutVC.h"

#import "Configs.h"
#import "Messages.h"
#import "Utilities.h"


@interface Settings ()
@end

@implementation Settings

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] != nil) {
        
    } else {
        WelcomeVC *welcomeVC =[self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        [self.navigationController pushViewController: welcomeVC animated:true];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Set Controller's Title
    self.title = @"Settings";
    
    
    // Init arrays options ========
    generalRows = @[@"About",
                    @"Tell a Friend"
                    ];
    
    
    accountRows = @[@"Profile",
                    @"Chat Wallpaper"
                    ];
}





#pragma mark - TABLEVIEW DELEGATES ======================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return generalRows.count;
    if (section == 1) return accountRows.count;
    
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"General";
    if (section == 1) return @"Account";
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    // GENERAL SECTION ============
    if (indexPath.section == 0) {
        cell.textLabel.text = [generalRows objectAtIndex:indexPath.row];
    }
    
    
    // ACCOUNT SECTION =============
    if (indexPath.section == 1) {
        cell.textLabel.text = [accountRows objectAtIndex:indexPath.row];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
// GENERAL SECTION ================================================
    if (indexPath.section == 0) {
        switch (indexPath.row) {
                
            // Open the About VC
            case 0: {
                AboutVC *aboutVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AboutVC"];
                [self.navigationController pushViewController: aboutVC animated:true];
                break;}
                
            // Open an ActionSheet for sharing options
            case 1: {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Tell a Friend"
                delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                otherButtonTitles:@"Mail",
                                  @"Message",
                                  @"Facebook",
                                  @"Twitter",
                                    nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
                break;}
                
                
            default:break;
        }
    }
//====================================================================================
    
    
    
    
// ACCOUNT SECTION =================================================
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            
                // Open Profile VC
            case 0: {
                ProfileVC *profVC =[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
                [self.navigationController pushViewController: profVC animated:true];
                break; }
                
            // Open the Wallpapers list
            case 1: {
                ChatWallpapersVC *chatWP =[self.storyboard instantiateViewControllerWithIdentifier:@"ChatWallpapersVC"];
                [self.navigationController pushViewController: chatWP animated:true];
                break; }
                
                
            default: break;
        }
    }
    //===============================================================
    
}


#pragma mark - ACTION SHEET DELEGATE =====================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        
#pragma mark - EMAIL ======================================
        case 0: {
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:@"WazzUp" ];
            [mc setMessageBody:INVITE_FRIENDS_MESSAGE isHTML:true];
            // Prepare the Logo image to be shared by Email
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"logo"]);
            [mc addAttachmentData:imageData  mimeType:@"image/png" fileName:@"WazzUp.png"];
            // Present Email View Controller
            [self presentViewController:mc animated:true completion:nil];

            break; }
            
            
#pragma mark - SMS MESSAGE ======================================
        case 1: {
            MFMessageComposeViewController *composer = [[MFMessageComposeViewController alloc] init];
            composer.messageComposeDelegate = self;
            composer.body = INVITE_FRIENDS_MESSAGE;
            [self presentViewController:composer animated:true completion:nil];
            break; }
    
            
            
#pragma mark - FACEBOOK ======================================
        case 2: {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                Socialcontroller = [SLComposeViewController
                                    composeViewControllerForServiceType:SLServiceTypeFacebook];
                [Socialcontroller setInitialText:INVITE_FRIENDS_MESSAGE];
                [Socialcontroller addImage: [UIImage imageNamed:@"logo"]];
                [self presentViewController:Socialcontroller animated:true completion:nil];
            } else {
                NSString *message = @"Please go to Settings and add your Facebook account to this device!";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            [Socialcontroller setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output;
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        output = @"Sharing Cancelled!";
                        break;
                    case SLComposeViewControllerResultDone:
                        output = @"You Image is on Facebook!";
                        
                        break;
                    default: break;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];

            break; }
    
            
#pragma mark - TWITTER ======================================
        case 3: {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                Socialcontroller = [SLComposeViewController
                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
                [Socialcontroller setInitialText:INVITE_FRIENDS_MESSAGE];
                [Socialcontroller addImage: [UIImage imageNamed:@"logo"]];
                [self presentViewController:Socialcontroller animated:true completion:nil];
            } else {
                NSString *message = @"Please go to Settings and add your Twitter account to this device!";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            [Socialcontroller setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output;
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        output = @"Sharing Cancelled!";
                        break;
                    case SLComposeViewControllerResultDone:
                        output = @"You Image is on Twitter!";
                        break;
                        
                    default: break;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];

            break; }
    }

    
}


#pragma mark - SMS MESSAGE DELEGATE ============
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - EMAIL DELEGATES ================================
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)results error:(NSError *)error {
    switch (results) {
        case MFMailComposeResultCancelled: {
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Cancelled!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        } break;
            
        case MFMailComposeResultSaved:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Saved!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        } break;
            
        case MFMailComposeResultSent:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Sent!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        } break;
            
        case MFMailComposeResultFailed:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email error, try again!"
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        } break;
            
            
        default: break;
    }
    // Dismiss the Email View Controller
    [self dismissViewControllerAnimated:true completion:NULL];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
