/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import <AddressBook/AddressBook.h>

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "Messages.h"
#import "Utilities.h"

#import "ChatGroup.h"
#import "ChatsVC.h"

#import "ICONavigationViewController.h"


@interface ChatGroup() {
	//NSMutableArray *users;
	NSMutableArray *selection;
    
    NSMutableArray *nonRegisteredContacts;
    NSMutableArray *registeredContacts;
    NSIndexPath *indexSelected;

    UIRefreshControl *refreshControl;

}
@end



@implementation ChatGroup

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
        
        chatGroupVisible = true;
    }
    return self;
}

- (void)cleanup {
    
    [nonRegisteredContacts removeAllObjects];
    [registeredContacts removeAllObjects];
    
    [self.tableView reloadData];
}




#pragma mark - VIEW DID LOAD ===============
- (void)viewDidLoad {
	[super viewDidLoad];
    
    // Set navBar title
	self.title = @"Add Contacts to Group";

    reloadCount = 0;
    
    
    // Alloc the Refresh controller
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadNONregisteredContacts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
        

    // Add buttons to the Navigation Bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:82.0/255.0 green:220.0/255.0 blue:137.0/255.0 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(donePressed)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor  colorWithRed:82.0/255.0 green:220.0/255.0 blue:137.0/255.0 alpha:1.0];
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    nonRegisteredContacts = [[NSMutableArray alloc] init];

    
    registeredContacts = [[NSMutableArray alloc] init];
    selection = [[NSMutableArray alloc] init];

}

- (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        
    // User is already logged in
    if ([PFUser currentUser] != nil) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) [self loadNONregisteredContacts];
            });
        });
    }
}

- (void)loadNONregisteredContacts {
        
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
    
# pragma mark - LOAD REGISTERED CONTACTS ================================
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil) {
             [registeredContacts removeAllObjects];
             
             for (PFUser *user in objects) {
                 [registeredContacts addObject:user];
                 [self removeFromUser1:user[PF_USER_EMAILCOPY]];
             }
             [self.tableView reloadData];
             [refreshControl endRefreshing];
             
         } else {
             [ProgressHUD showError:@"No Contacts!"];
             [refreshControl endRefreshing];
         }
     }];
    
    
      reloadTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(reloadTableData) userInfo:nil repeats:true];
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


-(void)reloadTableData {
    reloadCount++;
    
    [self.tableView reloadData];
    
    if (reloadCount >= 5) {
        [reloadTimer invalidate];
    }
   
}

#pragma mark - User actions

- (void)cancelPressed {
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void)donePressed {
	if ([selection count] == 0) {
        [ProgressHUD showError:@"No contact selected."]; return;
    }

    
    [self dismissViewControllerAnimated:true completion:^{
		if (delegate != nil) {
			NSMutableArray *selectedUsers = [[NSMutableArray alloc] init];
            
			for (PFUser *user in registeredContacts) {
				if ([selection containsObject:user.objectId])
					[selectedUsers addObject:user];
                }            
			[selectedUsers addObject:[PFUser currentUser]];
			[delegate didSelectMultipleUsers:selectedUsers];
            
            chatGroupVisible = false;
		}
	}];
}



#pragma mark - TABLE VIEW DELEGATES & DATASOURCE ================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return registeredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    // Get Contacts Names and Profile Picture ===============
	PFUser *user = registeredContacts[indexPath.row];
	cell.textLabel.text = user[PF_USER_FULLNAME];
    cell.detailTextLabel.text = user[PF_USER_STATUS];

    PFFile *userImage = user[PF_USER_PICTURE];
    if (userImage != nil) {
        [userImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if (!error) {
                cell.imageView.image = [UIImage imageWithData:data];   }
        }];
    }
    
    // Cell's layout
    cell.imageView.clipsToBounds = true;
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    
    //=================================================
    
    
	BOOL selected = [selection containsObject:user.objectId];
	cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    PFUser *user = registeredContacts[indexPath.row];
    
	BOOL selected = [selection containsObject:user.objectId];
	if (selected) [selection removeObject:user.objectId];
    else [selection addObject:user.objectId];

    [self.tableView reloadData];
}



@end
