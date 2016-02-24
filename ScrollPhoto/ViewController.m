//
//  ViewController.m
//  ScrollPhoto
//
//  Created by 金玉龙 on 15/12/28.
//  Copyright © 2015年 jinyulong. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "RotatePhotoView.h"
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) RotatePhotoView *rotateView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *photoArray = @[@"http://b.hiphotos.baidu.com/baike/w%3D268/sign=f57988c0f8edab6474724ac6cf37af81/a08b87d6277f9e2f567eeb031c30e924b899f376.jpg",@"http://pic1.nipic.com/2009-01-03/20091319219146_2.jpg",@"http://img.sootuu.com/vector/200801/097/523.jpg",@"http://down.tutu001.com/d/file/20110315/6a70d27e5982b6d7ba303296fb_560.jpg",@"http://images.51cto.com/files/uploadimg/20110809/1450040.jpg",@"http://news.mydrivers.com/img/20121229/c38576f15d144675aa6ffb9a8252ea55.jpg"];
    self.rotateView = [[RotatePhotoView alloc] initWithImages:photoArray];
    self.rotateView.timeInterval = 2;//设置时间间隔启动定时器,不设置默认不启动
    [self.view addSubview:self.rotateView];
    WS(weakSelf)
    [self.rotateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.75);
    }];
}
-(void)dealloc{
    dispatch_source_cancel(_rotateView.timer);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
