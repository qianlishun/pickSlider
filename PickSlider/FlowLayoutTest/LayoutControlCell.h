//
//  LayoutControlCell.h
//  PageTest
//
//  Created by xiao can on 2019/6/12.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LayoutControlCell : UICollectionViewCell

@property (nonatomic, strong)  UILabel        *numlabel;
@property (nonatomic, strong)  UIImageView    *lImgView;
@property (nonatomic, weak) CALayer            *shadowLayer;

@end

NS_ASSUME_NONNULL_END
