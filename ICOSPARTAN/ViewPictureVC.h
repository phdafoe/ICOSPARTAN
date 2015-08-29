/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Configs.h"
#import "Utilities.h"

#import "ChatVC.h"


@interface ViewPictureVC : UIViewController
<
UIScrollViewDelegate
>

// Views
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end
