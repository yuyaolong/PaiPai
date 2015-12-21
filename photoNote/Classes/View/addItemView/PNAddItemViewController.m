//
//  PNAddItemViewController.m
//  photoNote
//
//  Created by yuyaolong on 15/5/3.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNAddItemViewController.h"
#import "PNTools.h"
#import "MyImagePickerController.h"
#import "collectionPickerViewController.h"
#import "PNCollectionView.h"
#import "LineLayout.h"
#import "StackLayout.h"
#import "CircleLayout.h"
#import "filtedImage.h"
#import "ThumbNailImage.h"
#import "soundPlayer.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define dateForm  @"EEE yy-MM-dd H:mm"
#define reminderDateForm @"EEE yy-MM-dd H:mm     ⏰"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
@interface PNAddItemViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,collectionPickerDelegate,myImagePickerControllerDelegate,PNCollectionDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *inputToolBar;
@property (weak, nonatomic) IBOutlet UILabel *creatDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagLabel;
@property (weak, nonatomic) IBOutlet UITextField *courseLabel;
@property (weak, nonatomic) IBOutlet UITextField *reminderTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property(strong,nonatomic) NSArray *textFieldArray;

@property (weak, nonatomic) IBOutlet PNCollectionView *selectedImagesSelection;

@property (weak, nonatomic) IBOutlet UIButton *soundCancelBtn;
@property (weak, nonatomic) IBOutlet UISwitch *isFilterUseSwitch;
@property (weak, nonatomic) IBOutlet UILabel *isFileterUseLabel;

@property (strong,nonatomic)NSMutableArray *selectedFileImages; //存储照相机拍摄的原片
@property (strong,nonatomic)NSMutableArray *selecetedThumbImages; //存储所有照片的缩略图
@property (strong,nonatomic)NSDate *remindeDate;

@property (strong,nonatomic)NSString *UUID;

@property(strong,nonatomic) soundPlayer *sPlayer;
@property(strong,nonatomic) NSString* soundFilePath;

@end

@implementation PNAddItemViewController


- (NSMutableArray *)selectedFileImages
{
    if (!_selectedFileImages) {
        _selectedFileImages = [NSMutableArray array];
    }
    return _selectedFileImages;
}

- (NSMutableArray *)selecetedThumbImages
{
    if (!_selecetedThumbImages) {
        _selecetedThumbImages = [NSMutableArray array] ;
    }
    return _selecetedThumbImages;
}

//修改item需要倒入数据
- (void)prepareForEditItemDataWithItem:(PNItem *)item
{
    self.selectedFileImages = [[PNTools getAllImagesForOneItem:item] mutableCopy];
    for (UIImage *fileImage in self.selectedFileImages) {
        [self.selecetedThumbImages addObject:[ThumbNailImage instanceWith:fileImage]];
    }
    self.showItem = item;
}


- (NSArray *)textFieldArray
{
    if (!_textFieldArray) {
        _textFieldArray = [[NSArray alloc] initWithObjects:self.memoTextView,self.courseLabel,self.tagLabel,self.reminderTextField, nil];
    }
    return _textFieldArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImagesSelection.delegate =self;
    self.UUID = [PNTools getUUID];
    self.soundFilePath = [PNTools getItemSoundFilePathByUUID:self.UUID];
}



-(void)setupKeybordNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFramChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self UISetUp];
    
    
    //设置监听键盘的事件
    [self setupKeybordNotification];
    [self.selectedImagesSelection initPNCollectionViewWithImages:self.selecetedThumbImages];
    [self.selectedImagesSelection changeLayout:[[LineLayout alloc]init]];
    
    if (self.showItem != nil) {
        self.courseLabel.text = self.showItem.courseName;
        self.tagLabel.text = self.showItem.tag;
        self.memoTextView.text  = self.showItem.memo;
        self.creatDateLabel.text =  [[PNTools sharedPNTools] dateTostring:self.showItem.dateCreated withFormString:dateForm];
        self.reminderTextField.text = [[PNTools sharedPNTools] dateTostring:self.showItem.dateReminder withFormString:reminderDateForm];
        self.UUID = self.showItem.itemKey;
        self.soundFilePath = [PNTools getItemSoundFilePathByUUID:self.showItem.itemKey];
    }
    
    if ([PNTools checkSoundFileIsExist:self.soundFilePath]) {
        [self setupSoundPlayer];
        self.soundCancelBtn.alpha = 1;
        self.sPlayer.alpha = 1;
    }
    else
    {
        self.soundCancelBtn.alpha = 0;
    }
    
    NSLog(@"%@",self.UUID);
}


