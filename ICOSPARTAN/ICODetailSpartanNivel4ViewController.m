//
//  ICODetailSpartanNivel4ViewController.m
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICODetailSpartanNivel4ViewController.h"

@interface ICODetailSpartanNivel4ViewController ()

@end

@implementation ICODetailSpartanNivel4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleLabel;
    
    // Do any additional setup after loading the view.
    
    
    self.nameTitleLabel.text = self.titleLabel;
    self.descriptionSpartanLabel.text = self.descriptionLabel;
    self.imageSpartanView.image = self.imageView;
    self.imageSpartanView2.image = self.imageView2;
    
    
    [self.descriptionSpartanLabel setNumberOfLines:0];
    
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

@end
