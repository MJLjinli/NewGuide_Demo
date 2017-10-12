//
//  MJLGuideMaskView.h
//  NewGuide_Demo
//
//  Created by 马金丽 on 17/10/10.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJLGuideMaskView;
/**
 数据源协议
 */
@protocol MJLGuideMaskViewDataSouce <NSObject>

@required
/**
  item的个数
 */
- (NSInteger)numberOfItemsInGuideMaskView:(MJLGuideMaskView *)guideMaskView;

/**
 每个item的view
 */
- (UIView *)guideMaskView:(MJLGuideMaskView *)guideMaskView viewForItemAtIndex:(NSInteger)index;

/**
 每个item的文字
 */
- (NSString *)guideMaskView:(MJLGuideMaskView *)guideMaskView descriptionForItemAtIndex:(NSInteger)index;

@optional
/**
 *  每个 item 的文字颜色：默认白色
 */
- (UIColor *)guideMaskView:(MJLGuideMaskView *)guideMaskView colorForDescriptionAtIndex:(NSInteger)index;

/**
 *  每个 item 的文字字体：默认 [UIFont systemFontOfSize:13]
 */
- (UIFont *)guideMaskView:(MJLGuideMaskView *)guideMaskView fontForDescriptionAtIndex:(NSInteger)index;


@end


/**
 UI布局协议
 */
@protocol MJLGuideMaskViewLayout <NSObject>

@optional
/**
 *  每个 item 的 view 蒙板的圆角：默认为 5
 */
- (CGFloat)guideMaskView:(MJLGuideMaskView *)guideMaskView cornerRadiusForViewAtIndex:(NSInteger)index;

/**
 *  每个 item 的 view 与蒙板的边距：默认 (-8, -8, -8, -8)
 */
- (UIEdgeInsets)guideMaskView:(MJLGuideMaskView *)guideMaskView insetForViewAtIndex:(NSInteger)index;

/**
 *  每个 item 的子视图（当前介绍的子视图、箭头、描述文字）之间的间距：默认为 20
 */
- (CGFloat)guideMaskView:(MJLGuideMaskView *)guideMaskView spaceForItemAtIndex:(NSInteger)index;

/**
 *  每个 item 的文字与左右边框间的距离：默认为 50
 */
- (CGFloat)guideMaskView:(MJLGuideMaskView *)guideMaskView horizontalInsetForDescriptionAtIndex:(NSInteger)index;
@end

@interface MJLGuideMaskView : UIView
/**
 箭头图片
 */
@property(nonatomic,strong)UIImage *arrowImage;

/**
 蒙版背景颜色:默认 黑色
 */
@property(nonatomic,strong)UIColor *maskBackgroundColor;
/**
 蒙版透明度:默认 0.7
 */
@property(nonatomic,assign)CGFloat maskAlpha;

@property(nonatomic,weak)id<MJLGuideMaskViewDataSouce>dataSource;
@property(nonatomic,weak)id<MJLGuideMaskViewLayout>layout;


/**
 根据数据源创建蒙版

 @param dataSource 数据源协议
 @return self
 */
- (instancetype)initWithDataSource:(id<MJLGuideMaskViewDataSouce>)dataSource;


/**
 显示
 */
- (void)show;

@end
