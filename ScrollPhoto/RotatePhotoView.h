//
//  RotatePhotoView.h
//  ScrollPhoto
//
//  Created by 金玉龙 on 15/12/28.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WS(weakSelf) __weak typeof(&*self) weakSelf = self;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol RotatePhotoViewDelegate <NSObject>
//正在滚动代理
-(void)rotateScrollViewDidScroll:(UIScrollView*)scrollView;
//即将结束滚动代理
-(void)rotateScrollViewDidEndDecelerating:(UIScrollView*)scrollView;

@end

@interface RotatePhotoView : UIView

@property (nonatomic, assign)id<RotatePhotoViewDelegate>delegate;

@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger timeInterval;//自动轮播时间间隔,设置时间间隔启动定时器,不设置默认不启动

- (instancetype)initWithImages:(NSArray* _Nullable )images;

@end
