//
//  CustomCell1.m
//  iCoSpartan
//
//  Created by User on 24/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "CustomCell1.h"

@implementation CustomCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.nameObstacleWarriors setNumberOfLines:0];
    [self.dateObstacleWarriors setNumberOfLines:0];
    [self.cityObstacleWarriors setNumberOfLines:0];

    // Configure the view for the selected state
}

@end
