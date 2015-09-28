/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/




#import <AddressBook/AddressBook.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "ChatCell.h"
#import "ChatCell.h"
#import "Messages.h"
#import "Utilities.h"

#import "ContactsVC.h"
#import "ChatVC.h"

#import "WelcomeVC.h"
#import "NavigationController.h"

//#import "ICONavigationViewController.h"



UILabel *pullToRefreshLabel;


@interface ContactsVC()
{
	NSMutableArray *nonRegisteredContacts;
	NSMutableArray *registeredContacts;

	NSIndexPath *indexSelected;
    UIRefreshControl *refreshControl;
    
    NSString *userYouChatWith;

}
@end




@implementation ContactsVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
	}
	return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
    // pullToRefresh  label
    pullToRefreshLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    pullToRefreshLabel.text = @"";
    pullToRefreshLabel.textColor = [UIColor whiteColor];
    pullToRefreshLabel.textAlignment = NSTextAlignmentCenter;
    pullToRefreshLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11];
    pullToRefreshLabel.center = CGPointMake(self.view.frame.size.width/2, 38);
    [self.navigationController.navigationBar addSubview:pullToRefreshLabel];

}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    // Set controller's title
    self.title = @"Contactos";

    
    // Alloc the Refresh Control =====================
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadnonRegisteredContacts) forControlEvents:UIControlEventValueChanged];
    [_usersTable addSubview:refreshControl];
    
    
    // Alloc Users Arrays ===================
	nonRegisteredContacts = [[NSMutableArray alloc] init];
	registeredContacts = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    // In case the User is already logged in...
    if ([PFUser currentUser] != nil) {
		ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
             if (granted) {
                [self loadnonRegisteredContacts];
             }
          });
		});
        
        
    // ...if not, open the LoginVC
    } else {
        [pullToRefreshLabel removeFromSuperview];
      
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NavigationController *navCont = (NavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        [self presentViewController:navCont animated:true completion:nil];
    }
}




#pragma mark - CLEANUP ==========================
- (void)cleanup {
	[nonRegisteredContacts removeAllObjects];
	[registeredContacts removeAllObjects];
    
	[_usersTable reloadData];
}



#pragma mark - LOAD NON-REGISTERED CONTACTS ======================================
- (void)loadnonRegisteredContacts {
    
	if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
		CFErrorRef *error = NULL;
		ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
		ABRecordRef sourceBook = ABAddressBookCopyDefaultSource(addressBook);
		CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, sourceBook, kABPersonFirstNameProperty);
		CFIndex personCount = CFArrayGetCount(allPeople);

		[nonRegisteredContacts removeAllObjects];
        
		for (int i=0; i < personCount; i++) {
			ABMultiValueRef tmp;
			ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);

			NSString *first = @"";
			tmp = ABRecordCopyValue(person, kABPersonFirstNameProperty);
			if (tmp != nil) first = [NSString stringWithFormat:@"%@", tmp];

			NSString *last = @"";
			tmp = ABRecordCopyValue(person, kABPersonLastNameProperty);
			if (tmp != nil) last = [NSString stringWithFormat:@"%@", tmp];

			NSMutableArray *emails = [[NSMutableArray alloc] init];
			ABMultiValueRef multi1 = ABRecordCopyValue(person, kABPersonEmailProperty);
			for (CFIndex j=0; j<ABMultiValueGetCount(multi1); j++)
			{
				tmp = ABMultiValueCopyValueAtIndex(multi1, j);
				if (tmp != nil) [emails addObject:[NSString stringWithFormat:@"%@", tmp]];
			}

			NSMutableArray *phones = [[NSMutableArray alloc] init];
			ABMultiValueRef multi2 = ABRecordCopyValue(person, kABPersonPhoneProperty);
			for (CFIndex j=0; j<ABMultiValueGetCount(multi2); j++)
			{
				tmp = ABMultiValueCopyValueAtIndex(multi2, j);
				if (tmp != nil) [phones addObject:[NSString stringWithFormat:@"%@", tmp]];
			}

			NSString *name = [NSString stringWithFormat:@"%@ %@", first, last];
			[nonRegisteredContacts addObject:@{@"name":name, @"emails":emails, @"phones":phones}];
		}
		CFRelease(allPeople);
		CFRelease(addressBook);
		[self loadregisteredContacts];
	}
}


#pragma mark - LOAD REGISTERED CONTACTS ======================================
- (void)loadregisteredContacts {
    
	NSMutableArray *emails = [[NSMutableArray alloc] init];
	for (NSDictionary *user in nonRegisteredContacts) {
		for (NSString *email in user[@"emails"]) {
			[emails addObject:email];
		}
	}

    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
	[query whereKey:PF_USER_EMAILCOPY containedIn:emails];
	[query orderByAscending:PF_USER_FULLNAME];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error == nil) {
			[registeredContacts removeAllObjects];
			
            for (PFUser *user in objects) {
				[registeredContacts addObject:user];
				[self removeFromUser1:user[PF_USER_EMAILCOPY]];
			}
			[_usersTable reloadData];
            [refreshControl endRefreshing];

        } else {
        [ProgressHUD showError:@"Network error."];
        [refreshControl endRefreshing];
        }
	}];
}


