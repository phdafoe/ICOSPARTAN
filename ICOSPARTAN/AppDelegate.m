//
//  AppDelegate.m
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "AppDelegate.h"

#import "Appirater.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "Configs.h"
#import "Utilities.h"

#import "ContactsVC.h"
#import "ChatVC.h"
#import "ProfileVC.h"

/*#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>*/



@interface AppDelegate ()

@end

@implementation AppDelegate


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#pragma mark - utils

-(UIStoryboard *)customStoryboard{
    
    UIStoryboard *storyboard;
    
    //Condicion de que tipo de tamaño escogemos
    if (IS_IPHONE_4_OR_LESS) {
        storyboard = [UIStoryboard storyboardWithName:@"Main-3.5" bundle:nil];
        NSLog(@"Dispositivo a sido un 4 inch de pantalla iPhone 4S");
    }else if (IS_IPHONE_5){
        storyboard = [UIStoryboard storyboardWithName:@"Main-4" bundle:nil];
        NSLog(@"Dispositivo a sido un 3.5 inch de pantalla iPhone 5");
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"Main-4.7" bundle:nil];
        NSLog(@"Dispositivo a sido un 4.7 inch de pantalla iPhone 6");
    }
    
    return storyboard;
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    UIStoryboard * storyboard = [self customStoryboard];
    //Muestra el Storyboard
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    
    //Configurar el aspecto de la Barra de NAvegacion
    [self customizeNavigationBar];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.window.frame.size.width, 20)];
    view.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
    [self.window.rootViewController.view addSubview:view];
    
    //Para valorar la App
    [Appirater setAppId:@"1007362230"];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    
    [Appirater setCustomAlertTitle:@"Valorar"];
    [Appirater setCustomAlertMessage:@"Si te gusta la App, te importaría valorarla? no te llevará más de un minuto. Gracias!! por tu colaboración"];
    [Appirater setCustomAlertRateButtonTitle:@"Valorar"];
    [Appirater setCustomAlertRateLaterButtonTitle:@"Recordar más tarde"];
    [Appirater setCustomAlertCancelButtonTitle:@"No Gracias!!"];
    
    [Appirater appLaunched:YES];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    if(notification){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venga Vamos con iCoSpartan!!"
                                                        message:notification.alertBody
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    /*return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];*/
    
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    // Init FB utilities from Parse
    //[PFFacebookUtils initializeFacebook];
    
    // Register for Push Notifications (within the device)
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (
                                                        UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    
    [PFImageView class];
    
    

    
    

    return YES;
}

-(void) application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venga Vamos a iCoSpartan!!"
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [Appirater appEnteredForeground:YES];
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
   //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    //[FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)customizeNavigationBar{
    
    //personalizacion de la barra de navegacion superior
    NSShadow *shadow = [[NSShadow alloc]init];
    
    [shadow setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [shadow setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName: shadow}];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_menu_bg@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    //personalizacion de la Barra ionferior de navegacion tabBar Controller
    //[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_menu_bg@2x.png"]];
   
}





/*#pragma mark - FACEBOOK RESPOSNSES =====================
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}*/



#pragma mark - PUSH NOTIFICATIONS (WITH PARSE) =======================
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self performSelector:@selector(refreshMessagesView) withObject:nil afterDelay:4.0];
    [PFPush handlePush:userInfo];
}


// Refresh messages at app startup
- (void)refreshMessagesView {
    [_messages loadMessages];
}





@end
