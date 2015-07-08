//
//  ICOSobreNosotrosViewController.h
//  iCoSpartan
//
//  Created by User on 8/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "ICORawScrollView.h"

#import "REFrostedViewController.h"


#define ABOUT_US_EMAIL @"info@icospartan.com"

@interface ICOSobreNosotrosViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet ICORawScrollView *scrollView;

- (IBAction)showMenu:(id)sender;

- (IBAction)sendMessage:(id)sender;



@end
