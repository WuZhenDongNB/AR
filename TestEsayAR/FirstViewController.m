//
//  FirstViewController.m
//  TestEsayAR
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 shuaigedong. All rights reserved.
//

#import "FirstViewController.h"
#import "SaveImageTool.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>
@interface FirstViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *iamge;
@property (weak, nonatomic) IBOutlet UITextField *testField;
@property(nonatomic,strong)NSMutableArray *array;

@end

@implementation FirstViewController
- (IBAction)downloader:(id)sender {
  
    NSString *str = self.testField.text;
    NSLog(@"%@",str);
    
    if (str) {
        NSArray *array = @[str];
        [[SaveImageTool DefaultSaveImage]createFileWithurl:str withKey:@"dongdong"];
        
       // [[SaveImageTool DefaultSaveImage]SaveImageWithImages:array Forkey:@"ios"];
        
    }
    
        //字典中没有，并且沙盒中也没有数据;
        //字典中没有下载好的数据; 使用gcd方式下载
        //把下载好的数据存到字典中
        //获取全局队列
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        //下载图片逻辑放到异步执行的block中
        dispatch_async(queue, ^{
            //下载逻辑
            NSURL *url = [NSURL URLWithString:str];
            NSData *fileData = [NSData dataWithContentsOfURL:url];
            //回到主线程更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新界面(加载UIImageView)
                self.iamge.image =[UIImage imageWithData:fileData];
                //self.image1 = [[UIImageView alloc] initWithImage:
            });
        });
    
    
    
}
- (IBAction)Scan:(id)sender {
//  NSArray *array =  [[SaveImageTool DefaultSaveImage]GetImagesWithKey:@"ios"];
//    
//    
    
    
}
- (IBAction)random:(id)sender {
    int x = arc4random() % 9;

    NSString *str = self.array[x];
    
    self.testField.text =str ;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   //下载图片
    self.array = [NSMutableArray arrayWithObjects:
    @"http://img04.tooopen.com/images/20130701/tooopen_10055061.jpg",
    @"http://img06.tooopen.com/images/20170514/tooopen_sy_209849089662.jpg",
    
    @"http://img06.tooopen.com/images/20170514/tooopen_sy_209992214889.jpg",
    @"http://img07.tooopen.com/images/20170316/tooopen_sy_202028912158.jpg",
    @"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg",
    @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1495163018&di=4c1405a0d1caa299ead0720c847da7d2&src=http://scimg.jb51.net/allimg/151231/13-151231162533914.jpg",
    @"http://pic51.nipic.com/file/20141025/11284670_091543201000_2.jpg",
    @"http://image.tupian114.com/20160909/0501467389.jpg",
    @"http://pic2.cxtuku.com/00/06/78/b985c8206148.jpg",
    
                  nil];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLoacaImage:(id)sender {
    
    
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self takePhotoSelectImgWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }];
            
            [alert addAction:action1];
        }
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self selectImgFromPhotoLibraryMaxImagesCount];
        }];
        
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action2];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    
}
-(void)takePhotoSelectImgWithSourceType:(UIImagePickerControllerSourceType)surceType
{
    UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.navigationBar.barTintColor = [UIColor whiteColor];
    imagePickerController.sourceType = surceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *icon = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(icon,nil,nil,nil);
    
//    if (icon !=nil) {
//        //获取图片的名字
//        __block NSString* imageFileName;
//        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
//        
//        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
//        {
//            ALAssetRepresentation *representation = [myasset defaultRepresentation];
//            imageFileName = [representation filename];
//        };
    
    if (icon !=nil) {
        self.iamge.image = icon;
        [[SaveImageTool DefaultSaveImage]createFileWithImage:icon withKey:@"dongdong"];
    }
    
     
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)selectImgFromPhotoLibraryMaxImagesCount{
    
    //从图片库选取图片
    UIImagePickerController *imgPC = [[UIImagePickerController alloc] init];
    imgPC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //imgPC.allowsEditing = YES;
    imgPC.delegate = self;
    
    [self presentViewController:imgPC animated:YES completion:nil];
}

@end
