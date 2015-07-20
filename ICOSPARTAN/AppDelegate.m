//
//  AppDelegate.m
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "AppDelegate.h"

#import "Appirater.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if(notification){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venga Vamos a Entrenar!!"
                                                        message:notification.alertBody
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }

    return YES;
}

-(void) application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venga Vamos a Entrenar!!"
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







@end
