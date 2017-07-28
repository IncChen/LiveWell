//
//  ScanQRCodeViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/29.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+SDExtension.h"
#import "PopTransition.h"
#import "InteractionTransitionAnimation.h"
#import "InteractiveTrasitionAnimation.h"

static const CGFloat kBorderW = 100;
static const CGFloat kMargin = 30;

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate>{
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    AVCaptureSession *session;
}

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetIv;

@property (strong, nonatomic) PopTransition  *popAnimation;
@property (strong, nonatomic) InteractionTransitionAnimation *popInteraction;
@property (strong, nonatomic) InteractiveTrasitionAnimation *popInteractive;

@end

@implementation ScanQRCodeViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"扫描二维码";

//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_white_cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(toBackAction)];
//    self.navigationItem.leftBarButtonItem = backBtn;
    
    
    //这个属性必须打开否则返回的时候会出现黑边
    self.view.clipsToBounds=YES;
    //1.遮罩
    [self setupMaskView];
    //2.提示文本
    [self setupTipTitleView];
    //3.扫描区域
    [self setupScanWindowView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(12, 24, 36, 36);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_white_cross"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(toCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-100/2.0, 32, 100, 20)];
    titleLabel.text = @"扫描二维码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self startScanning];
    [self resumeAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopScanning];
    [videoPreviewLayer removeFromSuperlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initializes attributes

-(PopTransition *)popAnimation {
    if (!_popAnimation) {
        _popAnimation = [[PopTransition alloc] init];
    }
    return _popAnimation;
}

-(InteractionTransitionAnimation *)popInteraction {
    if (!_popInteraction) {
        _popInteraction = [[InteractionTransitionAnimation alloc] init];
    }
    return _popInteraction;
}

-(InteractiveTrasitionAnimation *)popInteractive {
    if (!_popInteractive) {
        _popInteractive = [[InteractiveTrasitionAnimation alloc] init];
    }
    return _popInteractive;
}

#pragma mark - Private Method

- (void)setupMaskView {
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, self.view.sd_width + kBorderW + kMargin, self.view.sd_width + kBorderW + kMargin+4);
    mask.center = CGPointMake(self.view.sd_width * 0.5, self.view.sd_height * 0.5);
    mask.sd_y = 0;
    
    [self.view addSubview:mask];
}

-(void)setupTipTitleView{
    //1.补充遮罩
    UIView *mask = [[UIView alloc]initWithFrame:CGRectMake(0, _maskView.sd_y+_maskView.sd_height, self.view.sd_width, kBorderW+20)];
    mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask];
    
    //2.操作提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, self.view.sd_height*0.9-kBorderW*2+60, self.view.frame.size.width-kMargin*2, kBorderW)];
    tipLabel.text = @"1.在电脑上访问www.haohaozhu.com，点击右上角【发布文章按钮】；\n2.扫描弹出层上的二维码，点击手机上【确认登录】按钮，即可开始写文章。注意：电脑版暂不支持创建和编辑整屋案例。";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 0;
    tipLabel.font=[UIFont systemFontOfSize:13];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
}

- (void)setupScanWindowView {
    CGFloat scanWindowH = self.view.sd_width - kMargin * 2;
    CGFloat scanWindowW = self.view.sd_width - kMargin * 2;
    _scanWindow = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kBorderW, scanWindowW, scanWindowH)];
    [_scanWindow setImage:[UIImage imageNamed:@"pic_scan"]];
    
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];
    
    _scanNetIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_scan_net"]];
}

- (BOOL)startScanning {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        return NO;
    }
    
    // Initialize the captureSession object.
    session = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [session addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [session addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("CaptureQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    videoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    videoPreviewLayer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
    //开始捕获
    [session startRunning];
    return YES;
}

- (void)stopScanning {
    [session stopRunning];
    session = nil;
}

/**
 恢复动画
 */
- (void)resumeAnimation {
    CAAnimation *anim = [_scanNetIv.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetIv.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        // 3. 要把偏移时间清零
        [_scanNetIv.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetIv.layer setBeginTime:beginTime];
        [_scanNetIv.layer setSpeed:1.0];
    }else{
        CGFloat scanNetIvH = 4;
        CGFloat scanWindowH = self.view.sd_width - kMargin * 2;
        CGFloat scanNetIvW = _scanWindow.sd_width;
        
        _scanNetIv.frame = CGRectMake(0, -scanNetIvH, scanNetIvW, scanNetIvH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 2.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetIv.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetIv];
    }
}


/**
 获取扫描区域的比例关系
 
 @param rect rect
 @param readerViewBounds readerViewBounds
 @return value
 */
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
}

#pragma mark - Actions

//- (void)toBackAction {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)toCancelAction {
    UIViewController *origin = nil;
    if (self.isReturnRootView) {
        origin = self.presentingViewController.presentingViewController;
    } else {
        origin = self.presentingViewController;
    }
    [origin dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0 ];
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self stopScanning];
            NSLog(@"stringValue:%@",metadataObject.stringValue);
        }
        
    }
}

#pragma mark - UINavigationControllerDelegate
/** 返回转场动画实例*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop){
        return self.popAnimation;
    }
    return nil;
}

/** 返回交互手势实例*/
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.popInteractive.isActing ? self.popInteractive : nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController - %@",self.popInteraction.isActing ?@"YES":@"NO");
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"didShowViewController - %@",self.popInteraction.isActing ?@"YES":@"NO");
}

@end
