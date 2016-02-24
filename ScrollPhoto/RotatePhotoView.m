//
//  RotatePhotoView.m
//  ScrollPhoto
//
//  Created by 金玉龙 on 15/12/28.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import "RotatePhotoView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface RotatePhotoView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, copy) NSArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *imgViewArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation RotatePhotoView

- (instancetype)initWithImages:(NSArray*)images{
    self = [super init];
    if (self) {
        if (images && [images isKindOfClass:[NSArray class]]) {
            self.imagesArray = images;
        }
        [self initCompnent];
        [self layoutCompnent];
        [self updateContentPhotos];
    }
    return self;
}
#pragma mark - Init
-(void)initCompnent{
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.pageCtrl];
    [self initImages];
}

-(void)initImages{
    if (self.imagesArray.count > 0) {
        //有几张图片,加载几个imageView,最大三个
        switch (self.imagesArray.count) {
            default:
            {
                self.rightImageView = [ UIImageView new];
                [self.contentView addSubview:self.rightImageView];
                [self.imgViewArray addObject:self.rightImageView];

                self.middleImageView = [UIImageView new];
                [self.contentView addSubview:self.middleImageView];
                [self.imgViewArray addObject:self.middleImageView];
            }
            case 1:
            {
                self.leftImageView = [UIImageView new];
                [self.contentView addSubview:self.leftImageView];
                [self.imgViewArray addObject:self.leftImageView];
            }
        }
    }
}
#pragma mark - layout
- (void)layoutCompnent{
    WS(weakSelf)
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainScrollView);
        make.height.equalTo(_mainScrollView);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(weakSelf.mas_height).multipliedBy(0.2);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView);
        make.left.equalTo(_bgView);
        make.right.equalTo(_bgView);
        make.height.equalTo(_bgView).multipliedBy(0.5);
    }];
    [self.pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bgView);
        make.bottom.equalTo(_bgView);
        make.height.equalTo(_titleLabel);
    }];
    [self layoutImgs];
    [self layoutIfNeeded];
}

- (void)layoutImgs{
    UIImageView *lastImgView = nil;
    //将第一个和第三个imgView调换位置
    if (self.imgViewArray.count == 3) {
        [self.imgViewArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
    }
    for (UIImageView *imgView in self.imgViewArray) {
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_contentView);
            make.width.equalTo(_mainScrollView.mas_width);
            if (lastImgView) {
                make.left.equalTo(lastImgView.mas_right);
            }else{
                make.left.equalTo(_contentView.mas_left);
            }
        }];
        lastImgView = imgView;
    }
    if (lastImgView) {
        [lastImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentView.mas_right);
        }];
    }
}

#pragma mark - Private Method
- (void)updateContentPhotos{
    if (self.imgViewArray.count > 0) {
        switch (self.imagesArray.count) {
            default:{
                NSInteger preIndex = _currentIndex + 1;
                if (preIndex == self.imagesArray.count) {
                    preIndex = 0;
                }
                NSString *rightUrlString = self.imagesArray[preIndex];//加载下一张
                if (rightUrlString && [rightUrlString isKindOfClass:[NSString class]]) {
                    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightUrlString]];
                }

                NSString *middleUrlString = self.imagesArray[self.currentIndex];//加载当前
                if (middleUrlString && [middleUrlString isKindOfClass:[NSString class]]) {
                    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:middleUrlString]];
                }
                _mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            }
            case 1:
            {
                NSInteger lastIndex = _currentIndex - 1;
                if (lastIndex < 0) {
                    lastIndex = self.imagesArray.count - 1;
                }
                NSString *urlString = self.imagesArray[lastIndex];//加载上一张
                if (urlString && [urlString isKindOfClass:[NSString class]]) {
                    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
                }
            }
        }
        if (self.imagesArray.count == 1) {
            self.mainScrollView.scrollEnabled = NO;
            self.pageCtrl.hidden = YES;
        }
    }if (self.imgViewArray.count != 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%ld",self.currentIndex + 1];
    }else{
        self.titleLabel.text = @"没有图片";
    }
}

- (void)setTimer{
    WS(weakSelf)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
            CGPoint currentOffset = weakSelf.mainScrollView.contentOffset;
            currentOffset.x += kScreenWidth;
            [weakSelf.mainScrollView setContentOffset:currentOffset animated:YES];
    });
    dispatch_resume(self.timer);
}
#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentIndex = 1;
    });
    if (currentOffsetX == kScreenWidth *2) {
        self.currentIndex += 1;
    }else if(currentOffsetX == 0 ){
        self.currentIndex -= 1;
    }
    if ([_delegate respondsToSelector:@selector(rotateScrollViewDidScroll:)]) {
        [_delegate rotateScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(rotateScrollViewDidEndDecelerating:)]) {
        [_delegate rotateScrollViewDidEndDecelerating:scrollView];
    }
}
#pragma mark - Setter and Getter
-(UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        _mainScrollView = [UIScrollView new];
        _mainScrollView.bounces = NO;
        _mainScrollView.bouncesZoom = NO;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [[UIColor colorWithWhite:0.362 alpha:1.000] colorWithAlphaComponent:0.5];
    }
    return  _bgView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIPageControl *)pageCtrl{
    if (_pageCtrl == nil) {
        _pageCtrl = [UIPageControl new];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageCtrl.pageIndicatorTintColor = [UIColor blackColor];
        _pageCtrl.currentPage = _currentIndex;
        _pageCtrl.numberOfPages = self.imagesArray.count;
    }
    return _pageCtrl;
}

-(NSMutableArray *)imgViewArray{
    if (_imgViewArray == nil) {
        _imgViewArray = [[NSMutableArray alloc] init];
    }
    return _imgViewArray;
}

-(void)setTimeInterval:(NSInteger)timeInterval{
    if (_timeInterval != timeInterval && timeInterval > 0) {
        _timeInterval = timeInterval;
        if (timeInterval >= 1) {
            WS(weakSelf)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf setTimer];//启动定时器
            });
        }
        
    }
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    //校准currentIndex,防止越界
    if (_currentIndex != currentIndex) {
        if (currentIndex == self.imagesArray.count) {
            currentIndex = 0;
        }else if(currentIndex < 0){
            currentIndex = self.imagesArray.count - 1;
        }
        _currentIndex = currentIndex;
        [self updateContentPhotos];
        self.mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        self.pageCtrl.currentPage = _currentIndex;
    }
}

-(void)dealloc{
    _timer = nil;
}
@end
