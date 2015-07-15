//
//  ICOEntrenamientosTableViewController.m
//  iCoSpartan
//
//  Created by User on 16/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOEntrenamientosTableViewController.h"

@interface ICOEntrenamientosTableViewController ()

@end

@implementation ICOEntrenamientosTableViewController

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

- (IBAction)showMenuSpartano:(id)sender {
    
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}



@end
