/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "MBProgressHUD.h"

#import "Configs.h"
#import "ChatCell.h"
#import "Camera.h"
#import "Messages.h"
#import "pushnotification.h"
#import "Utilities.h"

#import "ChatVC.h"
#import "ViewPictureVC.h"


@interface ChatVC() {
    
	NSTimer *timer;
	BOOL isLoading;

	NSString *roomId;

	NSMutableArray *users;
	NSMutableArray *messages;
	NSMutableDictionary *avatars;

	JSQMessagesBubbleImage *bubbleImageOutgoing;
	JSQMessagesBubbleImage *bubbleImageIncoming;
	JSQMessagesAvatarImage *avatarImageBlank;
}
@end




@implementation ChatVC

- (id)initWith:(NSString *)roomId_ {
	self = [super init];
    
	roomId = roomId_;
	return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)viewDidLoad {
	[super viewDidLoad];
    

    // Show the User's Full Name you're chatting with
    self.title = userYouChatWith;

    
    // Alloc all needed arrays
    photosArray = [[NSMutableArray alloc]init];
    
	users = [[NSMutableArray alloc] init];
	messages = [[NSMutableArray alloc] init];
	avatars = [[NSMutableDictionary alloc] init];

    
	PFUser *user = [PFUser currentUser];
	self.senderId = user.objectId;
	self.senderDisplayName = user[PF_USER_FULLNAME];

    
	JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
	bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
	bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];

	avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"chatBlank"] diameter:30.0];

	isLoading = false;
	[self loadMessages];

	ClearMessageCounter(roomId);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.collectionViewLayout.springinessEnabled = true;
    
    // Check for new messages every 5 secs
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:true];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	[timer invalidate];
}




#pragma mark - LOAD ALL MESSAGES OF YOUR LAST CHAT =============================
- (void)loadMessages {
    
	if (isLoading == false) {
		isLoading = true;
		JSQMessage *message_last = [messages lastObject];

		PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
		[query whereKey:PF_CHAT_ROOMID equalTo:roomId];
		if (message_last != nil) [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
		[query includeKey:PF_CHAT_USER];
		[query orderByDescending:PF_CHAT_CREATEDAT];
		[query setLimit:50];
        
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (error == nil) {
				self.automaticallyScrollsToMostRecentMessage = false;
                
				for (PFObject *object in [objects reverseObjectEnumerator]) {
					[self addMessage:object];
				}
                
				if ([objects count] != 0) {
					[self finishReceivingMessage];
					[self scrollToBottomAnimated:false];
				}
				self.automaticallyScrollsToMostRecentMessage = true;
			
            } else [ProgressHUD showError:@"Network error."];
			isLoading = false;
		}];
	}
}



#pragma mark - ADD A MESSAGE A USER SENT YOU =========================
- (void)addMessage:(PFObject *)object {
    
	PFUser *user = object[PF_CHAT_USER];
	[users addObject:user];
    
    // Message with just TEXT ======================================
    if (object[PF_CHAT_PICTURE] == nil) {
		JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[PF_USER_FULLNAME]
        date:object.createdAt text:object[PF_CHAT_TEXT]];
		[messages addObject:message];
	} else
    
    
    
    // Message with PHOTO ======================================
    if (object[PF_CHAT_PICTURE] != nil) {
		JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
		mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
		JSQMessage *message = [[JSQMessage alloc] initWithSenderId: user.objectId
        senderDisplayName:user[PF_USER_FULLNAME] date:object.createdAt media:mediaItem];
		[messages addObject:message];
        
        PFFile *filePicture = object[PF_CHAT_PICTURE];
		[filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
			if (error == nil) {
				mediaItem.image = [UIImage imageWithData:imageData];
                
                // Add the image into a Mutable Array
                [photosArray insertObject:mediaItem.image atIndex:0];
                
				[self.collectionView reloadData];
			}
		}];
	}
    

}



