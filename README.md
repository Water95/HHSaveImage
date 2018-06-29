
[简书地址](https://www.jianshu.com/p/d19b6ca3fab5)
[githup地址](https://github.com/Water95/HHSaveImage.git)

1 iOS 11 默认拥有读取相册的权限（写过测试代码，已验证），为了做兼容，以前的相册权限自然还要写。

2  NSPhotoLibraryAddUsageDescription和NSPhotoLibraryUsageDescription

如果在iOS11下，写入 一张图片时，在崩溃里有时让你在Info.plist加NSPhotoLibraryUsageDescription，有时加NSPhotoLibraryAddUsageDescription。我们作何选择，建议使用NSPhotoLibraryUsageDescription，读写都有了。

3  获取权限时，下面这种方式不准：
PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus]。
这行代码在iOS11实在是不准，有时一直返回PHAuthorizationStatusNotDetermined，怀疑是没有明显的声明读取权限，所以有问题。

4  iOS 11 下，如何检测权限呢？
使用以下代码

[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
dispatch_async(dispatch_get_main_queue(), ^{
//注意回到主线程，做UI的操作
});
}];

5 同时注意到 PHOTOS_CLASS_AVAILABLE_IOS_TVOS(8_0, 10_0) @interface PHPhotoLibrary ，iOS11后，苹果应该弃用了PHPhotoLibrary，具体使用哪个替换，暂时还没有找到

6 枚举值解释

typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application 
//用户还没用做出选择
PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
// The user cannot change this application’s status, possibly due to active restrictions
//   such as parental controls being in place.

//没有权限使用相册，用户也不能改变权限，可能权限受家长控制的
PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.

//用户禁止使用相册
PHAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
//用户允许使用相册
} PHOTOS_AVAILABLE_IOS_TVOS(8_0, 10_0);

7 保存图片的类已经封装好，点击[githup地址](https://github.com/Water95/HHSaveImage.git)下载

8 提示用户跳转到设置页面

```
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
```

不要再使用                          
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
如果出现 prefs:root，苹果会拒绝

9 使用方法
* 把 HHSaveImage.h 和 HHSaveImage.m拖入你的工程
* 引入头文件，然后一行代码
[HHSaveImage saveImage:image SaveImageCompletionBlock:^(BOOL isSuccess, NSError *error) {
if (isSuccess) {
NSLog(@"成功");
}else{
NSLog(@"失败");
}
}];
