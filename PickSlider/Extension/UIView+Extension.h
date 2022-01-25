
#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property CGFloat width;
@property CGFloat height;
@property CGFloat x;
@property CGFloat y;
@property CGFloat right;
@property CGFloat bottom;
@property CGFloat centerX;
@property CGFloat centerY;
@property CGSize  size;

+ (instancetype)viewFromXib;
+ (float)getScreenDPI;

- (UIView *)findKeyboard;

- (void)setBoundsWith:(UIColor *)color;

- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame fontsize:(float)fontsize;
- (CATextLayer*)createTextLayerWithString:(NSString*)string Frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;

@end