//如果有录音文件就初始化播放器
-(void)setupSoundPlayer
{
    soundPlayer *sPlayer = [soundPlayer instanceSelf];
    sPlayer.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-100);
    self.sPlayer = sPlayer;
    sPlayer.URLForPlay = [NSURL fileURLWithPath:self.soundFilePath];
    [self.view addSubview:self.sPlayer];
    [sPlayer setSoundPlayerUI];
}

//删除声音文件
-(IBAction)deleteSoundFile:(UIButton *)sender
{
    if([PNTools checkSoundFileIsExist:self.soundFilePath])
    {
        [self.sPlayer resetPlayer];
        [UIView animateWithDuration:0.25 animations:^{
            self.sPlayer.alpha = 0;
            self.soundCancelBtn.alpha = 0;
            
        }completion:^(BOOL finished) {
            [self.sPlayer removeFromSuperview];
            [PNTools deleteSoundFileByPath:self.soundFilePath];
        }];
    }
}




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.sPlayer resetPlayer];
}

-(void)UISetUp
{
    self.reminderTextField.inputView = self.datePicker;
    self.reminderTextField.inputAccessoryView = self.inputToolBar;
    self.creatDateLabel.text = [[PNTools sharedPNTools] dateTostring:[NSDate date] withFormString:dateForm];
    
    self.memoTextView.inputAccessoryView = self.inputToolBar;
    self.courseLabel.inputAccessoryView = self.inputToolBar;
    self.tagLabel.inputAccessoryView = self.inputToolBar;    
}

- (IBAction)doneEditDate:(UIBarButtonItem *)sender {
    if ([self.reminderTextField isFirstResponder]) {
        self.reminderTextField.text = [[PNTools sharedPNTools] dateTostring:self.datePicker.date withFormString:reminderDateForm];
        self.remindeDate = self.datePicker.date;
        NSLog(@"%@",self.remindeDate);
        [self.reminderTextField resignFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
    }
}

//cancel按钮后
- (IBAction)dismissSelf:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Do you really want Cancel" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alert show];
}

//alert委托的方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"YES"]) {
        
        [self deleteSoundFile:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - 设置键盘的函数

//返回－1代表没有找到第一响应者
-(int)getCurrentResponder
{
    for (int i=0; i<self.textFieldArray.count; i++) {
        if ([self.textFieldArray[i] isFirstResponder]) {
            return i;
        }
    }
    return -1;
}

//undo button
- (IBAction)undoText:(UIBarButtonItem *)sender {
    int currentRPIndex = [self getCurrentResponder];
    [self.textFieldArray[currentRPIndex] setText:@""];
    [self.textFieldArray[currentRPIndex] resignFirstResponder];
    
}

//next button
- (IBAction)nextText:(UIBarButtonItem *)sender {
    int currentRPIndex = [self getCurrentResponder];
    //注销第一响应使键盘的fram变化从而 使监听到键盘fram的变化
    [self.textFieldArray[currentRPIndex] resignFirstResponder];
    
    int nextRPIndex = currentRPIndex + 1;
    if (nextRPIndex <self.textFieldArray.count) {
        [self.textFieldArray[nextRPIndex] becomeFirstResponder];
    }
    
}
//before button
- (IBAction)previousText:(UIBarButtonItem *)sender {
    int currentRPIndex = [self getCurrentResponder];
    [self.textFieldArray[currentRPIndex] resignFirstResponder];
    
    int previousRPIndex = currentRPIndex - 1;
    if (previousRPIndex > -1) {
        [self.textFieldArray[previousRPIndex] becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//键盘的变化
-(void)kbFramChange:(NSNotification *)notify
{
    
    //获取键盘改变后的Y值
    CGRect kbEndFrm =  [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    //获取当前响应者的MaxY
    int currentFbIndex = [self getCurrentResponder];
    CGFloat textMaxY = CGRectGetMaxY([self.textFieldArray[currentFbIndex] frame]);
    
    //NSLog(@"%lf : %lf",textMaxY,kbEndY);
    
    if (textMaxY >kbEndY) {
        [UIView animateWithDuration:0.4 animations:^{
             self.view.transform = CGAffineTransformMakeTranslation(0, kbEndY-textMaxY);
        }];
       
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }

}


#pragma mark - 取照片

- (IBAction)takeImage:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromToolbar:self.toolbar];
    //[actionSheet showFromBarButtonItem:[self.toolbar.items firstObject] animated:YES]; // actionSheet弹出位置
}
//动作表单的选择
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{    
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //添加自定义的相机
                MyImagePickerController *imagePickerC = [[MyImagePickerController alloc] init];
                imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerC.delegate = self;
                imagePickerC.mydelegate = self;
                
                imagePickerC.soundSavePath = self.UUID;//用item的key作为音频文件的存储
                
                NSString *desired = (NSString *)kUTTypeImage;
                if ([[UIImagePickerController availableMediaTypesForSourceType:imagePickerC.sourceType]containsObject:desired]) {
                    imagePickerC.mediaTypes = @[desired];
                }
                imagePickerC.mediaTypes = @[(NSString *)kUTTypeImage];
                imagePickerC.allowsEditing = NO;
                imagePickerC.showsCameraControls = NO;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [self presentViewController:imagePickerC animated:YES completion:nil];
                    }];
                }
                else{
                    
                    [self presentViewController:imagePickerC animated:YES completion:nil];
                }
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"哎呀，当前设备没有摄像头。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 1:
        {
            collectionPickerViewController *collectionPickerVC = [[collectionPickerViewController alloc]init];
            collectionPickerVC.delegate =self;
            [self presentViewController:collectionPickerVC animated:YES completion:nil];
             
            break;
        }
        case 3:
        {
            break;
        }
        default:
            break;
    }
}



