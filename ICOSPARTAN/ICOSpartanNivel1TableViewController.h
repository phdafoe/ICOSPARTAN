//
//  ICOSpartanNivel1TableViewController.h
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface ICOSpartanNivel1TableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

//Creamos nuestro array y nuestro diccionario

@property (nonatomic, strong) NSArray *spartanArray;
@property (nonatomic, strong) NSDictionary *spartanDictionary;
- (IBAction)showMenuSpartan:(id)sender;

@end