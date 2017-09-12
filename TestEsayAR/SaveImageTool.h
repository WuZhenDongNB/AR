//
//  SaveImageTool.h
//  TestEsayAR
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 shuaigedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveImageTool : NSObject

+(id _Nonnull)DefaultSaveImage;

-(void)SaveImageWithImages:(nonnull NSArray*)images Forkey:(nonnull NSString *)key;
-(NSArray *_Nullable)GetImagesWithKey:(nonnull NSString *)key;
-(void)createFileWithurl:(NSString*_Nonnull)url withKey:(NSString *_Nonnull)key;
-(void)createFileWithImage:(UIImage *)imge withKey:(NSString*)key;
@end