#pragma mark - 照片显示在collection相关
//相册选择完成后的代理方法
-(void)didFinishPickerFromCollectionWithSelcetedThumbImages:(NSArray *)selecetedThumbImages imagesURL:(NSArray *)imagesURL
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.selecetedThumbImages addObjectsFromArray:selecetedThumbImages];
    [self.selectedImagesSelection initPNCollectionViewWithImages:self.selecetedThumbImages];
    [self.selectedImagesSelection changeLayout:[[LineLayout alloc]init]];
    [self.selectedFileImages addObjectsFromArray:[PNTools getImagesThroughURLs:imagesURL]];
}



//照相机取完照片
int photoNumber=0;
-(void)imagePickerController:(MyImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if ([self.isFilterUseSwitch isOn]) {
        image = [filtedImage CIUnsharpMaskWith:info[UIImagePickerControllerOriginalImage] andParametersInputRadius:nil inputIntensity:nil setDefault:YES];
        
    }
    else
    {
        image = info[UIImagePickerControllerOriginalImage];
    }

    UIImage *thumbImage = [ThumbNailImage instanceWith:image];
    [self.selectedFileImages addObject:image];
    [self.selecetedThumbImages addObject: thumbImage];
    [picker sendThumbNail:thumbImage];
        
}

- (IBAction)filterSwichChange:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"滤镜开启");
        self.isFileterUseLabel.text = @"使用锐化滤镜";
    }
    else
    {
        NSLog(@"滤镜关闭");
        self.isFileterUseLabel.text = @"关闭锐化滤镜";
    }
}


//照相机关闭的代理方法
-(void)dismissCamre:(MyImagePickerController *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.selectedImagesSelection initPNCollectionViewWithImages:self.selecetedThumbImages];
    [self.selectedImagesSelection changeLayout:[[LineLayout alloc]init]];
}


//selectedCollection点击删除已经选中的图片
-(void)removeSelectImageAtIndex:(NSIndexPath *)index
{
    NSLog(@"缩略图有%ld张",self.selecetedThumbImages.count);
    [self.selectedFileImages removeObjectAtIndex:index.item];
    NSLog(@"要存的原始尺寸照片有%ld张",self.selectedFileImages.count);
}


//转换layout
- (IBAction)layoutStyleChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex%4) {
        case 0:
            [self.selectedImagesSelection changeLayout:[[LineLayout alloc]init]];
            break;
        case 1:
            [self.selectedImagesSelection changeLayout:[[StackLayout alloc]init]];
            break;
        case 2:
            [self.selectedImagesSelection changeLayout:[[CircleLayout alloc]init]];
            break;
        case 3:
            [self.selectedImagesSelection changeLayout:[[UICollectionViewFlowLayout alloc]init]];
            break;
        default:
            break;
    }
}
//最后保存笔记的执行方法
- (IBAction)saveWholeItem:(UIBarButtonItem *)sender {
    //如果是修改先把原来的笔记删除
    if (self.showItem != nil) {
        [PNTools deleteWhoItem:self.showItem WithSoundFileOrNot:NO];
    }
    
    NSLog(@"%@",self.selectedFileImages);
    if (self.selectedFileImages.count != 0) {
        [PNTools creatWholeIteamNowWithUUID:self.UUID CourseName:self.courseLabel.text memo:self.memoTextView.text tag:self.tagLabel.text dateReminder: self.remindeDate WithImages:self.selectedFileImages iamgesMemos:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Note isn't saved. You need to take a image for note" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self deleteSoundFile:nil];
    }
    
    [self.delegate tableNeedReload];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
