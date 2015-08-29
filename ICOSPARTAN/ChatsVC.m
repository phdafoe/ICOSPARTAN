/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Configs.h"
#import "Messages.h"
#import "Utilities.h"

#import "ChatsVC.h"
#import "ChatCell.h"
#import "ChatVC.h"

#import "WelcomeVC.h"
#import "ICONavigationViewController.h"

@interface ChatsVC()
{
	NSMutableArray *messages;
	UIRefreshControl *refreshControl;
}
@end


@implementation ChatsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]; {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
	}
	return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    // Set controller's Title
    self.title = @"Chats";
	
    // Alloc the Messages TableView
    [_messagesTable registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];
	_messagesTable.tableFooterView = [[UIView alloc] init];

    
    // Alloc Refresh Control
    refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(loadMessages) forControlEvents:UIControlEventValueChanged];
	[_messagesTable addSubview:refreshControl];

    
    // Init the messaghes MutableArray
    messages = [[NSMutableArray alloc] init];

    
    // Hide the empty View
    _emptyView.hidden = true;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if ([PFUser currentUser] != nil) {
		[self loadMessages];
        
    } else {
        WelcomeVC *welcomeVC =[self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        [self.navigationController pushViewController: welcomeVC animated:true];
    }
}



#pragma mark - LOAD MESSAGES ==============================
- (void)loadMessages {
    
	if ([PFUser currentUser] != nil) {
		PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
		[query whereKey:PF_MESSAGES_USER equalTo:[PFUser currentUser]];
		[query includeKey:PF_MESSAGES_LASTUSER];
		[query orderByDescending:PF_MESSAGES_UPDATEDACTION];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
		{
			if (error == nil) {
				[messages removeAllObjects];
				[messages addObjectsFromArray:objects];
				[_messagesTable reloadData];
                
				[self updateEmptyView];
				[self updateTabCounter];
			} else [ProgressHUD showError:@"Network error."];
			[refreshControl endRefreshing];
		}];
	}
}



#pragma mark - UPDATE METHODS ================
- (void)updateEmptyView {
	_emptyView.hidden = ([messages count] != 0);
}

- (void)updateTabCounter {
	int total = 0;
	for (PFObject *message in messages) {
		total += [message[PF_MESSAGES_COUNTER] intValue];
	}
    // Set Badge for Chats Tab
	UITabBarItem *item = self.tabBarController.tabBar.items[1];
	item.badgeValue = (total == 0) ? nil : [NSString stringWithFormat:@"%d", total];
}



#pragma mark - CLEANUP ======================================
- (void)cleanup {
	[messages removeAllObjects];
	[_messagesTable reloadData];

    UITabBarItem *item = self.tabBarController.tabBar.items[1];
	item.badgeValue = nil;
}




#pragma mark - MAKE A GROUP OF FRIENDS TO CHAT WITH AT THE SAME TIME ============
- (void)actionChat:(NSString *)groupId {
    ChatVC *chatVC = [[ChatVC alloc] initWith:groupId];
    chatVC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chatVC animated:true];
}


- (IBAction)makeGroupButt:(id)sender {
    // Show the ChatGroup Controller
    ChatGroup *chatGroupVC = [[ChatGroup alloc] init];
    chatGroupVC.delegate = self;

    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:chatGroupVC];
    [self presentViewController:navController animated:true completion:nil];
    
}



#pragma mark - SelectMultipleUsers Delegate ======================
- (void)didSelectMultipleUsers:(NSMutableArray *)users {
    groupId = StartMultipleChat(users);
    [self actionChat:groupId];
}





#pragma mark - TABLE VIEW DELEGATES =================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
	[cell bindData:messages[indexPath.row]];
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	DeleteMessageItem(messages[indexPath.row]);
	[messages removeObjectAtIndex:indexPath.row];
	[_messagesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
	[self updateEmptyView];
	[self updateTabCounter];
}


#pragma mark - SELECT CHAT ========================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView deselectRowAtIndexPath:indexPath animated:true];

    PFObject *message = messages[indexPath.row];
    
    // Get the user's Name you're chatting with
    userYouChatWith = message[PF_MESSAGES_DESCRIPTION];
        
    ChatVC *chatVC = [[ChatVC alloc] initWith:message[PF_MESSAGES_ROOMID]];
    chatVC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chatVC animated:true];
}


@end
