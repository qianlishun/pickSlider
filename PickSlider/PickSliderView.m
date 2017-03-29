//  PickSliderView.h
//  PickSlider
//
//  Created by mrq on 16/12/9.
//  Copyright © 2016年 MrQ. All rights reserved.
//

#define kCellWidth self.frame.size.width/7

#define cellDefaultColor [UIColor darkGrayColor]
#define cellSelectColor [UIColor greenColor]

#import "PickSliderView.h"

@interface HorizontalScrollCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation HorizontalScrollCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.backgroundColor = cellDefaultColor;
        self.imageView.frame = CGRectMake(0, frame.size.height/4, frame.size.width+0.5, frame.size.height/2);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 10)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
    }
    
    return _titleLabel;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imageView.backgroundColor = cellDefaultColor;
}

@end

@interface PickSliderView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>


@property(nonatomic,strong) UICollectionView *pickerView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) BOOL autoScrollEnd;

@property (nonatomic,strong) NSMutableArray *bgImgList;

@end


static NSString *const reusedIdentifier = @"cell";

@implementation PickSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectedItemIndex = 0;
        self.dataSource = [NSMutableArray array];
        //Create flowlayout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(frame.size.width/7,frame.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        //Create collectionview with flowlayout
        self.pickerView =  [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        [self addSubview:_pickerView];
        
        self.pickerView.center = self.center;

        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_pickerView registerClass:[HorizontalScrollCell class]
        forCellWithReuseIdentifier:@"cell"];
        _pickerView.showsVerticalScrollIndicator = NO;
        _pickerView.showsHorizontalScrollIndicator = NO;
        _pickerView.backgroundColor = [UIColor clearColor];
        
        // 颜色自己改
        NSArray *colorArr = @[[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0],[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0],[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0],[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0],[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]];
        CGRect rect = CGRectMake(0, 0, 50, 50);
        UIImage *img1 = [self BgImgeFromstartColor:colorArr[0] endColor:colorArr[1] withFrame:rect];
        UIImage *img2 = [self BgImgeFromstartColor:colorArr[1] endColor:colorArr[2] withFrame:rect];
        UIImage *img3 = [self BgImgeFromstartColor:colorArr[2] endColor:colorArr[3] withFrame:rect];
        UIImage *img4 = [self BgImgeFromstartColor:colorArr[3] endColor:colorArr[4] withFrame:rect];
        _bgImgList = [NSMutableArray arrayWithArray:@[img1,img2,img3,img4]];
    }
    
    return self;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentIndexInArray = indexPath.row;
    
    HorizontalScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;

    if(currentIndexInArray == self.index) {
        cell.imageView.backgroundColor = cellSelectColor;
        [cell.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        cell.titleLabel.textColor = cellSelectColor;
    }else {
        cell.imageView.backgroundColor = cellDefaultColor;
        [cell.titleLabel setFont:[UIFont systemFontOfSize:14]];
        cell.titleLabel.textColor = [UIColor whiteColor];
    }
    
    NSString *title = self.dataSource[indexPath.row];
    if (indexPath.row < 3 || indexPath.row >= self.dataSource.count-3) {
        title = @" ";
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.imageView.image = nil;
    }
    cell.titleLabel.text = title;
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    self.index = indexPath.row;
//    
//    [self.pickerView reloadData];
//}



#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView) {
        return;
    }
    if(scrollView == self.pickerView) {
        
        // 如果出现误差，再加0.5
        NSInteger centerIndex = (scrollView.contentOffset.x+self.pickerView.center.x)/(kCellWidth);

        HorizontalScrollCell *perviousCenterCell = (HorizontalScrollCell *)[self.pickerView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
        if (perviousCenterCell) {
            perviousCenterCell.imageView.image = nil;
            perviousCenterCell.imageView.backgroundColor = cellDefaultColor;
            if (self.index<3 || self.index>=self.dataSource.count-3) {
                perviousCenterCell.imageView.backgroundColor = [UIColor clearColor];
                perviousCenterCell.imageView.image = nil;
            }
        }
        for (int i=-4; i<5; i++) {
            if (centerIndex+i>=0 && centerIndex<_dataSource.count) {
                HorizontalScrollCell *cell = (HorizontalScrollCell *)[self.pickerView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:centerIndex+i inSection:0]];
                cell.imageView.image = nil;
                UIImage *img;
                if (abs(i)==4) {
                    img = _bgImgList[0];
                }else if(abs(i)==3){
                    img = _bgImgList[1];
                }else if(abs(i)==2){
                    img = _bgImgList[2];
                }else if(abs(i)==1){
                    img = _bgImgList[3];
                }
                if (i>0) {
                    img = [UIImage imageWithCGImage:img.CGImage scale:1 orientation:UIImageOrientationDown];
                }
                cell.imageView.image = img;
                if (centerIndex+i<3 || centerIndex+i>=self.dataSource.count-3) {
                    cell.imageView.backgroundColor = [UIColor clearColor];
                    cell.imageView.image = nil;
                }
            }
        }
        
        HorizontalScrollCell *currentCenterCell = (HorizontalScrollCell *)[self.pickerView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:centerIndex inSection:0]];
        if (currentCenterCell) {
            currentCenterCell.imageView.image = nil;
            currentCenterCell.imageView.backgroundColor = cellSelectColor;
            if (centerIndex<3 || self.index>=self.dataSource.count-3) {
                currentCenterCell.imageView.backgroundColor = [UIColor clearColor];
                currentCenterCell.imageView.image = nil;
            }
        }

        if (self.index != centerIndex) {
            self.index = centerIndex;
            
            if (_autoScrollEnd) {
                if (self.index == self.dataSource.count-4) {
                    _autoScrollEnd = NO;
                }
                return;
            }
            [self itemIndexCallBack];
        }
    }
}