- (void)removeFromUser1:(NSString *)email_ {
	NSMutableArray *remove = [[NSMutableArray alloc] init];

    for (NSDictionary *user in nonRegisteredContacts) {
		for (NSString *email in user[@"emails"]) {
			if ([email isEqualToString:email_]) {
				[remove addObject:user];
			}
		}
	}
    
    for (NSDictionary *user in remove) {
		[nonRegisteredContacts removeObject:user];
	}
    
}




#pragma mark - TABLE VIEW DELEGATES & DATASOURCE =============================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [registeredContacts count];
    }
    if (section == 1) {
        return [nonRegisteredContacts count];
    }
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ((section == 0) && ([registeredContacts count] != 0)) {
    return @"Contactos registrados";
    }
    
    if ((section == 1) && ([nonRegisteredContacts count] != 0)) {
    return @"Invita a tus amigos";
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    // LOAD REGISTERED USERS ===================
    if (indexPath.section == 0) {
		PFUser *user = registeredContacts[indexPath.row];
		cell.textLabel.text = user[PF_USER_FULLNAME];
        cell.detailTextLabel.text = user[PF_USER_STATUS];
	}
    
    
    // LOAD NON-REGISTERED USERS ===============
	if (indexPath.section == 1) {
		NSDictionary *user = nonRegisteredContacts[indexPath.row];
		NSString *email = [user[@"emails"] firstObject];
		NSString *phone = [user[@"phones"] firstObject];
		cell.textLabel.text = user[@"name"];
		cell.detailTextLabel.text = (email != nil) ? email : phone;
	}

    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
	return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    // REGISTERED USERS ==================
    if (indexPath.section == 0) {
		PFUser *user1 = [PFUser currentUser];
		PFUser *user2 = registeredContacts[indexPath.row];
		NSString *roomId = StartPrivateChat(user1, user2);

        // Remove Refresh Label
        [pullToRefreshLabel removeFromSuperview];
      
        
        // Get the user's Name you're chatting with
        userYouChatWith = user2[PF_USER_FULLNAME];
        NSLog(@"%@", userYouChatWith);
        
        // Init the ChatView
        ChatVC *chatVC = [[ChatVC alloc] initWith:roomId];
		chatVC.hidesBottomBarWhenPushed = true;
		[self.navigationController pushViewController:chatVC animated:true];
	}
    
    
    // NON-REGISTERED USERS ===============
	if (indexPath.section == 1) {
		indexSelected = indexPath;
		[self inviteUser:nonRegisteredContacts[indexPath.row]];
	}
    
}




#pragma mark - INVITE USERS METHOD ===========================

- (void)inviteUser:(NSDictionary *)user {
    
	if (([user[@"emails"] count] != 0) && ([user[@"phones"] count] != 0)) {
		UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar"
			destructiveButtonTitle:nil
            otherButtonTitles:@"Invitar por correo electrónico",
                              @"Invitar por SMS",
                              nil];
		[action showInView:self.view];
        
        
	} else if (([user[@"emails"] count] != 0) && ([user[@"phones"] count] == 0)) {
		[self sendEmailToUser:user];
        
	} else if (([user[@"emails"] count] == 0) && ([user[@"phones"] count] != 0)) {
		[self sendSMS:user];
        
    } else {
        [ProgressHUD showError:@"Este contacto no tiene suficiente información para ser invitado."];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
	NSDictionary *user = nonRegisteredContacts[indexSelected.row];
    if (buttonIndex == 0) {
        [self sendEmailToUser:user];
    } else if (buttonIndex == 1) {
        [self sendSMS:user];
    }
}




#pragma mark - SEND EMAIL TO USER =============================
- (void)sendEmailToUser:(NSDictionary *)user {
    
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
		[mailCompose setToRecipients:user[@"emails"]];
		[mailCompose setSubject:@""];
		[mailCompose setMessageBody:INVITE_FRIENDS_MESSAGE isHTML:YES];
		mailCompose.mailComposeDelegate = self;
		[self presentViewController:mailCompose animated:YES completion:nil];
	}
	else [ProgressHUD showError:@"Por favor, configure su cuenta de correo electrónico."];
}
// MAIL DELEGATE
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	if (result == MFMailComposeResultSent) {
		[ProgressHUD showSuccess:@"¡Email enviado satisfactoriamente!"];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - SMS MESSAGE  ================================
- (void)sendSMS:(NSDictionary *)user {
    
	if ([MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *messageCompose = [[MFMessageComposeViewController alloc] init];
		messageCompose.recipients = user[@"phones"];
		messageCompose.body = INVITE_FRIENDS_MESSAGE;
		messageCompose.messageComposeDelegate = self;
		[self presentViewController:messageCompose animated:YES completion:nil];
	
    } else {
        [ProgressHUD showError:@"El dispositivo no puede enviar mensajes SMS !"];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	if (result == MessageComposeResultSent) {
		[ProgressHUD showSuccess:@"SMS enviado con éxito ."];
	}
	
    [self dismissViewControllerAnimated:YES completion:nil];
}





-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
