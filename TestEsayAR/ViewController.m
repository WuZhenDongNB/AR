//
//  ViewController.m
//  TestEsayAR
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 shuaigedong. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ARView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end


 static dispatch_once_t onceToken;
@implementation ViewController
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds];
    self.glView.imageKey = @"dongdong";
    NSLog(@"hahah ");
    [self.view addSubview:self.glView];
    [self.glView setOrientation:[UIApplication sharedApplication].statusBarOrientation];
       
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(abc) name:@"arSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(abcabc) name:@"arFail" object:nil];
    [self.view bringSubviewToFront:self.backBtn];
}
-(void)abc{
   [self.glView stop];
   [self.glView removeFromSuperview];
   
  [self creatScenKitView];
        

}
-(void)abcabc{
    
    NSLog(@"扫描失败");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   ((AppDelegate *)[[UIApplication sharedApplication]delegate]).active=YES;
    [self.glView start];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.glView stop];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.glView resize:self.view.bounds orientation:[UIApplication sharedApplication].statusBarOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.glView setOrientation:toInterfaceOrientation];
}
- (void)creatScenKitView{
    
    
    ARView *view = [[ARView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    NSURL *a = [[NSBundle mainBundle]URLForResource:@"boss_attack" withExtension:@"dae"];
    
    //NSString *str  = [[NSBundle mainBundle]pathForResource:@"boss_attack" ofType:@"dae"];
    // NSURL *url = [NSURL URLWithString:str];
    
    
    [view addModelFile:a withPosition:SCNVector3Make(0, 0, -1000)];
    
    
    [self.view bringSubviewToFront:self.backBtn];
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}



@end
