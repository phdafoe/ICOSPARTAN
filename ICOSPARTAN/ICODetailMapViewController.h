//
//  ICODetailMapViewController.h
//  iCoSpartan
//
//  Created by User on 2/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICODetailMapViewController : UIViewController

//model
@property NSString *nameMapParkTrainer;
@property NSString *descriptionMapParkTrainer;
@property UIImage *imageMapPark;
@property NSString *nameCityMapParkTrainer;

@property (weak, nonatomic) IBOutlet UIImageView *mapOfParkTrainerImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionMapOfParkTrainer;
@property (weak, nonatomic) IBOutlet UILabel *nameCityPark;

@end
