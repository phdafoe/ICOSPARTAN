/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "pushnotification.h"

#import "LoginVC.h"

MBProgressHUD *hud;
NSString *userFound;

@interface LoginVC()
@end



@implementation LoginVC

-(void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title = @"Login";
    
    // Round button's corners
    _loginOutlet.layer.cornerRadius = 5;
    _forgotPassOutlet.layer.cornerRadius = 5;
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
    action:@selector(dismissKeyboard)]];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    // Set email Txt field as first responder
	[_emailTxt becomeFirstResponder];
}


- (void)dismissKeyboard{
	[self.view endEditing:true];
}






#pragma mark - LOGIN BUTTON ======================================
- (IBAction)loginButt:(id)sender {
    
	NSString *email = [_emailTxt.text lowercaseString];
	NSString *password = _passwordTxt.text;

    if ([email length] == 0)	{
        [ProgressHUD showError:@"Por favor escriba si dirección de correo electrónico"]; return;
    }
	if ([password length] == 0)	{
        [ProgressHUD showError:@"Por favor escriba su clave"]; return;
    }
    [ProgressHUD show:@"Logging in..." Interaction: false];
	
    
    [PFUser logInWithUsernameInBackground:email password:password
     
    block:^(PFUser *user, NSError *error) {
		if (user != nil) {
			ParsePushUserAssign();
			[ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
			[self dismissViewControllerAnimated:true completion:nil];
		
        } else {
            [ProgressHUD showError:error.userInfo[@"error"]];
        }
	}];
}




#pragma mark - FORGOT PASSWORD BUTTON ======================================
- (IBAction)forgotPasswordButt:(id)sender {
    if ([PFUser currentUser] == nil   &&    ![_emailTxt.text isEqualToString:@""]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Please wait";
        [hud show:true];
        
        [_emailTxt resignFirstResponder];
        
        // Email address is valid: Parse will email you a link to reset your password
        [PFUser requestPasswordResetForEmailInBackground:_emailTxt.text
                        block:^(BOOL succeeded,NSError *error) {
            if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
            message:[NSString stringWithFormat: @"Link to reset your password has been send to specified email"]
            delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [hud hide:true];
            return;
                                                           
            } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
            message:[NSString stringWithFormat: @"Error: %@",errorString] delegate:nil
            cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [hud hide:true];
            return;
            }
        }];
        
    // Email field is empty
    } else if ([_emailTxt.text isEqualToString:@""]  ||  ![_emailTxt.text containsString:@"@"]) {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"WazzUp"
        message:@"Please enter a valid email address" delegate:self
        cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlert show];
    }
    
    
}



#pragma mark - TEXTFIELD DELEGATE - ON RETURN BUTTON ===============================
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _emailTxt) {
		[_passwordTxt becomeFirstResponder];
	}
    
	if (textField == _passwordTxt) {
		[self loginButt:nil];
	}
    
    [_passwordTxt resignFirstResponder];
    
	return true;
}

@end
