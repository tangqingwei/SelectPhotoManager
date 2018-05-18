//
//  SelectPhotoManager.m
//  Schenley
//
//  Created by songshushan on 2018/5/16.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import "SelectPhotoManager.h"
#import <Photos/Photos.h>

@interface SelectPhotoManager() 

@property (nonatomic, copy) void (^successBlock)(UIImage *image);
@property (nonatomic, copy) void (^faileBlock)(NSString *faileStr);
@property (nonatomic, strong) UIImagePickerController *ipVc;

@end

@implementation SelectPhotoManager

- (UIImagePickerController *)ipVc{
    if (_ipVc == nil) {
        _ipVc = [[UIImagePickerController alloc] init];
        //设置跳转方式
        _ipVc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //设置是否可对图片进行编辑
        _ipVc.allowsEditing = YES;
        _ipVc.delegate = self;
    }
    return _ipVc;
}

-(void)selectPhotoSuccess:(void(^)(UIImage * image))success faile:(void(^)(NSString * faileStr))faile{
    self.successBlock = success;
    self.faileBlock = faile;
    [self setupAlert];
}

-(void)setupAlert{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takePicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectCameraSuccess:^(UIImage *image) {
            self.successBlock(image);
        } faile:^(NSString *faileStr) {
            self.faileBlock(faileStr);
        }];
    }];
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectAlbumSuccess:^(UIImage *image) {
            
        } faile:^(NSString *faileStr) {
            
        }];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:takePicAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

- (UIViewController *)getCurrentVC {
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:UITabBarController.class]){
        
    }
    if ([vc isKindOfClass:UINavigationController.class]) {
        
    }
    return vc;
}

//拍照
-(void)selectCameraSuccess:(void(^)(UIImage * image))success faile:(void(^)(NSString * faileStr))faile{
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera){
        faile(@"您的设备不支持相机");
        return;
    }
    self.ipVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[self getCurrentVC] presentViewController:self.ipVc animated:YES completion:nil];
}

//相册
-(void)selectAlbumSuccess:(void(^)(UIImage * image))success faile:(void(^)(NSString * faileStr))faile{
    self.ipVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
//        self.faileBlock(@"无权限");
//        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
//            self.faileBlock(@"还没选择");
//        }
//        //return;
//    }
    [[self getCurrentVC] presentViewController:self.ipVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image == nil) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    self.successBlock(image);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    self.faileBlock(@"取消操作");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
