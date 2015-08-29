/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import "AppDelegate.h"
#import "JSQMessages.h"
#import "MBProgressHUD.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>


NSMutableArray *photosArray;

PFObject *message;

MBProgressHUD *hud;


@interface ChatVC : JSQMessagesViewController
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>


- (id)initWith:(NSString *)roomId_;

@end
