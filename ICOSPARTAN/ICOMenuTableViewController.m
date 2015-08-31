//
//  ICOMenuTableViewController.m
//  iCoSpartan
//
//  Created by User on 29/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOMenuTableViewController.h"
#import "ICOGaleriaViewController.h"
#import "ICOEntrenamientosTableViewController.h"
#import "ICOMusicPlayer.h"
#import "ICOCalendarioTableViewController.h"
#import "ICOConsejosViewController.h"
#import "ICOSobreNosotrosViewController.h"



#import "ICONavigationViewController.h"


#import "UIViewController+REFrostedViewController.h"

@interface ICOMenuTableViewController ()

@end

@implementation ICOMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // debe de activarse dentro de 3600 segundos = 1 Hora y asi en adelante
    
    notification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:7200];
    // mensaje que saldrá en la alerta
    notification.alertBody = @"Entrénate con iCoSpartan";
    // sonido por defecto
    notification.soundName = UILocalNotificationDefaultSoundName;
    // título del botón
    notification.alertAction = @"OK!";
    notification.hasAction = YES;
    // activa la notificación
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
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
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
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
    ICONavigationViewController *navigationController = [self.storyboard
                                                         instantiateViewControllerWithIdentifier:@"contentController"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        ICOGaleriaViewController *galeriaViewController = [self.storyboard
                                                           instantiateViewControllerWithIdentifier:@"homeController"];
        
        navigationController.viewControllers = @[galeriaViewController];
        
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        ICOEntrenamientosTableViewController *spartanEntrenamientosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"entrenamientos"];
        
        navigationController.viewControllers = @[spartanEntrenamientosViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        
        ICOMusicPlayer *musicPayerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"octavoController"];
        navigationController.viewControllers = @[musicPayerViewController];
        
    }/*else if (indexPath.section == 0 && indexPath.row == 3) {
        
        ICOSpartanNivel3TableViewController *spartanNivel3ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tercerController"];
        navigationController.viewControllers = @[spartanNivel3ViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 4) {
        
        ICOSpartanNivel4TableViewController *spartanNivel4ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cuartoController"];
        navigationController.viewControllers = @[spartanNivel4ViewController];
    }*/else if (indexPath.section == 0 && indexPath.row == 3) {
        
        ICOCalendarioTableViewController *CalendarioTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"quintoController"];
        navigationController.viewControllers = @[CalendarioTableViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 4) {
        
        ICOConsejosViewController *ConsejosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sextoController"];
        navigationController.viewControllers = @[ConsejosViewController];
        
    }else if (indexPath.section == 0 && indexPath.row == 5) {
        
        ICOSobreNosotrosViewController *SobreNosotrosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"septimoController"];
        navigationController.viewControllers = @[SobreNosotrosViewController];
    }
    
    //octavoController  // WelcomeVC
    
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Home", @"Entrenamientos",@"Music Player", @"Calendario", @"Consejos", @"Nosotros"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

@end
