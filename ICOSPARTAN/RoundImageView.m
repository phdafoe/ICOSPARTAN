//
//  RoundImageView.m
//  ICOMusicPlayerTest_1
//
//  Created by User on 20/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "RoundImageView.h"

@implementation RoundImageView

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}


-(void)setupUI{
    
    UIImageView *image = self;
    NSLog(@"Hola Mundo");
    
    //make new layer to contain shadow and masked image
    
    CALayer *layerImage = [CALayer layer];
    layerImage.shadowColor = [UIColor blackColor].CGColor;
    layerImage.shadowRadius = 10.0f;
    layerImage.shadowOffset = CGSizeMake(0.f, 5.f);
    layerImage.shadowOpacity = 1.f;
    
    //Use teh image's layer to mask the image into a circle
    image.layer.cornerRadius = round(image.frame.size.width/2.0);
    image.layer.masksToBounds = YES;
    
    
    
    
    
    
    
    
}


@end
