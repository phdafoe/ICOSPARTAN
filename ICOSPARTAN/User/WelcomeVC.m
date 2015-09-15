/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import "AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "pushnotification.h"
#import "Utilities.h"

#import "WelcomeVC.h"
#import "LoginVC.h"
#import "RegisterVC.h"


@implementation WelcomeVC

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
	[super viewDidLoad];

    // Set controller's title
    self.title = @"iCoChat";
    
    
    // Round the corners of the Logo
    _logoImage.layer.cornerRadius = 22;
    
    // Round button's corners
    _loginOutlet.layer.cornerRadius = 5;
    _facebookOutlet.layer.cornerRadius = 5;
    _signUpOutlet.layer.cornerRadius = 5;
}


#pragma mark - REGISTER BUTTON ======================================
- (IBAction)registerButt:(id)sender {
    RegisterVC *registerVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController: registerVC animated:true];
}


#pragma mark - LOGIN BUTTON ======================================
- (IBAction)loginButt:(id)sender {
    LoginVC *loginVC =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController: loginVC animated:true];
    
}



#pragma mark - LOGIN FACEBOOK BUTTON =======================
- (IBAction)loginFacebookButt:(id)sender {
    
	[ProgressHUD show:@"Signing in..." Interaction: false];
    
	[PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"]
    block:^(PFUser *user, NSError *error) {
		if (user != nil) {
			if (user[PF_USER_FACEBOOKID] == nil) {
            [self requestFacebook:user];
            
            } else {
            [self userLoggedIn:user];
            }
        
        } else {
            [ProgressHUD showError:error.userInfo[@"error"]];
        }
        
	}];
}

- (void)requestFacebook:(PFUser *)user {
	FBRequest *request = [FBRequest requestForMe];
    
	[request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
		if (error == nil) {
			NSDictionary *userData = (NSDictionary *)result;
			[self processFacebook:user UserData:userData];
		} else {
            [PFUser logOut];
			[ProgressHUD showError:@"Failed to fetch Facebook user data."];
		}
	}];
}

- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData {
	NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFImageResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		UIImage *image = (UIImage *)responseObject;

        if (image.size.width > 140) image = ResizeImage(image, 140, 140);

        PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
		[filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error != nil) [ProgressHUD showError:error.userInfo[@"error"]];
		}];

        if (image.size.width > 30) image = ResizeImage(image, 30, 30);

        PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
		[fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (error != nil) [ProgressHUD showError:error.userInfo[@"error"]];
		}];

        user[PF_USER_EMAILCOPY] = userData[@"email"];
		user[PF_USER_FULLNAME] = userData[@"name"];
		user[PF_USER_FULLNAME_LOWER] = [userData[@"name"] lowercaseString];
		user[PF_USER_FACEBOOKID] = userData[@"id"];
		user[PF_USER_PICTURE] = filePicture;
		user[PF_USER_THUMBNAIL] = fileThumbnail;
		[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error == nil)
			{
				[self userLoggedIn:user];
			} else {
				[PFUser logOut];
				[ProgressHUD showError:error.userInfo[@"error"]];
			}
		}];
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[PFUser logOut];
		[ProgressHUD showError:@"Failed to fetch Facebook profile picture."];
	}];

    [[NSOperationQueue mainQueue] addOperation:operation];
}



#pragma mark - DISMISS BUTTON ======================================
- (IBAction)dismissButt:(id)sender {
    [self dismissViewControllerAnimated: true completion:nil];
}


#pragma mark - CHECK USER LOGGED IN ======================================
- (void)userLoggedIn:(PFUser *)user {
    
	ParsePushUserAssign();
	[ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
    
	[self dismissViewControllerAnimated: true completion:nil];
    
   // NSLog(@"User loggedIn!");
}


- (IBAction)showMenuSpartano:(id)sender {
    
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


@end