#pragma mark - SEND MESSAGE WITH PICTURE ===============================
- (void)sendMessage:(NSString *)text Picture:(UIImage *)picture {
    
    // Get the picture
	PFFile *imageFile = nil;
    if (picture != nil) {
		imageFile = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
	}
    
    // Prepare it for Parse
    PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
	object[PF_CHAT_USER] = [PFUser currentUser];
	object[PF_CHAT_ROOMID] = roomId;
	object[PF_CHAT_TEXT] = text;
  
    if (imageFile != nil) {
    object[PF_CHAT_PICTURE] = imageFile;
        
    // HUD that shows photo uploading progress
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Sending Photo";
    [hud show:true];
    }
    
    // Save the Parse objects to the database
	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error == nil) {
			[JSQSystemSoundPlayer jsq_playMessageSentSound];
			[self loadMessages];
            [hud hide:true];
            
        // Some network error
        } else {
        [ProgressHUD showError:@"Network error."];
        }
	}];

    
    SendPushNotification(roomId, text);
	UpdateMessageCounter(roomId, text);

    [self finishSendingMessage];
}




#pragma mark - JSQMessagesViewController methods =======================

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
	[self sendMessage:text Picture:nil];

}

- (void)didPressAccessoryButton:(UIButton *)sender {
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
        otherButtonTitles:
                        @"Take a Photo",
                        @"Choose Existing Photo",
                        nil];
	[action showInView:self.view];
}



#pragma mark - JSQMessages CollectionView DataSource ======================

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
	return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
			 messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
	
    JSQMessage *message = messages[indexPath.item];
    
	if ([message.senderId isEqualToString:self.senderId]) {
		return bubbleImageOutgoing;
	}
	return bubbleImageIncoming;
}


- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
					avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
	PFUser *user = users[indexPath.item];
	if (avatars[user.objectId] == nil) {
		PFFile *fileThumbnail = user[PF_USER_THUMBNAIL];
        
		[fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
			if (error == nil) {
				avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:30.0];
				[self.collectionView reloadData];
			}
		}];
		return avatarImageBlank;
        
    } else {
    return avatars[user.objectId];
    }
    
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.item % 3 == 0)
	{
		JSQMessage *message = messages[indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	return nil;
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
	JSQMessage *message = messages[indexPath.item];
	if ([message.senderId isEqualToString:self.senderId])
	{
		return nil;
	}

	if (indexPath.item - 1 > 0)
	{
		JSQMessage *previousMessage = messages[indexPath.item-1];
		if ([previousMessage.senderId isEqualToString:message.senderId])
		{
			return nil;
		}
	}
	return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}




#pragma mark - UICollectionView DataSource ==================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return messages.count;
}


- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	
	JSQMessage *message = messages[indexPath.item];
	if ([message.senderId isEqualToString:self.senderId]) {
		cell.textView.textColor = [UIColor blackColor];
	} else {
		cell.textView.textColor = [UIColor whiteColor];
	}
	return cell;
}



#pragma mark - JSQMessages CollectionView Flow layout delegate ===========================

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.item % 3 == 0) {
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	return 0;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
	JSQMessage *message = messages[indexPath.item];
	if ([message.senderId isEqualToString:self.senderId]) {
		return 0;
	}
	
	if (indexPath.item - 1 > 0) {
		JSQMessage *previousMessage = messages[indexPath.item-1];
        
		if ([previousMessage.senderId isEqualToString:message.senderId]) {
			return 0;
		}
	}
    
	return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
	return 0;
}





#pragma mark - DELEGATES FOR TAPS ON MESSAGES =========================

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
	NSLog(@"Load EarlierMessagesButton tapped!");
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
		   atIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Avatar tapped!");
        
}


// Show the pictures you have collected in a conversation into a ViewController
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewPictureVC *previewVC =[storyboard instantiateViewControllerWithIdentifier:@"ViewPictureVC"];
    [self.navigationController pushViewController: previewVC animated:true];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
	NSLog(@"Cell AtIndexPath %@", NSStringFromCGPoint(touchLocation));
}




#pragma mark - ACTION SHEET DELEGATE ===========================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
      
        switch (buttonIndex) {
            case 0: // Open Photocamera
                OpenCamera(self, true);
                break;
                
            case 1: // Open Photo Library
                OpenPhotoLibrary(self, true);
                break;
            default: break;
        }
    }
}


#pragma mark - IMAGE PICKER DELEGATE ===========================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    UIImage *picture = info[UIImagePickerControllerEditedImage];
	[self sendMessage:@"[Sent you a Photo]" Picture:picture];
    [picker dismissViewControllerAnimated:true completion:nil];
    
}



@end
