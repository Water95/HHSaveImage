//
//  ViewController.m
//  封装保存图片工具类
//
//  Created by water on 2018/6/14.
//  Copyright © 2018年 water. All rights reserved.
//

#import "ViewController.h"
#import "HHSaveImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"3"];
    
    [HHSaveImage saveImage:image SaveImageCompletionBlock:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败");
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
