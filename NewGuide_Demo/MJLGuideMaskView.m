//
//  MJLGuideMaskView.m
//  NewGuide_Demo
//
//  Created by 马金丽 on 17/10/10.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "MJLGuideMaskView.h"



typedef NS_ENUM(NSInteger, MJLGuideMaskItemRegion)
{
    /// 左上方
    MJLGuideMaskItemRegionLeftTop = 0,
    
    /// 左下方
    MJLGuideMaskItemRegionLeftBottom,
    
    /// 右上方
    MJLGuideMaskItemRegionRightTop,
    
    /// 右下方
    MJLGuideMaskItemRegionRightBottom
};

/**
 自定义新手引导蒙版
 */
@interface MJLGuideMaskView ()


/**
 蒙版
 */
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)CAShapeLayer *maskLayer;

/**
 箭头图片
 */
@property(nonatomic,strong)UIImageView *arrowsImageView;


/**
 描述Label
 */
@property(nonatomic,strong)UILabel *descriLabel;

/**
 当前正在进行引导的item的下标
 */
@property(nonatomic,assign)NSInteger currentaIndex;
@end

@implementation MJLGuideMaskView

{
    NSInteger _count;   //item的数量
}


#pragma mark -初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setupUI];
    }
    return self;
}



- (instancetype)initWithDataSource:(id<MJLGuideMaskViewDataSouce>)dataSource
{
    MJLGuideMaskView *guideMaskView = [[MJLGuideMaskView alloc]initWithFrame:CGRectZero];
    guideMaskView.dataSource = dataSource;
    return guideMaskView;
}


/**
 设置UI
 */
- (void)setupUI
{
    [self addSubview:self.maskView];
    [self addSubview:self.arrowsImageView];
    [self addSubview:self.descriLabel];
    
    //默认
    self.backgroundColor = [UIColor clearColor];
    self.maskBackgroundColor = [UIColor blackColor];
    self.maskAlpha = 0.7f;
    self.arrowImage = [UIImage imageNamed:@"guide_arrow"];
    self.descriLabel.textColor = [UIColor whiteColor];
    self.descriLabel.font = [UIFont systemFontOfSize:13];
}




#pragma mark -懒加载
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
    }
    return _maskView;
}


- (UIImageView *)arrowsImageView
{
    if (!_arrowsImageView) {
        _arrowsImageView = [[UIImageView alloc]init];
    }
    return _arrowsImageView;
}

- (UILabel *)descriLabel
{
    if (!_descriLabel) {
        _descriLabel = [[UILabel alloc]init];
        _descriLabel.numberOfLines = 0;
    }
    return _descriLabel;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}


#pragma mark -setter
- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowImage = arrowImage;
    self.arrowsImageView.image = arrowImage;
}

- (void)setMaskBackgroundColor:(UIColor *)maskBackgroundColor
{
    _maskBackgroundColor = maskBackgroundColor;
    self.maskView.backgroundColor = maskBackgroundColor;
}

- (void)setMaskAlpha:(CGFloat)maskAlpha
{
    _maskAlpha = maskAlpha;
    self.maskView.alpha = maskAlpha;
}

- (void)setCurrentaIndex:(NSInteger)currentaIndex
{
    _currentaIndex = currentaIndex;
    [self showMask];
    [self congifureItemsFrame];
}


#pragma mark -Privite Method


/**
 显示蒙版
 */
- (void)showMask
{
    //起点
    CGPathRef fromPath = self.maskLayer.path;
    
    self.maskLayer.frame = self.bounds;
    self.maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGFloat maskCornerRedius = 5;
    
    if (self.layout && [self.layout respondsToSelector:@selector(guideMaskView:cornerRadiusForViewAtIndex:)]) {
        maskCornerRedius = [self.layout guideMaskView:self cornerRadiusForViewAtIndex:self.currentaIndex];
    }
    //获取可见区域的路径(开始路径)
    UIBezierPath *visualPath = [UIBezierPath bezierPathWithRoundedRect:[self fetchVisualFrame] cornerRadius:maskCornerRedius];
    
    //获取终点路径
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [toPath appendPath:visualPath];
    
    //遮罩的路径
    self.maskLayer.path = toPath.CGPath;
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = self.maskLayer;
    
    //开始移动动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = 0.3;
    anim.fromValue = (__bridge id _Nullable)(fromPath);
    anim.toValue   = (__bridge id _Nullable)(toPath.CGPath);
    [self.maskLayer addAnimation:anim forKey:NULL];

}



