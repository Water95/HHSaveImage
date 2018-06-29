//
//  HHSaveImage.h
//  封装保存图片工具类
//
//  Created by water on 2018/6/14.
//  Copyright © 2018年 water. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SaveImageCompletionBlock)(BOOL isSuccess,NSError *error);

@interface HHSaveImage : NSObject

/**
 保存图片
 
 如果没有权限，不会block的回调，会有弹窗
 
 @param image 保存的图片
 @param block 成功或者失败的返回。
 */
+ (void)saveImage:(UIImage *)image andViewController:(UIViewController *)controller SaveImageCompletionBlock:(SaveImageCompletionBlock)block;

@end
