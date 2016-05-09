//
//  ZYSideslipMenuViewController.h
//  ZYSideslip
//
//  Created by 曾宇 on 16/5/8.
//  Copyright © 2016年 qiongYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYSideslipMenuViewController : UIViewController
/*!
 *  @brief 提供的单例
 *
 */
+(instancetype)shareController;
/*!
 *  @brief 侧滑多大
 */
@property (nonatomic, assign) CGFloat moveX;

/*!
 *  @brief 菜单控制器
 */
@property (nonatomic, strong) UIViewController *PIMController;

/*!
 *  @brief 菜单栏是否能在尽头移动
 */
@property (nonatomic, assign) BOOL isEndMove;
/*!
 *  @brief 给导航栏push的方法
 *
 *  @param vc 要push的控制器
 */
+(void)pushController:(UIViewController*)vc;

@end
