//
//  ARView.m
//  TestSKScene
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 shuaigedong. All rights reserved.
//

#import "ARView.h"

//#ifdef DEBUG
////#define  WCLog(...) NSLog(__VA_ARGS__)
//#define WCLog(...) NSLog(@"%s\n %@ \n\n",__func__,[NSString stringWithFormat:__VA_ARGS__])
//#else
//
//#endif


@interface ARView ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


{
    
    SCNView *_scnView;
    SCNNode *_eyeNode;
    
    
}
@property(nonatomic,assign)SCNVector3 begainLocation;
@property(nonatomic,strong)SCNNode *playNode;
@property(nonatomic,assign,getter=isExiet)BOOL exit;


@end


@implementation ARView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self  = [super initWithFrame:frame];
    if (self) {
        //   [self getBegainLocation];
        // [self testgetBegainLocation];
        _scnView = [SCNView new];
        _eyeNode = [SCNNode node];
        _eyeNode.camera = [SCNCamera camera];
        _eyeNode.camera.automaticallyAdjustsZRange = YES;
        self.exit = NO;
        
        [self setup];
    }
    
    return self;
    
    
}
-(void)setup{
    
    [self initCameraView ];
    [self initScene];
    //[self testinitMotionManger];
    [self getBegainLocation];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //    });
    //[self initMotionManger];
    [self initMotionManger];
}
-(void)getBegainLocation{
    
    CMMotionManager *motionManager = [CMMotionManager new];
    motionManager.gyroUpdateInterval = 60;
    motionManager.deviceMotionUpdateInterval = 1/30.0;
    motionManager.showsDeviceMovementDisplay = YES;
    NSOperationQueue *quere = [NSOperationQueue mainQueue];
    
    
    
    [ motionManager startDeviceMotionUpdatesToQueue:quere withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
        CMAttitude *tude = motion.attitude;
        SCNVector3 vector = SCNVector3Zero;
        vector.x = tude.pitch;
        vector.y = tude.roll;
        vector.z = tude.yaw;
        NSLog(@"X = %.04f",tude.pitch);
        NSLog(@"Y = %.04f",tude.roll);
        NSLog(@"Z = %.04f",tude.yaw);
        if (!self.isExiet) {
            _begainLocation = vector;
            self.exit = YES;
            [motionManager stopGyroUpdates];
            [motionManager stopDeviceMotionUpdates];
            return ;
        }
        
    }];
    
}

-(void)initCameraView{
    //1创建捕捉对象;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //1.1创建输入对象;
    AVCaptureDeviceInput *input  = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    //1.2创建输出对象;
    _output = [AVCaptureMetadataOutput new];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //1.3会话场景;
    _session = [AVCaptureSession new];
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    
    //1.4创建预览视图;
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.bounds;
    [self.layer addSublayer:preview];
    [_session startRunning];
}

-(void)initScene{
    _scnView.backgroundColor = [UIColor clearColor];
    _scnView.frame = self.frame;
    [self addSubview:_scnView];
    
    _scnView.scene = [SCNScene scene];
    
    
    [_scnView.scene.rootNode addChildNode:_eyeNode];
    
    
}

-(void)initMotionManger{
    
    _motionManager = [CMMotionManager new];
    _motionManager.gyroUpdateInterval = 60;
    _motionManager.deviceMotionUpdateInterval = 1/30.0;
    _motionManager.showsDeviceMovementDisplay = YES;
    NSOperationQueue *quere = [NSOperationQueue mainQueue];
    
    [ _motionManager startDeviceMotionUpdatesToQueue:quere withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
        CMAttitude *tude = motion.attitude;
        SCNVector3 vector = SCNVector3Zero;
        if (UIDeviceOrientationIsPortrait(UIDeviceOrientationPortrait)) {
            
            //            CGFloat rotation = sqrt(pow(tude.roll, 2.0f) + pow(tude.yaw, 2.0f) + pow(tude.pitch, 2.0f));
            //          vector.x = rotation;
            vector.x = tude.pitch;
            vector.y = tude.roll;
            vector.z = tude.yaw;
            
        }else if (UIDeviceOrientationIsPortrait(UIDeviceOrientationLandscapeLeft)){
            
            vector.x = tude.pitch;
            vector.y = tude.roll;
        }
        else{
            
            vector.x = tude.pitch;
            vector.y = tude.roll;
            
        }
        vector.z =tude.yaw;
        SCNVector3 rotation = SCNVector3Zero;
        // rotation.x = -(_begainLocation.x - vector.x);
        rotation.y = -(_begainLocation.y  - vector.y);
        rotation.z = -(_begainLocation.z -vector.z);
        
        //_eyeNode.position = vector;
        // [_eyeNode runAction:[SCNAction rotateByX:vector.x y:vector.y z:vector.z duration:0]];
        
        _eyeNode.eulerAngles =rotation;
        
    }];
    
}

-(void)addModelFile:(NSURL*)url withPosition:(SCNVector3)positon{
    NSError *error = nil;
    SCNScene *scen = [SCNScene sceneWithURL:url options:nil error:&error];
    //scnnode 是什么东西;
    //scen.background.contents = [UIImage imageNamed: @"art.scnassests/texture.png"];
    
    SCNNode *node = scen.rootNode;
    
    node.position = positon;
    [node runAction:[SCNAction rotateByX:5 y:0 z:0 duration:5]];
    _playNode = node;
    
    //[node runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_scnView.scene.rootNode addChildNode:node];
}
-(void)dealloc{
    
    
    //WCLog(@"销毁了");
    
}

@end
