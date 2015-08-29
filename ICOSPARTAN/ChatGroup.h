
/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/

#import <UIKit/UIKit.h>

int reloadCount;
NSTimer *reloadTimer;

BOOL chatGroupVisible;


// Delegate Protocol
@protocol ChatGroupDelegate
- (void)didSelectMultipleUsers:(NSMutableArray *)users;
@end


@interface ChatGroup : UITableViewController

@property (nonatomic, assign) IBOutlet id<ChatGroupDelegate>delegate;

@end


