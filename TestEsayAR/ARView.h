//
//  ARView.h
//  TestSKScene
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 shuaigedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import <SceneKit/SceneKit.h>
@interface ARView : UIView

@property(nonatomic,strong)AVCaptureSession *session;//创建会话场景
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preview;//预览对象;
@property(nonatomic,strong)AVCaptureMetadataOutput *output;//输出对象;
@property(nonatomic,strong)CMMotionManager *motionManager;
@property(nonatomic,assign)UIInterfaceOrientation orientation;
-(void)addModelFile:(NSURL*)url withPosition:(SCNVector3)positon;


@end
