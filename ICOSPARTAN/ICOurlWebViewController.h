//
//  ICOurlWebViewController.h
//  iCoSpartan
//
//  Created by User on 28/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICOurlWebViewController : UIViewController <UIWebViewDelegate>

//Modelo de datos

@property NSString *urlWeb;
@property NSString *data;


@property (weak, nonatomic) IBOutlet UIWebView *showUrlWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *showConnectionWithUrlWebActivityIndicator;
@end
