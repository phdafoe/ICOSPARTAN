/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
===============================*/



#import "ChatWallpapersVC.h"
#import "Settings.h"
#import "Utilities.h"





@interface ChatWallpapersVC ()



@end

@implementation ChatWallpapersVC


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Wallpapers";
    
    
    _wallpScrollView.contentSize = CGSizeMake(_wallpScrollView.frame.size.width, 150*3);
    
}



#pragma mark - WALLPAPERS BUTTONS ================================

- (IBAction)wallpButt:(id)sender {

    wallpName = [NSString stringWithFormat:@"w%ld", (long)[sender tag]];
    // Save the wallpaper Name
    [[NSUserDefaults standardUserDefaults] setObject:wallpName forKey:@"wallpName"];
    
    // Go back to Settings
    Settings *settingsVC =[self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController: settingsVC animated:true];
    
    NSLog(@"%@", wallpName);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
