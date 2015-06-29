//
//  ICOCalendarioTableViewController.m
//  iCoSpartan
//
//  Created by User on 24/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOCalendarioTableViewController.h"
#import "CustomCell1.h"

#import "ICOurlWebViewController.h"

@interface ICOCalendarioTableViewController ()

@end

@implementation ICOCalendarioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calendario" ofType:@"plist"];
    
    self.calendarArray = [NSArray arrayWithContentsOfFile:path];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.calendarArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];*/
    
    CustomCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    self.calendarDictionary = [self.calendarArray objectAtIndex:indexPath.row];
    
    NSString *title = self.calendarDictionary [@"title"];
    NSString *description = self.calendarDictionary [@"description"];
    NSString *city = self.calendarDictionary [@"city"];
    
    NSString *cityImageName = self.calendarDictionary [@"cityImageName"];
    
    //NSString *urlWeb = self.calendarDictionary [@"urlWeb"];
    
    UIImage *image = [UIImage imageNamed:cityImageName];
    
    // Configure the cell...
    
    cell.nameObstacleWarriors.text = title;
    cell.dateObstacleWarriors.text = description;
    cell.cityObstacleWarriors.text = city;
    cell.imageCityObstacleWarriors.image = image;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Creamos la clase
    ICOurlWebViewController *detailCalendar = [self.storyboard instantiateViewControllerWithIdentifier:@"detailUrlWeb"];
    
    [self.navigationController pushViewController:detailCalendar animated:YES];
    
    self.calendarDictionary = [self.calendarArray objectAtIndex:indexPath.row];
    NSString *title = self.calendarDictionary [@"title"];
    NSString *urlWeb = self.calendarDictionary [@"urlWeb"];
    
    detailCalendar.data = title;
    detailCalendar.urlWeb = urlWeb;
    
    NSLog(@"Esta siendo seleccioando %@", [self.calendarArray objectAtIndex:indexPath.row]);
    
}

- (IBAction)showMenuSpartan:(id)sender {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
    
    
}
@end
