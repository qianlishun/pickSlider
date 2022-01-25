//
//  LayoutControlCell.m
//  PageTest
//
//  Created by xiao can on 2019/6/12.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "LayoutControlCell.h"

@interface LayoutControlCell()
@end

@implementation LayoutControlCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:random() % 256 / 255.0 green:random() % 256 / 255.0 blue:random() % 230 / 255.0 alpha:1.0];
        
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 8.0;
        
        self.lImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.lImgView.contentMode =UIViewContentModeScaleAspectFit;
        [self addSubview:self.lImgView];
        
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.cornerRadius = 8.0;
        shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        shadowLayer.shadowColor = [UIColor lightGrayColor].CGColor;
        shadowLayer.shadowRadius = 3.0;
        shadowLayer.shadowOpacity = 1.0;
        shadowLayer.shadowOffset = CGSizeZero;
        shadowLayer.frame = self.contentView.frame;
        [self.layer insertSublayer:shadowLayer atIndex:0];
        self.shadowLayer = shadowLayer;
        
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.shadowLayer.frame = self.bounds;
}

@end
