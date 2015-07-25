//
//  EFCircularSlider.h
//  ICOMusicPlayerTest_1
//
//  Created by User on 20/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFCircularSlider : UIControl{
    
    CGFloat radius;
    int angle;
    int fixedAngle;
    NSMutableDictionary *labelsWithPercents;
    NSArray *labelsEvenSpacing;
    
}

typedef NS_ENUM(NSInteger, EFHandleType){
    
    EFSemiTransparentWhiteCircle,
    EFSemiTransparentBlackCircle,
    EFDoubleCircleWithOpenCenter,
    EFDoubleCircleWithClosedCenter,
    EFBigCircle
   
};

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;

@property (nonatomic) int lineWidth;
@property (nonatomic, strong) UIColor *filledColor;
@property (nonatomic, strong) UIColor *unflledColor;

@property (nonatomic, strong) UIColor *handleColor;
@property (nonatomic) EFHandleType handleType;

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic) BOOL snapToLabels;

-(void)setInnerMarkingLabel:(NSArray *)labels;










@end
