/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "Camera.h"
#import "pushnotification.h"
#import "Utilities.h"

#import "ProfileVC.h"
#import "WelcomeVC.h"
#import "NavigationController.h"

NavigationController *navCont;

@interface ProfileVC()



@end


@implementation ProfileVC


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title = @"Perfil";
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];

    _userImage.layer.cornerRadius = _userImage.frame.size.width/2;
    
    _containerScrollView.contentSize = CGSizeMake(_containerScrollView.frame.size.width, self.view.frame.size.height);

    // Round button's corners
    _saveOutlet.layer.cornerRadius = 5;
    
}



- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    if ([PFUser currentUser] != nil) {
    [self loadUser];
        
	} else {
        WelcomeVC *welcomeVC =[self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        [self.navigationController pushViewController: welcomeVC animated:true];
    }
}


- (void)dismissKeyboard {
	[self.view endEditing: true];
}




#pragma mark - LOAD CURRENT USER =================
- (void)loadUser {
	PFUser *user = [PFUser currentUser];

	[_userImage setFile:user[PF_USER_PICTURE]];
	[_userImage loadInBackground];

	_nameTxt.text = user[PF_USER_FULLNAME];
    _statusTxt.text = user[PF_USER_STATUS];
    _emailTxt.text = user[PF_USER_EMAIL];
    _phoneTxt.text = user[PF_USER_PHONE];
}


#pragma mark - SAVE CURRENT USER =================
- (void)saveUser {
	if ([_nameTxt.text length] != 0) {
        
		PFUser *user = [PFUser currentUser];
        user[PF_USER_FULLNAME] = _nameTxt.text;
        user[PF_USER_STATUS] = _statusTxt.text;
		user[PF_USER_FULLNAME_LOWER] = [_nameTxt.text lowercaseString];
        user[PF_USER_PHONE] = _phoneTxt.text;
        user.email = _emailTxt.text;
        user[PF_USER_USERNAME] = _emailTxt.text;
        user[PF_USER_EMAILCOPY] = _emailTxt.text;
        
		[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (error == nil) {
				[ProgressHUD showSuccess:@"Tus datos se ha guardado !"];
			
            } else [ProgressHUD showError:@"Network error."];
		}];
    
    } else {
       [ProgressHUD showError:@"Por favor escriba su nombre"];
    }
}

- (void)cleanup {
	_userImage.image = [UIImage imageNamed:@"profile_blank"];
	_nameTxt.text =
    _statusTxt.text = nil;
}





#pragma mark - LOG OUT BUTTON =============================
- (IBAction)logoutButt:(id)sender {
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
        otherButtonTitles:@"Logout", nil];
	[action showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		[PFUser logOut];
		ParsePushUserResign();
		PostNotification(NOTIFICATION_USER_LOGGED_OUT);
		[self cleanup];
        
        // Open the Welcome VC again
        WelcomeVC *welcomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        navCont = [[NavigationController alloc]initWithRootViewController:welcomeVC];
        [self presentViewController:navCont animated:true completion:nil];
    }
    
}

#pragma mark - PHOTO BUTTON =============================
- (IBAction)photoButt:(id)sender {
	OpenPhotoLibrary(self, true);
}

#pragma mark - SAVE PROFILE INFO BUTTON =============================
- (IBAction)saveButt:(id)sender {
	[self dismissKeyboard];
	[self saveUser];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTxt) {
    [_emailTxt becomeFirstResponder];
    
    } else if (textField == _emailTxt) {
        [_phoneTxt becomeFirstResponder];
    
    } else if (textField == _phoneTxt) {
        [_phoneTxt resignFirstResponder];
        
    } else if (textField == _statusTxt) {
        [_statusTxt resignFirstResponder];
    }
    
    return true;
}

#pragma mark - UIImagePickerControllerDelegate =============
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
	UIImage *image = info[UIImagePickerControllerEditedImage];
    
    // Create Image
    if (image.size.width > 140) {
        image = ResizeImage(image, 140, 140);
    }
    PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
	[filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error != nil) [ProgressHUD showError:@"Network error."];
	}];
    _userImage.image = image;

    
    // Create Thumbnail
    if (image.size.width > 30) {
        image = ResizeImage(image, 30, 30);
    }
    PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
	[fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            [ProgressHUD showError:@"Network error."];
        }
    }];

    
    // Save Image & Thumbnail in Parse database
    PFUser *user = [PFUser currentUser];
	user[PF_USER_PICTURE] = filePicture;
	user[PF_USER_THUMBNAIL] = fileThumbnail;
	[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error != nil) [ProgressHUD showError:@"Network error."];
	}];

    [picker dismissViewControllerAnimated:true completion:nil];
}



@end
