/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/



#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "pushnotification.h"

#import "ContactsVC.h"
#import "RegisterVC.h"

@interface RegisterVC()

@end


@implementation RegisterVC


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title = @"Zona de Registro";
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[_nameTxt becomeFirstResponder];
}

- (void)dismissKeyboard {
	[self.view endEditing: true];
}





#pragma mark - REGISTER BUTTON ======================================
- (IBAction)registerButt:(id)sender {
    
	NSString *name = _nameTxt.text;
	NSString *password = _passwordTxt.text;
    NSString *email	= [_emailTxt.text lowercaseString];
    NSString *phoneNr	= _phoneTxt.text;

    if ([name length] == 0) {
        [ProgressHUD showError:@"Please type your Name"]; return;
    }
	if ([password length] == 0)	{
        [ProgressHUD showError:@"Please type a Password"]; return;
    }
	if ([email length] == 0) {
        [ProgressHUD showError:@"Please type your Email Address"]; return;
    }
    if ([phoneNr length] == 0) {
        [ProgressHUD showError:@"Please type your Phone Number"]; return;
    }
    
    [ProgressHUD show:@"Registering..." Interaction: false];
    
    
    // Save the New Account into Parse database
	PFUser *user = [PFUser user];
	user.username = email;
	user.password = password;
    user.email = email;
    
    user[PF_USER_EMAILCOPY] = email;
    user[PF_USER_PHONE] = phoneNr;
    user[PF_USER_FULLNAME] = name;
    user[PF_USER_STATUS] = @"Hi There, I'm on WazzUp!";
	user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
	
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error == nil) {
			ParsePushUserAssign();
			[ProgressHUD showSuccess:@"Account registered!"];
            
			[self dismissViewControllerAnimated:true completion:nil];
            
		} else [ProgressHUD showError:error.userInfo[@"error"]];
	}];
}





#pragma mark - TEXT FIELD DELEGATE =======================
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	if (textField == _nameTxt) {
		[_passwordTxt becomeFirstResponder];
	}

    if (textField == _passwordTxt) {
		[_passwordTxt becomeFirstResponder];
	}
    
	if (textField == _emailTxt) {
		[self registerButt:nil];
	}
    
    [_passwordTxt resignFirstResponder];
    
	return true;
}


@end
