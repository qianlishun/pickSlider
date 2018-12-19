//  PickSliderView.h
//  PickSlider
//
//  Created by mrq on 16/12/9.
//  Copyright © 2016年 MrQ. All rights reserved.
//

#define kCellWidth self.frame.size.width/7

#define cellDefaultColor [UIColor whiteColor]
#define cellSelectColor [UIColor greenColor]

#import "PickSliderView.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"

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
        _pickerView.bounces = NO;
        
    }
    
    return self;
}

- (void)setImageList:(NSArray *)imageList{
    self.dataSource = [NSMutableArray arrayWithArray:imageList];
    [self.pickerView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count*20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentIndexInArray = indexPath.row;
    
    HorizontalScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];

    cell.imageView.image = self.dataSource[currentIndexInArray%4];
    [cell.imageView setBoundsWith:[UIColor clearColor]];

//    if(currentIndexInArray == self.index) {
//        [cell.imageView setBoundsWith:[UIColor greenColor]];
//        cell.imageView.backgroundColor = cellSelectColor;
//        [cell.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//        cell.titleLabel.textColor = cellSelectColor;
//    }else {
//        cell.imageView.backgroundColor = cellDefaultColor;
//        [cell.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        cell.titleLabel.textColor = [UIColor whiteColor];
//    }
 
    
    return cell;
}

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
            [perviousCenterCell.imageView setBoundsWith:[UIColor clearColor]];
            perviousCenterCell.titleLabel.textColor = cellDefaultColor;
        }
        
        HorizontalScrollCell *cell = (HorizontalScrollCell *)[self.pickerView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:centerIndex inSection:0]];
        [cell.imageView setBoundsWith:cellSelectColor];
        cell.titleLabel.textColor = cellSelectColor;
        
        if (centerIndex != self.index) {
            self.index = centerIndex;
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
        

    }
}

- (void)itemIndexCallBack{
    self.didSelectBlock(self.index);
}

@end

