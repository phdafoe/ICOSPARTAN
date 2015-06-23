//
//  ICOGaleriaViewController.m
//  ICOSPARTAN
//
//  Created by User on 7/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOGaleriaViewController.h"

@interface ICOGaleriaViewController ()

@end

@implementation ICOGaleriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int i;
    
    for (i = 0 ; i < 23; i ++) {
        UIImageView *imagenes = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"SPARTAN%d@2x.png", i]]];
        imagenes.frame = CGRectMake((i - 1) * 320, 0 ,320, 499);
        [self.scrollView addSubview:imagenes];
    }
    
    self.scrollView.contentSize = CGSizeMake(10 * 320, 499);
    self.scrollView.pagingEnabled = YES;
    self.pageControll.numberOfPages = 10;
    self.pageControll.currentPage = 0;
    //self.pageControll.preservesSuperviewLayoutMargins = YES;
    
    // Do any additional setup after loading the view.
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    self.pageControll.currentPage = page;
    
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


@end
