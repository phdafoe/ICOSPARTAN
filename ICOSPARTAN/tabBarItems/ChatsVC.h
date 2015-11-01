
/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import "ChatGroup.h"
#import "REFrostedViewController.h"




@interface ChatsVC : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
ChatGroupDelegate
>

// Views
@property (weak, nonatomic) IBOutlet UITableView *messagesTable;
@property (weak, nonatomic) IBOutlet UIView *emptyView;


// Publis method to load Messages
- (void)loadMessages;

- (IBAction)showMenuSpartano:(id)sender;

@end