/**
 设置items的frame
 */
- (void)congifureItemsFrame
{
    //设置描述文字的属性
    //文字颜色
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(guideMaskView:colorForDescriptionAtIndex:)]) {
        self.descriLabel.textColor = [self.dataSource guideMaskView:self colorForDescriptionAtIndex:self.currentaIndex];
    }
    //文字字体
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(guideMaskView:fontForDescriptionAtIndex:)]) {
        self.descriLabel.font = [self.dataSource guideMaskView:self fontForDescriptionAtIndex:self.currentaIndex];
    }
    //描述文字
    NSString *desc = [self.dataSource guideMaskView:self descriptionForItemAtIndex:self.currentaIndex];
    self.descriLabel.text  = desc;
    //每个item的文字与左右边框间的距离
    CGFloat descInsetsX = 50;
    if (self.layout && [self.layout respondsToSelector:@selector(guideMaskView:horizontalInsetForDescriptionAtIndex:)]) {
        descInsetsX = [self.layout guideMaskView:self horizontalInsetForDescriptionAtIndex:self.currentaIndex];
    }
    
    //每个item的子视图之间的间距
    CGFloat space = 20;
    if (self.layout && [self.layout respondsToSelector:@selector(guideMaskView:spaceForItemAtIndex:)]) {
        space = [self.layout guideMaskView:self spaceForItemAtIndex:self.currentaIndex];
    }
    
    //设置文字与箭头的位置
    CGRect textRect,arrowRect;
    CGSize imgSize = self.arrowsImageView.image.size;
    CGFloat maxWidth = self.bounds.size.width - descInsetsX *2;
    CGSize textSize = [desc boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.descriLabel.font} context:NULL].size;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    //获取item的方位
    MJLGuideMaskItemRegion itemRegion = [self fetchVisualRegion];
    switch (itemRegion) {
        case MJLGuideMaskItemRegionLeftTop:
        {
            /// 左上
            transform = CGAffineTransformMakeScale(-1, 1);
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMaxY([self fetchVisualFrame]) + space,
                                   imgSize.width,
                                   imgSize.height);
            CGFloat x = 0;
            
            if (textSize.width < CGRectGetWidth([self fetchVisualFrame]))
            {
                x = CGRectGetMaxX(arrowRect) - textSize.width * 0.5;
            }
            else
            {
                x = descInsetsX;
            }
            
            textRect = CGRectMake(x, CGRectGetMaxY(arrowRect) + space, textSize.width, textSize.height);
            break;
        }
        case MJLGuideMaskItemRegionRightTop:
        {
            /// 右上
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMaxY([self fetchVisualFrame]) + space,
                                   imgSize.width,
                                   imgSize.height);
            
            CGFloat x = 0;
            
            if (textSize.width < CGRectGetWidth([self fetchVisualFrame]))
            {
                x = CGRectGetMinX(arrowRect) - textSize.width * 0.5;
            }
            else
            {
                x = descInsetsX + maxWidth - textSize.width;
            }
            
            textRect = CGRectMake(x, CGRectGetMaxY(arrowRect) + space, textSize.width, textSize.height);
            break;
        }
        case MJLGuideMaskItemRegionLeftBottom:
        {
            
            /// 左下
            transform = CGAffineTransformMakeScale(-1, -1);
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMinY([self fetchVisualFrame]) - space - imgSize.height,
                                   imgSize.width,
                                   imgSize.height);
            
            CGFloat x = 0;
            
            if (textSize.width < CGRectGetWidth([self fetchVisualFrame]))
            {
                x = CGRectGetMaxX(arrowRect) - textSize.width * 0.5;
            }
            else
            {
                x = descInsetsX;
            }
            
            textRect = CGRectMake(x, CGRectGetMinY(arrowRect) - space - textSize.height, textSize.width, textSize.height);
            break;
        }
        case MJLGuideMaskItemRegionRightBottom:
        {
            /// 右下
            transform = CGAffineTransformMakeScale(1, -1);
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMinY([self fetchVisualFrame]) - space - imgSize.height,
                                   imgSize.width,
                                   imgSize.height);
            
            CGFloat x = 0;
            
            if (textSize.width < CGRectGetWidth([self fetchVisualFrame]))
            {
                x = CGRectGetMinX(arrowRect) - textSize.width * 0.5;
            }
            else
            {
                x = descInsetsX + maxWidth - textSize.width;
            }
            
            textRect = CGRectMake(x, CGRectGetMinY(arrowRect) - space - textSize.height, textSize.width, textSize.height);
            break;
        }
        default:
            break;
    }
    /// 图片 和 文字的动画
    [UIView animateWithDuration:0.3 animations:^{
        
        self.arrowsImageView.transform = transform;
        self.arrowsImageView.frame = arrowRect;
        self.descriLabel.frame = textRect;
    }];
}

