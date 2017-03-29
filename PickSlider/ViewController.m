//
//  ViewController.m
//  PickSlider
//
//  Created by mrq on 16/12/9.
//  Copyright © 2016年 MrQ. All rights reserved.
//

#import "ViewController.h"
#import "PickSliderView.h"

@interface ViewController ()

@property (nonatomic,strong) PickSliderView *pickSliderView;

@property (nonatomic,assign) NSInteger cineLoopIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    _pickSliderView.count = 20;
    
}

@end
