/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "Configs.h"
#import "Utilities.h"

#import "ChatCell.h"
#import "ChatsVC.h"




@interface ChatCell() {
	PFObject *message;
    NSString *userYouChatWith;

}

@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelElapsed;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end




@implementation ChatCell

@synthesize imageUser;
@synthesize labelDescription, labelLastMessage;
@synthesize labelElapsed, labelCounter;


- (void)bindData:(PFObject *)message_ {
    
	message = message_;

    imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
	imageUser.layer.masksToBounds = true;

    PFUser *lastUser = message[PF_MESSAGES_LASTUSER];
	[imageUser setFile:lastUser[PF_USER_PICTURE]];
	[imageUser loadInBackground];

    labelDescription.text = message[PF_MESSAGES_DESCRIPTION];
	labelLastMessage.text = message[PF_MESSAGES_LASTMESSAGE];

    
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:message.updatedAt];
	labelElapsed.text = TimeElapsed(seconds);

    int counter = [message[PF_MESSAGES_COUNTER] intValue];
	labelCounter.text = (counter == 0) ? @"" : [NSString stringWithFormat:@"%d new", counter];
}


@end
