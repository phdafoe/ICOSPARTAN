//
//  ICOSpartanNivel1TableViewController.m
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOSpartanNivel1TableViewController.h"
#import "CustomCell.h"
#import "ICODetailSpartanNivel1ViewController.h"

@interface ICOSpartanNivel1TableViewController ()

@end

@implementation ICOSpartanNivel1TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spartanLevel1"
                                                     ofType:@"plist"];
    
    self.spartanArray = [NSArray arrayWithContentsOfFile:path];
    
    
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
    return [self.spartanArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];*/
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    self.spartanDictionary = [self.spartanArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    NSString *title = self.spartanDictionary [@"title"];
    NSString *description = self.spartanDictionary [@"description"];
    NSString *imageName = self.spartanDictionary [@"imageName1"];
   
    
    UIImage *image = [UIImage imageNamed:imageName];

    
    /*cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    cell.imageView.image = image;*/
    
    cell.customTitleLabel.text = title;
    cell.customDescriptionLabel.text = description;
    cell.customImageNameLabel.image = image;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //Creamos la clase
    
    ICODetailSpartanNivel1ViewController *detailSpartanNivel1 = [self.storyboard instantiateViewControllerWithIdentifier:@"DetalleSpartanNivel1"];
    
    [self.navigationController pushViewController:detailSpartanNivel1 animated:YES];
  
    
    
    self.spartanDictionary = [self.spartanArray objectAtIndex:indexPath.row];
    
    NSString *title = self.spartanDictionary [@"title"];
    NSString *description = self.spartanDictionary [@"description"];
    NSString *imageName = self.spartanDictionary [@"imageName1"];
    NSString *imageName2 = self.spartanDictionary [@"imageName2"];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *image2 = [UIImage imageNamed:imageName2];
    
    detailSpartanNivel1.titleLabel = title;
    detailSpartanNivel1.descriptionLabel = description;
    detailSpartanNivel1.imageView1 = image;
    detailSpartanNivel1.imageView2 = image2;
    
    
    
    NSLog(@"Esta siendo seleccionado %@", [self.spartanArray objectAtIndex:indexPath.row]);
    
    
    
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
