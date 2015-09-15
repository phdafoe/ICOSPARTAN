//
//  ICOGaleriaViewController.m
//  ICOSPARTAN
//
//  Created by User on 7/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOGaleriaViewController.h"
#import "GHWalkThroughView.h"



@interface ICOGaleriaViewController () <GHWalkThroughViewDataSource>

@property (nonatomic, strong) GHWalkThroughView* ghView ;

@property (nonatomic, strong) NSArray* descStrings;

@property (nonatomic, strong) UILabel* welcomeLabel;

@end

@implementation ICOGaleriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
    [_ghView setDataSource:self];
    [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel = welcomeLabel;
    
}

#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 6;
}

#warning esto es un fallo pero no hay problema es una cuestion de converision de int a integer etc...;))
- (UIImage*) bgImageforPage:(NSInteger)index
{  
    NSString* imageName =[NSString stringWithFormat:@"intro_%d@2x.jpg", index+1]; // OK va tirando
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
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


- (IBAction)showMenuSpartan:(id)sender {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)showGaleria:(id)sender {
    
    self.ghView.floatingHeaderView = nil;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    [self.ghView showInView:self.navigationController.view animateDuration:0.3];
}
@end
