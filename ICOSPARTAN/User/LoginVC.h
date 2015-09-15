
/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import "MBProgressHUD.h"


@interface LoginVC : UIViewController
<
UITextFieldDelegate,
UIAlertViewDelegate
>


// Text Fields
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *forgotPassOutlet;
@property (weak, nonatomic) IBOutlet UIButton *loginOutlet;


@end
