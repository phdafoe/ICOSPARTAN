/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>

NSString *userYouChatWith;


@interface ChatCell : UITableViewCell

- (void)bindData:(PFObject *)message_;

@end
