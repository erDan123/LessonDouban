//
//  ViewController.m
//  美图秀秀
//
//  Created by lanou3g on 16/6/22.
//  Copyright © 2016年 ZD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong)UIImagePickerController *imagePicker;
//显示照片
@property(nonatomic, strong)UIImageView *imageView;
//管理上下文
@property(nonatomic, strong)CIContext *context;
//我们要编辑的图像
@property(nonatomic, strong)CIImage *image;
//处理后的图像
@property(nonatomic, strong)CIImage *outPutImage;
//色彩滤镜
@property(nonatomic, strong)CIFilter * colorControlsFilter;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     使用coreImage框架创建滤镜效果的步骤:
     1:创建图像上下文 CIContext
     2:创建滤镜CIFilter
     3:创建过滤原图片的CIImage
     4:调用CIFilter方法
     5:设置滤镜参数(可选)
     6:取得输出图片显示或者保存
     */
    [self initLayout];
    
}

#pragma mark 布局
-(void)initLayout{
    
    self.imagePicker = [[UIImagePickerController alloc]init]
    ;
    self.imagePicker.delegate = self;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 65, 320, 350)];
//    self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    self.navigationItem.title = @"秀秀";;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"打开" style:(UIBarButtonItemStyleDone) target:self action:@selector(openPhoto:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(savePhoto:)];
    //下方控制面板
    UIView *conView = [[UIView alloc]initWithFrame:CGRectMake(0, 420, 320, 120)];
    [self.view addSubview:conView];
    //创建lable饱和度 --->默认为1,大于饱和度增加,小于一则就降低
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    lable1.text = @"饱和度";
    [conView addSubview:lable1];
    UISlider *slider1 = [[UISlider alloc]initWithFrame:CGRectMake(90, 10, 200, 30)];
    slider1.value = 1;
    slider1.minimumValue = 0;
    slider1.maximumValue = 2;
    [conView addSubview:slider1];
    [slider1 addTarget:self action:@selector(changeSlider1:) forControlEvents:(UIControlEventValueChanged)];
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 60, 30)];
    lable2.text = @"亮度";
    [conView addSubview:lable2];
    
    UISlider *slider2 = [[UISlider alloc]initWithFrame:CGRectMake(90, 40, 200, 30)];
    slider2.value = 0;
    slider2.minimumValue = -1;
    slider2.maximumValue = 1;
    [conView addSubview:slider2];
    [slider2 addTarget:self action:@selector(changeSlider2:) forControlEvents:(UIControlEventValueChanged)];
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 60, 30)];
    lable3.text = @"对比度";
    [conView addSubview:lable3];
    
    UISlider *slider3 = [[UISlider alloc]initWithFrame:CGRectMake(90, 70, 200, 30)];
    slider3.value = 0;
    slider3.minimumValue = -1;
    slider3.maximumValue = 1;
    [conView addSubview:slider3];
    [slider3 addTarget:self action:@selector(changeSlider3:) forControlEvents:(UIControlEventValueChanged)];
    //初始化UIContext
    //管理图像上下文
    _context = [CIContext contextWithOptions:nil];
    //取得滤镜
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    
    
}
#pragma mark ---打开系统相册
-(void)openPhoto:(UIBarButtonItem *)sender{
    [self presentViewController:self.imagePicker animated:YES completion:^{
        
        NSLog(@"打开~\(≧▽≦)/~啦啦啦");
    }];
    
    
}

-(void)savePhoto:(UIBarButtonItem *)sender{
    //保存图片
    UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:@"保存成功" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
    [alert show];
    
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    //取得图片
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = selectImage;
    //初始化CIImage源图像
    self.image = [CIImage imageWithCGImage:selectImage.CGImage];
    [self.colorControlsFilter setValue:self.image forKey:@"inputImage"];//设置滤镜输入图片
    
}


-(void)changeSlider1:(UISlider *)sender{
    [self.colorControlsFilter setValue:[NSNumber numberWithFloat:sender.value] forKey:@"inputSaturation"];
    
    [self setImage];
    
}
-(void)changeSlider2:(UISlider *)sender{
    
    [self.colorControlsFilter setValue:[NSNumber numberWithFloat:sender.value] forKey:@"inputBrightness"];
    
    [self setImage];
}

-(void)changeSlider3:(UISlider *)sender{
    
    [self.colorControlsFilter setValue:[NSNumber numberWithFloat:sender.value] forKey:@"inputContrast"];
    
    [self setImage];
    
    
    
}
#pragma mark 将输出的图像展示到UIImageView上
-(void)setImage{
//得到输出的图像
    CIImage *outPutImage = [_colorControlsFilter outputImage];
    CGImageRef temp = [_context createCGImage:outPutImage fromRect:[outPutImage extent]];
    _imageView.image = [UIImage imageWithCGImage:temp];

}


























































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
