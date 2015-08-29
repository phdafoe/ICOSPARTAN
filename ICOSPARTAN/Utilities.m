/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/


#import "Utilities.h"
#import "WelcomeVC.h"
#import "ICONavigationViewController.h"


void LoginUser(id target) {

    UINavigationController *navCont = [[UINavigationController alloc]
    initWithRootViewController:[[WelcomeVC alloc] init]];
    [target presentViewController:navCont animated:true completion:nil];
}

 

UIImage* ResizeImage(UIImage *image, CGFloat width, CGFloat height) {
	CGSize size = CGSizeMake(width, height);
	UIGraphicsBeginImageContextWithOptions(size, false, 0);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}


void PostNotification(NSString *notification) {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}


NSString* TimeElapsed(NSTimeInterval seconds) {
    
	NSString *elapsed;
	if (seconds < 60)
	{
		elapsed = @"Just now";
	}
	else if (seconds < 60 * 60)
	{
		int minutes = (int) (seconds / 60);
		elapsed = [NSString stringWithFormat:@"%d %@", minutes, (minutes > 1) ? @"mins" : @"min"];
	}
	else if (seconds < 24 * 60 * 60)
	{
		int hours = (int) (seconds / (60 * 60));
		elapsed = [NSString stringWithFormat:@"%d %@", hours, (hours > 1) ? @"hours" : @"hour"];
	}
	else
	{
		int days = (int) (seconds / (24 * 60 * 60));
		elapsed = [NSString stringWithFormat:@"%d %@", days, (days > 1) ? @"days" : @"day"];
	}
	return elapsed;
}
