//
//  ICOurlWebViewController.m
//  iCoSpartan
//
//  Created by User on 28/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOurlWebViewController.h"

@interface ICOurlWebViewController ()

@end

@implementation ICOurlWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.data;
    
    [self.showConnectionWithUrlWebActivityIndicator startAnimating];
    
    NSString *completeUrlString = [NSString stringWithFormat:@"%@", self.urlWeb];
    NSURL *completeURl = [NSURL URLWithString:completeUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:completeURl];
    [self.showUrlWebView loadRequest:request];
    
    //[self.urlWeb loadRequest:[NSURLRequest requestWithURL:completeURl]];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.showConnectionWithUrlWebActivityIndicator stopAnimating];
    [self.showConnectionWithUrlWebActivityIndicator setHidden:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
