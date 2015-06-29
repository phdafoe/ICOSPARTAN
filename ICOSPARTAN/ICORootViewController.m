//
//  ICORootViewController.m
//  iCoSpartan
//
//  Created by User on 29/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICORootViewController.h"

@implementation ICORootViewController

-(void)awakeFromNib{
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
