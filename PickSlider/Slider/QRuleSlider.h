//
//  QRuleSlder.h
//  toolsDemo
//
//  Created by Qianlishun on 2021/8/31.
//  Copyright © 2021 钱. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString*_Nullable(^QRuleSliderChange)(int value);

@interface QRuleSlider : UIView

@property (copy, nonatomic) QRuleSliderChange _Nullable ruleSliderChange;

@property(nonatomic) int value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value

@property(nonatomic, strong) UIColor*_Nonnull textColor;

- (void)setList:(NSArray*_Nullable)list;

@property(nullable, nonatomic,strong) UIColor *minimumTrackTintColor API_AVAILABLE(ios(5.0)) UI_APPEARANCE_SELECTOR;
@property(nullable, nonatomic,strong) UIColor *maximumTrackTintColor API_AVAILABLE(ios(5.0)) UI_APPEARANCE_SELECTOR;


@end
