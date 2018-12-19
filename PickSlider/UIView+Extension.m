

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}


-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setRight:(CGFloat)right
{
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setBottom:(CGFloat)bottom
{
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

-(CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerY
{
    return self.center.y;
}

-(void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

-(CGSize)size
{
    return self.frame.size;
}


+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView && !keyboardView.hidden)
        {
            return keyboardView;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

+ (float)getScreenDPI{
    float dpi;
    float scale = 1;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        scale = [[UIScreen mainScreen] scale];  //得到屏幕分辨率
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dpi = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        dpi = 163 * scale;
    } else {
        dpi = 160 * scale;
    }
    return dpi;
}


- (void)setBoundsWith:(UIColor *)color{
    //设置圆角的半径
    [self.layer setCornerRadius:0];
    
    //切割超出圆角范围的子视图
    self.layer.masksToBounds = YES;
    
    //设置边框的颜色
    [self.layer setBorderColor:color.CGColor];
    
    //设置边框的粗细
    [self.layer setBorderWidth:1.0];
}
@end
