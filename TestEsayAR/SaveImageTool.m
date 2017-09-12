//
//  SaveImageTool.m
//  TestEsayAR
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 shuaigedong. All rights reserved.
//

#import "SaveImageTool.h"

@implementation SaveImageTool

+(id)DefaultSaveImage{
    
     static SaveImageTool *tool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
        
    });
    return tool;
}
//创建文件夹
-(void)createDirectoryWithKey:(NSString*)key{
    
    NSString *documentsPath=[self getDocumentsPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *iosDirectory=[documentsPath stringByAppendingPathComponent:key];
    if (![[NSFileManager defaultManager] fileExistsAtPath:iosDirectory]){
        
        
                BOOL isSuccess=[fileManager createDirectoryAtPath:iosDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        
            if (isSuccess) {
                NSLog(@"创建成功");
            }else{
        
                NSLog(@"创建失败");
            }
        
            }

   }
//获取Documents路径
-(NSString *)getDocumentsPath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    return path;
}
-(void)createFileWithImage:(UIImage *)imge withKey:(NSString*)key{
    [self createDirectoryWithKey:key];
    
    NSString *documentsPath=[self getDocumentsPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *iosDirectory=[documentsPath stringByAppendingPathComponent:key];//文件夹
     NSString *iosPath=[iosDirectory stringByAppendingPathComponent:@"saveLocal"];
    NSData *content=UIImageJPEGRepresentation(imge, .0000005);
    BOOL isSuccess=[fileManager createFileAtPath:iosPath contents:nil attributes:nil];
    if (isSuccess) {
        NSLog(@"创建成功");
    }else{
        
        NSLog(@"创建失败");
    }
    [content writeToFile:iosPath atomically:YES];
   

    
}
//创建文件

-(void)createFileWithurl:(NSString*)url withKey:(NSString * _Nonnull)key{
    [self createDirectoryWithKey:key];
    //获取Documents路径
    //创建文件夹路径
  
    //iosPath = [iosPath stringByAppendingPathExtension:url];
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //下载图片逻辑放到异步执行的block中
    dispatch_async(queue, ^{
        //下载逻辑
         NSURL *imgeurl=[NSURL URLWithString:url];
        //创建图片路径，并把图片命名为ios.jpg
        NSString *documentsPath=[self getDocumentsPath];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSString *iosDirectory=[documentsPath stringByAppendingPathComponent:key];//文件夹
        
        
        NSString *iosPath=[iosDirectory stringByAppendingPathComponent:[imgeurl lastPathComponent]];
        NSData *getFileData = [NSData dataWithContentsOfFile:iosPath];
        if (getFileData != nil){
            return ;
            
        }
        
        
        NSData *fileData = [NSData dataWithContentsOfURL:imgeurl];
        //将fileData存到单例对象字典属性
        if (fileData != nil) {
            
            NSData *content=UIImageJPEGRepresentation([UIImage imageWithData:fileData], .0000005);
            BOOL isSuccess=[fileManager createFileAtPath:iosPath contents:nil attributes:nil];
            if (isSuccess) {
                NSLog(@"创建成功");
            }else{
                
                NSLog(@"创建失败");
            }
            [content writeToFile:iosPath atomically:YES];
           }

    });

  }


-(NSArray *)GetImagesWithKey:(nonnull NSString *)key{
    
  NSString *document =  [self getDocumentsPath];
    
     NSString *iosPath=[document stringByAppendingPathComponent:key];
    
    NSArray *images=[[NSFileManager defaultManager]
                     
                     subpathsOfDirectoryAtPath:iosPath error:nil];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i=0; i<images.count; i++) {
        NSString *image=[iosPath stringByAppendingPathComponent:images[i]];
        [array addObject:image];
        
        
        
    }

    
    
    return array;
    
    
    
 
    
    
}
@end