/**
 获取可见的视图的frame

 @return frame
 */
- (CGRect)fetchVisualFrame
{
    if (self.currentaIndex >= _count) {
        return CGRectZero;
    }
    
    UIView *view = [self.dataSource guideMaskView:self viewForItemAtIndex:self.currentaIndex];
    CGRect visualRect = [self convertRect:view.frame toView:view.superview];
    //每个item的view与蒙版的边距
    UIEdgeInsets maskInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    if (self.layout && [self.layout respondsToSelector:@selector(guideMaskView:insetForViewAtIndex:)]) {
        [self.layout guideMaskView:self insetForViewAtIndex:self.currentaIndex];
    }
    visualRect.origin.x += maskInsets.left;
    visualRect.origin.y += maskInsets.top;
    visualRect.size.width  -= (maskInsets.left + maskInsets.right);
    visualRect.size.height -= (maskInsets.top + maskInsets.bottom);
    
    return visualRect;
}

/**
 *  获取可见区域的方位
 */
- (MJLGuideMaskItemRegion)fetchVisualRegion
{
    /// 可见区域的中心坐标
    CGPoint visualCenter = CGPointMake(CGRectGetMidX([self fetchVisualFrame]),
                                       CGRectGetMidY([self fetchVisualFrame]));
    /// self.view 的中心坐标
    CGPoint viewCenter   = CGPointMake(CGRectGetMidX(self.bounds),
                                       CGRectGetMidY(self.bounds));
    
    if ((visualCenter.x <= viewCenter.x)    &&
        (visualCenter.y <= viewCenter.y))
    {
        /// 当前显示的视图在左上角
        return MJLGuideMaskItemRegionLeftTop;
    }
    
    if ((visualCenter.x > viewCenter.x)     &&
        (visualCenter.y <= viewCenter.y))
    {
        /// 当前显示的视图在右上角
        return MJLGuideMaskItemRegionRightTop;
    }
    
    if ((visualCenter.x <= viewCenter.x)    &&
        (visualCenter.y > viewCenter.y))
    {
        /// 当前显示的视图在左下角
        return MJLGuideMaskItemRegionLeftBottom;
    }
    
    /// 当前显示的视图在右下角
    return MJLGuideMaskItemRegionRightBottom;
}


#pragma mark -public Method

- (void)show
{
    if (self.dataSource) {
        _count = [self.dataSource numberOfItemsInGuideMaskView:self];
    }
    if (_count < 1) {
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    }];
    self.currentaIndex = 0;
}


- (void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //如果当前下标不是最后一个,则移动到下一个视图
    //如果当前下标是最后一个,则直接返回
    if (self.currentaIndex < _count - 1) {
        self.currentaIndex ++;
    }else{
        [self hide];
    }
}

@end
