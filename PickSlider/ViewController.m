//
//  ViewController.m
//  PickSlider
//
//  Created by mrq on 16/12/9.
//  Copyright © 2016年 MrQ. All rights reserved.
//

#import "ViewController.h"
#import "PickSliderView.h"
#import "UIImage+Extension.h"
#import "QRuleSlider.h"

@interface ViewController ()

@property (nonatomic,strong) PickSliderView *pickSliderView;

@property (nonatomic,assign) NSInteger cineLoopIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    QRuleSlider *slider = [[QRuleSlider alloc]initWithFrame:CGRectMake(0, 0, 80, 300)];
    slider.textColor = [UIColor blackColor];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.value = 30;
    [self.view addSubview:slider];
    slider.center = self.view.center;
    
    slider.ruleSliderChange = ^NSString * _Nullable(int value) {
        NSString *text = [NSString stringWithFormat:@"%d",value];
        NSLog(@"slider index %@",text);
        return text;
    };
    
    /*
    _pickSliderView = [[PickSliderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    _pickSliderView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:_pickSliderView];
   
    _pickSliderView.center = self.view.center;
    
    __weak typeof( self ) weakSelf = self;
    _pickSliderView.didSelectBlock = ^(NSInteger index){
        if (index == weakSelf.cineLoopIndex) {
            return;
        }
        NSLog(@"didSelected----%zd",index);
        int currenIndex = (int)index;
        _cineLoopIndex = currenIndex;
    };
    CGSize size = CGSizeMake(60, 40);
    UIImage *image1 = [[UIImage imageNamed:@"IMG_0001.JPG"]scaleToSize:size];
    UIImage *image2 = [[UIImage imageNamed:@"IMG_0002.JPG"]scaleToSize:size];
    UIImage *image3 = [[UIImage imageNamed:@"IMG_0003.JPG"]scaleToSize:size];
    UIImage *image4 = [[UIImage imageNamed:@"IMG_0004.JPG"]scaleToSize:size];

    NSArray *imageList = @[image1,image2,image3,image4];
    
    [self.pickSliderView setImageList:imageList];
     
     */
}

@end
