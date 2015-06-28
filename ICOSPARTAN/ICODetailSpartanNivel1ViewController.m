//
//  ICODetailSpartanNivel1ViewController.m
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICODetailSpartanNivel1ViewController.h"

@interface ICODetailSpartanNivel1ViewController ()

@end

@implementation ICODetailSpartanNivel1ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleLabel;
    
    // Do any additional setup after loading the view.
    
    
    self.nameTitleLabel.text = self.titleLabel;
    self.descriptionSpartanLabel.text = self.descriptionLabel;
    self.imageSpartanView.image = self.imageView1;
    self.imageSpartanView2.image = self.imageView2;
    
    [self.descriptionSpartanLabel setNumberOfLines:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
