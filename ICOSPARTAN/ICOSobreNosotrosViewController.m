//
//  ICOSobreNosotrosViewController.m
//  iCoSpartan
//
//  Created by User on 8/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOSobreNosotrosViewController.h"

@interface ICOSobreNosotrosViewController ()

@end

@implementation ICOSobreNosotrosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showMenu:(id)sender {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


#pragma mark - MailCompose

- (IBAction)sendMessage:(id)sender {
    
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@"iCoSpartan App"];
        NSArray *toRecipient = [NSArray arrayWithObject:@"info@icospartan.com"];
        NSArray *ccRecipient = [NSArray arrayWithObject:@""];
        NSArray *bccRecipient = [NSArray arrayWithObject:@""];
        
        [mailComposer setToRecipients:toRecipient];
        [mailComposer setCcRecipients:ccRecipient];
        [mailComposer setBccRecipients:bccRecipient];
        
        UIImage *myImage = [UIImage imageNamed:@"iconApp80x80.png"];
        NSData *imageData = UIImageJPEGRepresentation(myImage, 50);
    
        [mailComposer addAttachmentData:imageData
                           mimeType:@"IMAGES"
                           fileName:@"iconApp80x80.png"];
    
        NSString *emailBody = @"";
    
        [mailComposer setMessageBody:emailBody isHTML:NO];
        
        if (mailComposer != nil) {
            [self presentViewController:mailComposer animated:YES completion:nil];
            
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENCIÓN"
                                                        message:@"TU DISPOSITIVO NO SOPORTA EL COMPONENTE PARA ENVIAR MAIL"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK!"
                                              otherButtonTitles:nil];
        [alert show];
}
    
}
@end
