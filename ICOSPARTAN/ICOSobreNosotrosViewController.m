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
    
    
    
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        //personalizacion de la barra de navegacion superior
        NSShadow *shadow = [[NSShadow alloc]init];
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
        
        mailComposer.mailComposeDelegate = self;
        
        
        [mailComposer.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                               NSShadowAttributeName: shadow}];
        
        [mailComposer.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_menu_bg@2x.png"] forBarMetrics:UIBarMetricsDefault];
        
        [mailComposer setSubject:@"iCoSpartan"];
        
        NSArray *toRecipient = @[@"info@icospartan.com"];
        [mailComposer setToRecipients:toRecipient];
        
        UIImage *myImage = [UIImage imageNamed:@"iconApp80x80.png"];
        NSData *imageData = UIImageJPEGRepresentation(myImage, 50);
        
        [mailComposer addAttachmentData:imageData
                               mimeType:@"IMAGES"
                               fileName:@"iconApp80x80.png"];
        
        NSString *emailBody = @"Ya tienes iCoSpartan App?";
        [mailComposer setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENCIÓN"
                                                        message:@"TU DISPOSITIVO NO SOPORTA EL COMPONENTE DE ENVIAR MAIL"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK!"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelado: Haz cancelado la operación y el no envío del mail que haz solicitado");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail salvado: Haz salvado el mail in la carpeta de borradores");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail enviado: el mail que haz enviado esta en la carpeta de salida, esta preparado para salir");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail fallido: ha ocurrido un error en el envio del mail, existe un posible error");
            break;
            
        default:
            NSLog(@"Mail no enviado");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