//结束滑动回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(scrollView == self.pickerView) {
        
        NSInteger x = (scrollView.contentOffset.x)/(kCellWidth)+0.5;

        self.pickerView.contentOffset = CGPointMake(x*kCellWidth, 0);
    }
}

//结束拖拽回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(scrollView == self.pickerView) {
        
        NSInteger x = (scrollView.contentOffset.x)/(kCellWidth)+0.5;

        self.pickerView.contentOffset = CGPointMake(x*kCellWidth, 0);
        
        //        [self itemIndexCallBack];
    }
}

- (void)itemIndexCallBack{
    if (self.didSelectBlock && !_autoScrollEnd) {
        if (self.index-3>=0 && self.index-3 < self.count) {
            self.didSelectBlock(self.index-3);
        }
    }
}


- (void)setCount:(NSInteger)count{
    _count = count;
    
    [self.dataSource removeAllObjects];
    for (int i=-2; i<count+4; i++) {
        NSNumber *number = [NSNumber numberWithInt:i];
        
        [self.dataSource addObject:number.stringValue];
    }
    
    [self.pickerView reloadData];
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    if (selectedItemIndex>=0 && selectedItemIndex<self.dataSource.count-3) {
        _selectedItemIndex = selectedItemIndex;
        _index = selectedItemIndex+3;
        [self.pickerView reloadData];
    }
}


- (void)scrollToEnd:(NSInteger)index{
    if (index>=0 && index<self.dataSource.count-3) {
        [self.pickerView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index+6 inSection:0] atScrollPosition:0 animated:YES];
        [self scrollViewDidEndDecelerating:self.pickerView];
        _autoScrollEnd = YES;
    }
}

- (void)scrollToIndex:(NSInteger)index{
    if (index>=0 && index<self.dataSource.count-3) {
        [self.pickerView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index+6 inSection:0] atScrollPosition:0 animated:YES];
        [self scrollViewDidEndDecelerating:self.pickerView];
    }
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX{
    
    self.pickerView.contentOffset = CGPointMake(contentOffsetX, 0);
//    [self scrollViewDidEndDecelerating:self.pickerView];
}

- (CGFloat)contentOffsetX{
    return self.pickerView.contentOffset.x;
}

- (UIImage *)BgImgeFromstartColor:(UIColor *)startColor endColor:(UIColor *)endColor withFrame:(CGRect)frame
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    //具体方向可根据需求修改
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(frame), CGRectGetMidY(frame));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return img;
}

@end

