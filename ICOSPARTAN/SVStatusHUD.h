//
//  SVStatusHUD.h
//  ICOMusicPlayerTest_1
//
//  Created by User on 20/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVStatusHUD : UIView

+ (void)showWithImage:(UIImage*)image;
+ (void)showWithImage:(UIImage*)image status:(NSString*)string;
+ (void)showWithImage:(UIImage*)image status:(NSString*)string duration:(NSTimeInterval)duration;

@end
