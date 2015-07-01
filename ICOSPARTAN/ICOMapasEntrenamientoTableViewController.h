//
//  ICOMapasEntrenamientoTableViewController.h
//  iCoSpartan
//
//  Created by User on 1/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICOMapasEntrenamientoTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *mapasArray;
@property (nonatomic, strong) NSDictionary *mapasDictionary;

@end
