//  PickSliderView.h
//  PickSlider
//
//  Created by mrq on 16/12/9.
//  Copyright © 2016年 MrQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickSliderView : UIView

@property (nonatomic,assign) NSInteger selectedItemIndex;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,copy) void(^didSelectBlock)(NSInteger index);

@property (nonatomic,assign) CGFloat contentOffsetX;


- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToEnd:(NSInteger)index;
@end
