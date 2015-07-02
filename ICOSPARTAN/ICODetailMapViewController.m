//
//  ICODetailMapViewController.m
//  iCoSpartan
//
//  Created by User on 2/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICODetailMapViewController.h"

@interface ICODetailMapViewController ()

@end

@implementation ICODetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.nameMapParkTrainer;
    
    self.mapOfParkTrainerImageView.image = self.imageMapPark;
    self.descriptionMapOfParkTrainer.text = self.descriptionMapParkTrainer;
    self.nameCityPark.text = self.nameCityMapParkTrainer;
    
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

@end
