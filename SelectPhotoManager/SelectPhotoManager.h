//
//  SelectPhotoManager.h
//  Schenley
//
//  Created by songshushan on 2018/5/16.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectPhotoManager : NSObject <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

-(void)selectPhotoSuccess:(void(^)(UIImage * image))success faile:(void(^)(NSString * faileStr))faile;

@end
