//
//  QRuleSlder.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/8/31.
//  Copyright © 2021 钱. All rights reserved.
//

#import "QRuleSlider.h"
#import "UIView+Extension.h"

static float layerLineWidth = 2;

@interface QRuleSlider()

@property (nonatomic,strong) CAShapeLayer *bgLayer;

@property (nonatomic,strong) CAShapeLayer *selLayer;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,strong) NSArray *textList;

@end

@implementation QRuleSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanGesture:)];
        [self addGestureRecognizer:panGes];
        
        CGFloat layerWidth = 40;
        CGFloat left =  ( frame.size.width - layerWidth) / 3.0 * 2;

        _bgLayer = [CAShapeLayer layer];
        [_bgLayer setFrame:CGRectMake(left, 0, layerWidth, frame.size.height)];
        _bgLayer.backgroundColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = layerLineWidth;
        [self.layer addSublayer:_bgLayer];
        
        
        _selLayer = [CAShapeLayer layer];
        [_selLayer setFrame:CGRectMake(left, 0, layerWidth, frame.size.height)];
        _selLayer.backgroundColor = [UIColor clearColor].CGColor;
        _selLayer.lineWidth = layerLineWidth;
        [self.layer addSublayer:_selLayer];
        
                
        self.minimumTrackTintColor = [UIColor grayColor];
        self.maximumTrackTintColor =  [UIColor orangeColor];
        
        self.textColor = [UIColor orangeColor];
        
    }
    return self;
}

- (void)actionPanGesture:(UIPanGestureRecognizer *)sender{

    if(sender.state == UIGestureRecognizerStateCancelled ||
       sender.state == UIGestureRecognizerStateFailed){
        return;
    }else if(sender.state == UIGestureRecognizerStateBegan){
        CGFloat y = (self.value - self.minimumValue ) / (self.maximumValue - self.minimumValue) * self.height;
        [sender setTranslation:CGPointMake(0, y) inView:sender.view];
    }
    
    CGPoint touchPoint = [sender translationInView:sender.view];
  
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.y / self.frame.size.height );
    value = self.minimumValue + value + 0.5;

    if(value <= self.minimumValue){
        value = self.minimumValue;
    }else if(value >= self.maximumValue){
        value = self.maximumValue;
    }
    
    if(sender.state == UIGestureRecognizerStateEnded && self.ruleSliderChange){
        _text = self.ruleSliderChange(value);
    }
    if((int)value != self.value){
        self.value = (int)value;
    }
}

/*
- (void)actionPanGesture:(UIPanGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateCancelled ||
       sender.state == UIGestureRecognizerStateFailed){
        return;
    }
    
    CGPoint touchPoint = [sender locationInView:self];
    if(touchPoint.y <= 0){
        touchPoint.y = 0;
    }else if(touchPoint.y >= self.height){
        touchPoint.y = self.height;
    }

    // 先默认为垂直样式
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.y / self.frame.size.height );
//    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );

    value = self.minimumValue + value + 0.5;
        
    if(sender.state == UIGestureRecognizerStateEnded && self.ruleSliderChange){
        _text = self.ruleSliderChange(value);
    }
    if((int)value != self.value){
        self.value = (int)value;
    }
}
*/
 
- (void)setValue:(int)value{
    _value = value;
    [self updateLayer];
}

- (void)setList:(NSArray *)list{
    _textList = list;
    self.minimumValue = 0;
    self.maximumValue = list.count-1;
}

- (void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    if(self.value < minimumValue){
        self.value = minimumValue;
    }
}

- (void)setMaximumValue:(float)maximumValue{
    _maximumValue = maximumValue;
    if(self.value > maximumValue){
        self.value = maximumValue;
    }
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor{
    _minimumTrackTintColor = minimumTrackTintColor;
    self.bgLayer.strokeColor = minimumTrackTintColor.CGColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor{
    _maximumTrackTintColor = maximumTrackTintColor;
    self.selLayer.strokeColor = maximumTrackTintColor.CGColor;
}

- (void)updateLayer{
    if(self.maximumValue == 0)
        return;
    
    [self.selLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    float lineWidth = 5;
    int bigRow = 6; int row = 5;
    float allRow = bigRow * row;

    float currentValue = (self.value - self.minimumValue ) / (self.maximumValue - self.minimumValue) * allRow;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    UIBezierPath *selPath = [UIBezierPath bezierPath];
    
    CGFloat topY = 0;
    if(self.tag==2){
        topY = 1.5 / allRow * self.height;
    }
    CGPoint p1 = CGPointMake(0, topY);
    CGPoint p2 = CGPointMake(12, 0);
    [selPath moveToPoint:p1];
    [selPath addLineToPoint:p2];
    
    CGFloat currentY = (int)currentValue / allRow * (self.height-topY)   + topY;
    p1 = CGPointMake(0, topY-1);
    p2 = CGPointMake(0, currentY);
    [selPath moveToPoint:p1];
    [selPath addLineToPoint:p2];
    
    p1 = CGPointMake(0, self.height);
    [bgPath moveToPoint:p1];
    [bgPath addLineToPoint:p2];
    
    
    for (int i = 1; i <= allRow; i++) {
        
        float y = i / allRow * (self.height-topY) - layerLineWidth/2 + topY;
        
        if(y > self.height)
            break;
        
        
        if( i%row == 0){
            lineWidth = 12;
        }else{
            lineWidth = 5;
        }
        
        if(i == (int)currentValue){
            lineWidth = 16;
        }
        
        CGPoint p1 = CGPointMake(0, y);
        CGPoint p2 = CGPointMake(lineWidth, y);
        
        if(i <= currentValue){
            [selPath moveToPoint:p1];
            [selPath addLineToPoint:p2];
        }else{
            [bgPath moveToPoint:p1];
            [bgPath addLineToPoint:p2];
        }
    }
    
    CGFloat fontSize = 13;
    
    CGFloat textY = currentValue/allRow*self.height - 8;
    if(textY < 0) textY = 0;
    NSString *text = [NSString stringWithFormat:@"%d",self.value];
    if(_textList){
        text = [NSString stringWithFormat:@"%@",self.textList[self.value]];
    }

    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    CATextLayer *layer = [self createTextLayerWithString:text Frame:CGRectMake(16, textY, 40, 15) font:font color:self.textColor];
    [self.selLayer addSublayer:layer];
//    _textLabel.text = [NSString stringWithFormat:@"%.f",self.value];
//    _textLabel.y = textY;
    
    self.selLayer.path = selPath.CGPath;
    self.bgLayer.path = bgPath.CGPath;
}


@end
