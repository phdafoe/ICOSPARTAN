//
//  ICOGaleriaViewController.h
//  ICOSPARTAN
//
//  Created by User on 7/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface ICOGaleriaViewController : UIViewController <UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

- (IBAction)showMenuSpartan:(id)sender;


@end
