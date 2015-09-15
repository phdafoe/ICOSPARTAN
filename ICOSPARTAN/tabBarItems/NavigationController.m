/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import "Configs.h"
#import "NavigationController.h"

int reloadCount;
NSTimer *reloadTimer;

BOOL chatGroupVisible;

@implementation NavigationController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationBar.tintColor = [UIColor whiteColor];
    if (!chatGroupVisible) {
      self.navigationBar.hidden = true;
    } else {
      self.navigationBar.hidden = false;
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

@end
