//
//  ViewController.m
//  ImageMetadata
//
//  Created by Murphy Zheng on 16/9/5.
//  Copyright © 2016年 Mieasy. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
    ctrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ctrl.delegate = self;
    
    [self presentViewController:ctrl animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickPhotoAction:(id)sender {
    [self presentImagePicker];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)presentImagePicker {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"[%@ %@] : Not Allowed To Open Photo Library!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    [self accessExifDictionaryFromMediaInfo:info];
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 NSDictionary *imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                 
                 NSDictionary *gpsDic = [imageMetadata objectForKey:@"{GPS}"];
                 NSDictionary *exifDic = [imageMetadata objectForKey:@"{Exif}"];
                 NSDictionary *tiffDic = [imageMetadata objectForKey:@"{TIFF}"];
                 
                 //可交换图像文件
                 NSLog(@"Exif info:--%@",exifDic);
                 //地理位置信息
                 NSLog(@"GPS info:--%@",gpsDic);
                 //图像文件格式
                 NSLog(@"tiff info:--%@",tiffDic);
                 
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 [formatter setDateFormat:@"YYYY:MM:dd hh:mm:ss"];
                 NSString *now = [formatter stringFromDate:[NSDate date]];
                 
                 //写入数据
                 [exifDic setValue:now forKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
                 //kCGImagePropertyExifUserComment
                 [imageMetadata setValue:exifDic forKey:@"{Exif}"];
                 
                 [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:imageMetadata completionBlock:^(NSURL *assetURL, NSError *error) {
                     if (error == nil)
                         NSLog(@"metadata write success!");
                     else
                         NSLog(@"write error:%@",error.userInfo);
                 }];
                 
             }
            failureBlock:^(NSError *error) {
                NSLog(@"read error:%@",error.userInfo);
            }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Exif Getter

- (void)accessExifDictionaryFromMediaInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
        
        NSDictionary *imageInfo = [asset defaultRepresentation].metadata;
        weakSelf.resultTextView.text = [NSString stringWithFormat:@"%@", imageInfo];
        
    } failureBlock:^(NSError *error) {
        
        weakSelf.resultTextView.text = @"Not Allowed To Access Photo Library!";
        
    }];
}

@end
