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





@interface ChatVC : JSQMessagesViewController
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>


- (instancetype)initWith:(NSString *)roomId_ NS_DESIGNATED_INITIALIZER;

@end
