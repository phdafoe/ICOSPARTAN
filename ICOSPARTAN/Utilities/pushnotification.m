/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>

#import "Configs.h"

#import "pushnotification.h"


void ParsePushUserAssign(void) {
	PFInstallation *installation = [PFInstallation currentInstallation];
	installation[PF_INSTALLATION_USER] = [PFUser currentUser];
    
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error != nil) {
            // Logs the error in the Console
			NSLog(@"ParsePushUserAssign save %@", error);
		}
	}];
}


void ParsePushUserResign(void) {
	PFInstallation *installation = [PFInstallation currentInstallation];
	installation[PF_INSTALLATION_USER] = [NSNull null];
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
		if (error != nil) {
		// Logs the error in the Console
        NSLog(@"ParsePushUserResign save %@", error);
		}
	}];
}




#pragma mark - SEND PUSH NOTIFICATION =============================
void SendPushNotification(NSString *roomId, NSString *text) {
    
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query whereKey:PF_MESSAGES_USER notEqualTo:[PFUser currentUser]];
	[query includeKey:PF_MESSAGES_USER];
	[query setLimit:1000];

	PFQuery *queryInstallation = [PFInstallation query];
	[queryInstallation whereKey:PF_INSTALLATION_USER
                       matchesKey:PF_MESSAGES_USER inQuery:query];

	PFPush *push = [[PFPush alloc] init];
	[push setQuery:queryInstallation];
	[push setMessage:text];
	[push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
		if (error != nil) {
		//Logs the error in the Console
        NSLog(@"SendPushNotification send %@", error);
		}
	}];
}
