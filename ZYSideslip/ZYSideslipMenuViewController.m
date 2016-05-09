//
//  ZYSideslipMenuViewController.m
//  ZYSideslip
//
//  Created by 曾宇 on 16/5/8.
//  Copyright © 2016年 qiongYou. All rights reserved.
//

#import "ZYSideslipMenuViewController.h"
#import "ZYqqViewController.h"

@interface ZYSideslipMenuViewController ()
/*!
 *  @brief 个人信息view
 */
@property (nonatomic, strong) UIView *PIMView;

/*!
 *  @brief 拖动手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
/*!
 *  @brief 轻扫手势
 */
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;

/*!
 *  @brief 遮罩
 */
@property (nonatomic, strong) UIButton *shade;
/*!
 *  @brief 导航控制器
 */

@property (nonatomic, strong) UINavigationController *nav;


@property (nonatomic, strong) UIViewController *textVC;
@end

@implementation ZYSideslipMenuViewController

//内部提供的单例
+(instancetype)shareController{
    static ZYSideslipMenuViewController * me = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc]init];
    });
    return me;
}

#pragma mark -----给外部提供的方法
/*!
 *  @brief 给
 *
 *  @param vc 要push的控制器
 */
+(void)pushController:(UIViewController*)vc{
    
    ZYSideslipMenuViewController * sidesVc = [self shareController];
//    [UIApplication sharedApplication].keyWindow.rootViewController = sidesVc;
    [sidesVc navigationRegression];
//    [sidesVc clickBarButton];
    [sidesVc.navigationController pushViewController:vc animated:YES];
//    sidesVc.textVC = vc;
    [[NSNotificationCenter defaultCenter]addObserver:sidesVc selector:@selector(pushCotrloller:) name:nil object:sidesVc.navigationController];
    
}

#pragma mark -----view的生命周期
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self prepareUI];
    [self.view setUserInteractionEnabled:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.isEndMove = NO;
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton)];

    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.leftBarButtonItem = barButton;

    //设置导航控制器
    self.nav = self.navigationController;
    [self.view addSubview:self.shade];
    
    self.shade.frame = self.view.bounds;
    
    //添加轻扫手势
    [self.view addGestureRecognizer:self.swipeGesture];
    self.swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
    //设置阴影
    [self setupShadow];
}

-(void)prepareUI{
        [self.view addSubview:self.shade];
    
        self.shade.frame = self.view.bounds;
        //设置阴影
        [self setupShadow];
}

/*!
 *  @brief 设置阴影
 */
-(void)setupShadow{
    self.view.layer.shadowRadius = 10;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowOpacity = 0.5;
    
}


/*!
 *  @brief 导航栏点击
 */
-(void)clickBarButton{
    
    [[UIApplication sharedApplication].keyWindow insertSubview:self.PIMView atIndex:0];
//    [self addChildViewController:[[KCcHomePIMViewController alloc]init]];
    
    CGRect frame = self.view.frame;
    
    if (frame.origin.x == self.moveX) {
        //这个控制器回到原位
        [self navigationRegression];
        NSLog(@"%@",[[[[UIApplication sharedApplication].keyWindow subviews] lastObject] class]);
    }else{
        NSLog(@"导航栏点击");

        self.shade.hidden = NO;
        [self.view addSubview:self.navigationController.navigationBar];
        [UIApplication sharedApplication].keyWindow.rootViewController = self.PIMController;
        [[UIApplication sharedApplication].keyWindow insertSubview:self.view atIndex:1];
        //            添加手势
        [self.view addGestureRecognizer:self.panGesture];
        [self moveHomeView:self.moveX completion:nil];
    }
    
}
/*!
 *  @brief home控制器回归原位
 *
 */
-(void)navigationRegression{
    [self moveHomeView:0 completion:^() {
        self.shade.hidden = YES;
        
        [UIApplication sharedApplication].keyWindow.rootViewController = self.nav;
        [[UIApplication sharedApplication].keyWindow insertSubview:self.PIMView atIndex:0];
        [self.navigationController.navigationBar removeFromSuperview];
        
        //取出UILayoutContainerView ,把navigationBar从view移除 重新把navigationBar 添加到 UILayoutContainerView上
        UIView *layoutContainerView = [[[UIApplication sharedApplication].keyWindow subviews] lastObject];
        [layoutContainerView addSubview:self.nav.navigationBar];
        //       把navigitionBar 移到最上面
        [layoutContainerView bringSubviewToFront:self.nav.navigationBar];
        //移除手势
        if (self.isEndMove == NO ) {
            [self.view removeGestureRecognizer:self.panGesture];
        }
        
    }];
}

/*!
 *  @brief 移动view
 */
-(void)moveHomeView:(CGFloat)offX completion:(void (^)())completionM{
    
    CGRect frame = self.view.frame;
    frame.origin.x = offX;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.view.frame = frame;
        
    }completion:^(BOOL finished) {
        if (completionM != NULL) {
            completionM();
        }
    }];
}
#pragma mark -----各种手势
/*!
 *  @brief 拖拽手势
 *
 */
-(void)panGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer{
//    NSLog(@"ewwew");
    CGPoint panPoint=[panGestureRecognizer translationInView:self.view];
    if (self.view.frame.origin.x > self.moveX) {
        panPoint.x = 0;
    }//到最右边的时候
    else if(self.view.frame.origin.x < 1){
        panPoint.x = 0;
    }
    self.view.transform= CGAffineTransformTranslate(self.view.transform, panPoint.x, 0);
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    if (panGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        
        //在左半边松手
        if(self.view.frame.origin.x < self.moveX * 0.7){
            
            [self moveHomeView:0 completion:^{
                [self navigationRegression];
            }];
            
        }else{
            
            [self moveHomeView:self.moveX completion:nil];
        }
    }
}
//轻扫手势
-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer*)swiperGesture{
    
    [self clickBarButton];
}

#pragma mark -----代理Block通知事件
/*!
 *  @brief 在另外一个控制器里面push出来一个控制器
 *
 */
-(void)pushCotrloller:(NSNotification*)noti{
    static NSInteger a = 0;
    if ([noti.userInfo[@"UINavigationControllerNextVisibleViewController"] isKindOfClass:[self class]]) {
        [self clickBarButton];
        a++;
        //        有两次通知的时候删除通知
        if (a%2 == 0) {
            [[NSNotificationCenter defaultCenter]removeObserver:self];

        }
    }
}





//拖拽手势
-(UIPanGestureRecognizer *)panGesture{
    if (_panGesture == nil) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        
    }
    return _panGesture;
}
//轻扫手势
-(UISwipeGestureRecognizer *)swipeGesture{
    if (_swipeGesture == nil) {
        _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    
    }
    return _swipeGesture;
}
////PIM控制器
//-(KCcHomePIMViewController *)PIMController{
//    if (_PIMController == nil) {
//        _PIMController = [[KCcHomePIMViewController alloc] init];
//        _PIMController.homeController = self;
//    }
//    return _PIMController;
//}

//菜单view
-(UIView *)PIMView{
    if (_PIMView == nil) {
        _PIMView = self.PIMController.view;
        //         _PIMView =[[KCcHomePIMViewController alloc]init].view;
    }
    return _PIMView;
}
//遮罩按钮
-(UIButton *)shade{
    if (_shade == nil) {
        _shade = [[UIButton alloc] init];
        _shade.hidden = YES;
//        _shade.backgroundColor = [UIColor lightGrayColor];
        [_shade addTarget:self action:@selector(clickBarButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shade;
}

@end





