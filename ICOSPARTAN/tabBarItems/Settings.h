/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>






@interface Settings : UIViewController
<
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate
>

// TableView
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end
