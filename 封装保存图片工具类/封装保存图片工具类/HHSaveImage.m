//
//  HHSaveImage.m
//  封装保存图片工具类
//
//  Created by water on 2018/6/14.
//  Copyright © 2018年 water. All rights reserved.
//

#import "HHSaveImage.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HHSaveImage ()<UIAlertViewDelegate>
@property (nonatomic,copy) SaveImageCompletionBlock saveBlock;
@property (nonatomic,strong) UIViewController *controller;
@end

@implementation HHSaveImage

+ (void)saveImage:(UIImage *)image andViewController:(UIViewController *)controller SaveImageCompletionBlock:(SaveImageCompletionBlock)block
{
    HHSaveImage *saveTool = [[HHSaveImage alloc] init];
    saveTool.saveBlock = block;
    saveTool.controller = controller;
    [saveTool saveImageToPhotoAlbum:image];
}

- (void)saveImageToPhotoAlbum:(UIImage *)image
{
    // 判断版本号，根据版本号走不同的操作
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self belowEightVersionAction:image];
    }else{
        [self overEightVersionAction:image];
    }
}
//iOS 8.0以下的操作
- (void)belowEightVersionAction:(UIImage *)image{
    ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        //无权限
        [self showNoAuthorityAlerView];
    }else{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
}
//iOS 8.0含8.0以上的操作
- (void)overEightVersionAction:(UIImage *)image{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                [self showNoAuthorityAlerView];
            }else{
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            }
        });
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        if (self.saveBlock) {
            self.saveBlock(YES, nil);
        }
    }else{
        if (self.saveBlock) {
            self.saveBlock(NO, error);
        }
    }
}
//没有权限的提示
- (void)showNoAuthorityAlerView{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请进入iPhone的设置 - 隐私 - 相册 选项，允许访问您的手机相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alertView show];
        
    }
    else{
        
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请进入iPhone的设置 - 隐私 - 相册 选项，允许访问您的手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction  actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self.controller presentViewController:alertController animated:NO completion:^{
        
    }];
        
    }
}

@end
