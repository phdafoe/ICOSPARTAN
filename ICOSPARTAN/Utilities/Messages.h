/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>

NSString *StartPrivateChat (PFUser *user1, PFUser *user2);
NSString *StartMultipleChat	(NSMutableArray *users);


void CreateMessageItem	(PFUser *user, NSString *roomId, NSString *description);
void DeleteMessageItem (PFObject *message);

void UpdateMessageCounter (NSString *roomId, NSString *lastMessage);
void ClearMessageCounter (NSString *roomId);
