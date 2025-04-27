//
//  QRScanViewController.m
//  PetHood
//
//  Created by MacPro on 2024/6/4.
//

#import "QRScanViewController2.h"
#import <AVFoundation/AVFCapture.h>
#import "ScaningView.h"

@interface QRScanViewController2 ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic , strong) AVCaptureSession *session;
@property (nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic , strong) ScaningView *scanningView;


@end

@implementation QRScanViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scanningView = [[ScaningView alloc]initWithFrame:self.view.bounds outsideViewLayer:self.view.layer];
    [self.view addSubview:self.scanningView];
    
    [self setupScanningQRCode];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止定时器
    [self.scanningView removeTimer];
}

-(void)setupScanningQRCode {
    //1.获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //3.创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    
    //4.设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描范围（每一个取值0~1 , 以屏幕右上角作为坐标原点）
    output.rectOfInterest = CGRectMake(0.15, 0.24, 0.7, 0.52);
    
    //5.初始化连接对象（会话）
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //5.1 添加会话输出
    [_session addInput:input];
    
    //5.2 添加会话输出
    [_session addOutput:output];
    
    //6.设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    //设置扫码支持的编码格式（如下设置条形码和二维码兼容）
    output.metadataObjectTypes = @[
        AVMetadataObjectTypeQRCode , //二维码
        AVMetadataObjectTypeEAN13Code , //EAN-13 是欧洲地区最闻名的一款条码，多用于超市和其他零售场所的基本产品识别
        AVMetadataObjectTypeEAN8Code ,  // EAN-8 条码是 EAN-13 条码的压缩版
        AVMetadataObjectTypeCode128Code, //它包含字母和数字，以及标点、符号等。它最常用于采购和运输的物流产品，也有可能用于其他多种目的。
    ];
    
    //7.实例化预览图层，传递_session 是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    //8.将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    //9.开始会话
    [_session startRunning];
    
    
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    //1.如果扫描完成 停止扫描
    [self.session stopRunning];
    
    //2.删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    //3.设置界面显示扫描结果
    if(metadataObjects.count>0){
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if([obj.stringValue hasPrefix:@"http"]) {
            NSLog(@"扫描网址为：%@" , obj.stringValue);
        }else {
            NSLog(@"扫描条形码为：%@" , obj.stringValue);
        }
    }
    
    
    
}

@end
