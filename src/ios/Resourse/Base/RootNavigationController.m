//
//  RootNavigationController.m
//  不一样的烟火
//
//  Created by 吉源 on 16/5/12.
//  Copyright © 2016年 吉源. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //1:Ios7 在自定义leftBarButtonItem情况下的右滑返回问题
    //2:开启了,又导致 ( UINavigationController侧滑滑动返回 卡死问题 )
    //http://strivingboy.github.io/blog/2014/12/07/ios7-interactive-pop-with-custom-back-button/
    __weak RootNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}
- (void) back:(UIButton *)sender {
    [self popViewControllerAnimated:YES];
}
//因为所有的页面都会通过push出来，我们直接在这个方面里面创建我们的返回按钮。这样，每个页面都会附带一个
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //在滑动过程中你会发现如果在pushViewController的动画过程中激活滑动手势会导致crash, 解决方案：
    // 在push的时候关闭手势, 这样就不用担心会激活滑动
    if (self.viewControllers.count >= 1) {
        //开启交互,有的页面有可能要关掉
        [viewController setInteractivePopGestureRecognizerEnable:YES];
        //创建返回按钮
        UIBarButtonItem *backBtnItem = [RootNavigationController getBackBtnWithtarget: viewController ] ;
        //怎么添加到每一个控制器上边呢
        viewController.navigationItem.leftBarButtonItem = backBtnItem;
        
        //self.hidesBottomBarWhenPushed = YES;
        viewController.hidesBottomBarWhenPushed = YES; //用这个
    }
    
    //super 一定要写，要不然就失去push这功能了
    [super pushViewController:viewController animated:animated];
}

+ (UIBarButtonItem *)getBackBtnWithtarget:(UIViewController*)target {
    //创建返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    //添加返回的方法
    [backBtn addTarget:target action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    //返回UIBarButtonItem
    return  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

+ (UIBarButtonItem *)getBackBigBtnWithtarget:(UIViewController *)target {
    //创建返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
    //添加返回的方法
    [backBtn addTarget:target action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    //返回UIBarButtonItem
    return  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

+ (UIBarButtonItem *)getBackHiddenBtn {
    //创建返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.userInteractionEnabled = NO;
    //返回UIBarButtonItem
    return  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

#pragma mark - navi delegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL enable = [viewController getInteractivePopGestureRecognizerEnable];
    //自然, 在当你加载完成下一个viewController之后需要激活滑动手势：
    //http://blog.csdn.net/qq_20518299/article/details/50766221
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = enable;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
