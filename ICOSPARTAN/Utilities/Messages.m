/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/



#import <Parse/Parse.h>

#import "Configs.h"
#import "Messages.h"
#import "ChatsVC.h"



# pragma mark - MANAGE PRIVATE CHAT ===========================
NSString* StartPrivateChat(PFUser *user1, PFUser *user2) {
    
	NSString *id1 = user1.objectId;
	NSString *id2 = user2.objectId;

    NSString *roomId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];

    CreateMessageItem(user1, roomId, user2[PF_USER_FULLNAME]);
	CreateMessageItem(user2, roomId, user1[PF_USER_FULLNAME]);

    
    return roomId;
}



# pragma mark - MANAGE GROUP CHAT ===========================
NSString* StartMultipleChat(NSMutableArray *users) {
    NSString *groupId = @"";
    NSString *description = @"";
    
    NSMutableArray *userIds = [[NSMutableArray alloc] init];
    
    for (PFUser *user in users){
        [userIds addObject:user.objectId];
    }
    
    NSArray *sorted = [userIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *userId in sorted){
        groupId = [groupId stringByAppendingString:userId];
    }
    
    for (PFUser *user in users){
        if ([description length] != 0) description = [description stringByAppendingString:@" & "];
        description = [description stringByAppendingString:user[PF_USER_FULLNAME]];
    }
    
    for (PFUser *user in users){
        CreateMessageItem(user, groupId, description);
    }
    return groupId;
}




void CreateMessageItem(PFUser *user, NSString *roomId, NSString *description) {
    
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_USER equalTo:user];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			if ([objects count] == 0)
			{
				PFObject *message = [PFObject objectWithClassName:PF_MESSAGES_CLASS_NAME];
				message[PF_MESSAGES_USER] = user;
				message[PF_MESSAGES_ROOMID] = roomId;
				message[PF_MESSAGES_DESCRIPTION] = description;
				message[PF_MESSAGES_LASTUSER] = [PFUser currentUser];
				message[PF_MESSAGES_LASTMESSAGE] = @"";
				message[PF_MESSAGES_COUNTER] = @0;
				message[PF_MESSAGES_UPDATEDACTION] = [NSDate date];
				[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"CreateMessageItem save error.");
				}];
			}
		}
		else NSLog(@"CreateMessageItem query error.");
	}];
}


void DeleteMessageItem(PFObject *message) {
	[message deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error != nil) NSLog(@"DeleteMessageItem delete error.");
	}];
}


void UpdateMessageCounter(NSString *roomId, NSString *lastMessage) {
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error == nil) {
			for (PFObject *message in objects) {
				PFUser *user = message[PF_MESSAGES_USER];
				if ([user.objectId isEqualToString:[PFUser currentUser].objectId] == NO)
					[message incrementKey:PF_MESSAGES_COUNTER byAmount:@1];

                message[PF_MESSAGES_LASTUSER] = [PFUser currentUser];
				message[PF_MESSAGES_LASTMESSAGE] = lastMessage;
				message[PF_MESSAGES_UPDATEDACTION] = [NSDate date];

                [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					if (error != nil) NSLog(@"UpdateMessageCounter save error.");
				}];
			}
		}
		else NSLog(@"UpdateMessageCounter query error.");
	}];
}

void ClearMessageCounter(NSString *roomId) {
    
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query whereKey:PF_MESSAGES_USER equalTo:[PFUser currentUser]];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *message in objects)
			{
				message[PF_MESSAGES_COUNTER] = @0;
				[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"ClearMessageCounter save error.");
				}];
			}
		} else NSLog(@"ClearMessageCounter query error.");
	}];
}
