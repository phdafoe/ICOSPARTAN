//
//  ICOCalendarioTableViewController.h
//  iCoSpartan
//
//  Created by User on 24/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICOCalendarioTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

//Creamos nuestro array y nuestro diccionario

@property (nonatomic, strong) NSArray *calendarArray;
@property (nonatomic, strong) NSDictionary *calendarDictionary;


@end
