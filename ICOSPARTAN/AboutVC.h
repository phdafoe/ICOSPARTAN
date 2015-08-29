/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface AboutVC : UIViewController
<
MFMailComposeViewControllerDelegate
>

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *contactUsOutlet;
@property (weak, nonatomic) IBOutlet UIButton *helpOutlet;

// Logo Image
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end
