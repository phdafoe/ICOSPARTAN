/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import "NavigationController.h"




@interface ProfileVC : UIViewController
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

// User Image
@property (weak, nonatomic) IBOutlet PFImageView *userImage;

// Text Fields
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *statusTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *saveOutlet;


@end
