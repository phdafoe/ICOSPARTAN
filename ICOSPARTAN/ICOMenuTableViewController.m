//
//  ICOMenuTableViewController.m
//  iCoSpartan
//
//  Created by User on 29/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOMenuTableViewController.h"

#import "ICOGaleriaViewController.h"
#import "ICOSpartanNivel1TableViewController.h"
#import "ICOSpartanNivel2TableViewController.h"
#import "ICOSpartanNivel3TableViewController.h"
#import "ICOSpartanNivel4TableViewController.h"
#import "ICOCalendarioTableViewController.h"
#import "ICOConsejosViewController.h"

#import "ICONavigationViewController.h"

#import "UIViewController+REFrostedViewController.h"

@interface ICOMenuTableViewController ()

@end

@implementation ICOMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"iCoSpartan";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 24;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ICONavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        ICOGaleriaViewController *galeriaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
        navigationController.viewControllers = @[galeriaViewController];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        ICOSpartanNivel1TableViewController *spartanNivel1ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"primerController"];
        navigationController.viewControllers = @[spartanNivel1ViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        
        ICOSpartanNivel2TableViewController *spartanNivel2ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segundoController"];
        navigationController.viewControllers = @[spartanNivel2ViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        
        ICOSpartanNivel3TableViewController *spartanNivel3ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tercerController"];
        navigationController.viewControllers = @[spartanNivel3ViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 4) {
        
        ICOSpartanNivel4TableViewController *spartanNivel4ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cuartoController"];
        navigationController.viewControllers = @[spartanNivel4ViewController];
    }else if (indexPath.section == 0 && indexPath.row == 5) {
        
        ICOCalendarioTableViewController *CalendarioTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"quintoController"];
        navigationController.viewControllers = @[CalendarioTableViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 6) {
        
        ICOConsejosViewController *ConsejosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sextoController"];
        navigationController.viewControllers = @[ConsejosViewController];
    }
    
    self.frostedViewController.contentViewController = navigationController;
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Home", @"Tabla Nivel 1", @"Tabla Nivel 2", @"Tabla Nivel 3", @"Tabla Nivel 4", @"Calendario", @"Consejos"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

@end
