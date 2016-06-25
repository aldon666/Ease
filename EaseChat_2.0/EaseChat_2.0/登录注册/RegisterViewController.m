//
//  RegisterViewController.m
//  Chat2
//
//  Created by 杨历彬 on 16/6/15.
//  Copyright © 2016年 Terry. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//照片选择器
@property(nonatomic, strong)UIImagePickerController *imgPicker;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    //初始化照片选择器
    _imgPicker = [[UIImagePickerController alloc]init];
    
    //设置代理
    _imgPicker.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    //获取到我们选择的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _registerImgView.image = image;
    
    //如果图片来源是照相机,把图片存入相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImage), nil);
        
    }
    //隐藏图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)saveImage
{
    
    NSLog(@"图片存进去啦");
    
}

//点击注册按钮响应事件
- (IBAction)didRegisterButtonClick:(UIButton *)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:_userNameTF.text forKey:@"USERNAME"];
    [user setObject:_passwordTF.text forKey:@"PASSWORD"];
    
    NSData *imageData = UIImagePNGRepresentation(_registerImgView.image);
    [user setObject:imageData forKey:@"USERIMAGE"];
    
    NSString *userName = [user objectForKey:@"USERNAME"];
    NSString *password = [user objectForKey:@"PASSWORD"];
    //用户注册的异步block方法
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userName password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } onQueue:dispatch_get_main_queue()];
}
//点击返回按钮响应事件
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击更改头像
- (IBAction)chooseImgAC:(UITapGestureRecognizer *)sender {
    NSLog(@"头像");
    __weak typeof(self) weakSelf = self;
    //添加 AlertSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAC = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //指定资源类型w为相册获取图片
        _imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        _imgPicker.allowsEditing = YES;
        
        [weakSelf presentViewController:_imgPicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cameraAC = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //指定资源类型为照相机
        _imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        _imgPicker.allowsEditing = YES;
        
        [weakSelf presentViewController:_imgPicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    //把响应事件交给弹窗
    [alert addAction:photoAC];
    [alert addAction:cameraAC];
    [alert addAction:cancelAC];
    
    //显示弹窗
    [self presentViewController:alert animated:YES completion:nil];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
