//
//  EFCircularSlider.m
//  ICOMusicPlayerTest_1
//
//  Created by User on 20/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "EFCircularSlider.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>


#define kDefaultFontSize 14.0f;
#define ToRad(deg) ((M_PI *(deg))/180.0)
#define ToDeg(rad) ((180.0*(rad))/M_PI)
#define SQR(x)     ((x)*(x))


@implementation EFCircularSlider

-(void)defaults{
    
    //defaults
    self.maximumValue = 100.0f;
    self.minimumValue = 0.0f;
    self.currentValue = 0.0f;
    
    self.handleColor = [UIColor whiteColor];
    self.unflledColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.filledColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    self.lineWidth = 6;
    
    self.labelFont = [UIFont systemFontOfSize:10.0f];
    self.snapToLabels = NO;
    self.handleType = EFSemiTransparentBlackCircle;
    self.labelColor = [UIColor clearColor];
    
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        [self defaults];
        [self setFrame:frame];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    if (self = [super initWithCoder:aDecoder]) {
        [self defaults];
    }

    return self;



}



#pragma  mark - Setter/Getter

-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    angle = [self angleFromValue];
    radius = self.frame.size.height/2 - self.lineWidth/2 -10;
    
}

- (void)setCurrentValue:(float)currentValue {
    _currentValue=currentValue;
    
    if(_currentValue>_maximumValue) _currentValue=_maximumValue;
    else if(_currentValue<_minimumValue) _currentValue=_minimumValue;
    
    angle = [self angleFromValue];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - drawing methods

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Draw the unfilled circle
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, M_PI * 2, 0);
    [self.unflledColor setStroke];
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Draw the filled Circle
    if ((self.handleType == EFDoubleCircleWithClosedCenter || self.handleType == EFDoubleCircleWithOpenCenter) && fixedAngle > 5) {
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 3 * M_PI / 2, 3 * M_PI / 2 - ToRad(angle + 3), 0);
    
    }else{
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 3 * M_PI / 2, 3 * M_PI / 2 - ToRad(angle), 0);
    }
    
    [self.filledColor setStroke];
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Add the labels (if neccesary)
    if (labelsEvenSpacing != nil) {
        [self drawLabels:ctx];
    }
    
    //The draggable part
    [self drawHandle:ctx];
    
    
}

-(void) drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle: angle];
    if(_handleType == EFSemiTransparentWhiteCircle) {
        [[UIColor colorWithWhite:1.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    } else if(_handleType == EFSemiTransparentBlackCircle) {
        [[UIColor colorWithWhite:0.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    } else if(_handleType == EFDoubleCircleWithClosedCenter) {
        [_handleColor set];
        CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, _lineWidth, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 7);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth-1, _lineWidth-1));
    } else if(_handleType == EFDoubleCircleWithOpenCenter) {
        [_handleColor set];
        CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, _lineWidth/2 + 5, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 4);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextAddArc(ctx, handleCenter.x + _lineWidth/2, handleCenter.y + _lineWidth/2, _lineWidth/2, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
    } else if(_handleType == EFBigCircle) {
        [_handleColor set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-2.5, handleCenter.y-2.5, _lineWidth+5, _lineWidth+5));
    }
    
    CGContextRestoreGState(ctx);
}

-(void) drawLabels:(CGContextRef)ctx {
    if(labelsEvenSpacing == nil || [labelsEvenSpacing count] == 0) {
        return;
    } else {
        NSDictionary *attributes = @{ NSFontAttributeName: _labelFont,
                                      NSForegroundColorAttributeName: _labelColor
                                      };
        
        CGFloat fontSize = ceilf(_labelFont.pointSize);
        
        NSInteger fontSizeDifferenceFromDefault = fontSize - kDefaultFontSize;
        
        NSInteger distanceToMove = -((self.lineWidth * 1.5) + fontSizeDifferenceFromDefault);
        
        for (int i=0; i<[labelsEvenSpacing count]; i++)
        {
            NSString *label = labelsEvenSpacing[[labelsEvenSpacing count] - i - 1];
            
            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
            
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            
            CGPoint closestPointOnCircleToLabel = [self pointFromAngle:degreesForLabel];
            
            CGRect labelLocation = CGRectIntegral(CGRectMake(closestPointOnCircleToLabel.x, closestPointOnCircleToLabel.y, [self widthOfString:label withFont:_labelFont], [self heightOfString:label withFont:_labelFont]));
            
            CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            
            float radiansTowardsCenter = ToRad(AngleFromNorth(centerPoint, closestPointOnCircleToLabel, NO));
            
            labelLocation.origin.x =  ceilf((labelLocation.origin.x + (self.lineWidth/2) + distanceToMove * cos(radiansTowardsCenter)) - labelLocation.size.width/2);
            
            labelLocation.origin.y = ceilf((labelLocation.origin.y + (self.lineWidth/2) + distanceToMove * sin(radiansTowardsCenter))- labelLocation.size.height/2);
            
            [label drawInRect:labelLocation withAttributes:attributes];
        }
    }
}

#pragma mark - UIControl functions

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    if(_snapToLabels && labelsEvenSpacing != nil) {
        CGFloat newAngle=0;
        float minDist = 360;
        for (int i=0; i<[labelsEvenSpacing count]; i++) {
            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            if(fabs(fixedAngle - degreesForLabel) < minDist) {
                newAngle=degreesForLabel ? 360 - degreesForLabel : 0;
                minDist = fabs(fixedAngle - degreesForLabel);
            }
        }
        angle = newAngle;
        _currentValue = [self valueFromAngle];
        [self setNeedsDisplay];
    }
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));
    angle = 360 - 90 - currentAngle;
    _currentValue = [self valueFromAngle];
    [self setNeedsDisplay];
}

#pragma mark - helper functions

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt-90))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt-90)));
    
    return result;
}

-(CGPoint)pointFromAngle:(int)angleInt withObjectSize:(CGSize)size{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - size.width/2, self.frame.size.height/2 - size.height/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt-90))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt-90)));
    
    return result;
}

- (CGFloat)circleDiameter {
    if(_handleType == EFSemiTransparentWhiteCircle) {
        return _lineWidth;
    } else if(_handleType == EFSemiTransparentBlackCircle) {
        return _lineWidth;
    } else if(_handleType == EFDoubleCircleWithClosedCenter) {
        return _lineWidth * 2 + 3.5;
    } else if(_handleType == EFDoubleCircleWithOpenCenter) {
        return _lineWidth + 2.5 + 2;
    } else if(_handleType == EFBigCircle) {
        return _lineWidth + 2.5;
    }
    return 0;
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

-(float) valueFromAngle {
    if(angle < 0) {
        _currentValue = -angle;
    } else {
        _currentValue = 270 - angle + 90;
    }
    fixedAngle = _currentValue;
    return (_currentValue*(_maximumValue - _minimumValue))/360.0f;
}

- (float)angleFromValue {
    angle = 360 - (360.0f*_currentValue/_maximumValue);
    
    if(angle==360) angle=0;
    
    return angle;
}

- (CGFloat) widthOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat) heightOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}

#pragma mark - public methods
-(void)setInnerMarkingLabel:(NSArray*)labels{
    labelsEvenSpacing = labels;
    [self setNeedsDisplay];
}



@end
