//
//  ICOMapasEntrenamientoTableViewController.m
//  iCoSpartan
//
//  Created by User on 1/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOMapasEntrenamientoTableViewController.h"
#import "CustomCell2.h"

#import "ICODetailMapViewController.h"

#import "M6ParallaxController.h"

@interface ICOMapasEntrenamientoTableViewController ()

@end

@implementation ICOMapasEntrenamientoTableViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.parallaxController tableViewControllerDidScroll:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lugaresEntrenamiento" ofType:@"plist"];
    
    self.mapasArray = [NSArray arrayWithContentsOfFile:path];
    
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
    return [self.mapasArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];*/
    
    CustomCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    self.mapasDictionary = (self.mapasArray)[indexPath.row];
    
    NSString *title = self.mapasDictionary [@"title"];
    NSString *mapaImage = self.mapasDictionary [@"parkImageName"];
    NSString *numeroParkImage = self.mapasDictionary [@"numberParkImageName"];
    
    UIImage *parkImage = [UIImage imageNamed:mapaImage];
    UIImage *numeroPark = [UIImage imageNamed:numeroParkImage];
    
    cell.nameParkTrainer.text = title;
    cell.imageParkTrainer.image = parkImage;
    cell.numberParkTrainer.image = numeroPark;
    
    
    // Configure the cell... //detalleMapasEntrenamiento
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //Creamos la clase
    
    ICODetailMapViewController *detailMapsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleMapasEntrenamiento"];
    
    
    self.mapasDictionary = (self.mapasArray)[indexPath.row];
    
    NSString *title = self.mapasDictionary [@"title"];
    NSString *mapaImage = self.mapasDictionary [@"parkBigImageName"];
    NSString *descriptionMap = self.mapasDictionary [@"description"];
    NSString *city = self.mapasDictionary [@"city"];
    
    UIImage *parkImage = [UIImage imageNamed:mapaImage];
    
    
    detailMapsViewController.nameMapParkTrainer = title;
    detailMapsViewController.descriptionMapParkTrainer = descriptionMap;
    detailMapsViewController.imageMapPark = parkImage;
    detailMapsViewController.nameCityMapParkTrainer = city;
    
    [self.navigationController pushViewController:detailMapsViewController animated:YES];
    
    NSLog(@"Esta siendo seleccionado %@", (self.mapasArray)[indexPath.row]);
    
    
    
}


@end
