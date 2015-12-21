//
//  PNItemViewController.m
//  photoNote
//
//  Created by yuyaolong on 15/5/3.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNItemViewController.h"
#import "PNImageScrollView.h"
#import "PNTools.h"
#import "soundPlayer.h"
#import "PNAddItemViewController.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
@interface PNItemViewController ()<UIAlertViewDelegate,PNAddItemViewControllerDelegate>
@property (weak, nonatomic) IBOutlet PNImageScrollView *showScrollView;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

@property (strong,nonatomic)NSString *UUID;
@property(strong,nonatomic) soundPlayer *sPlayer;
@property(strong,nonatomic) NSString* soundFilePath;
@end

@implementation PNItemViewController



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)UUID
{
    if (!_UUID) {
        _UUID = self.showItem.itemKey;
    }
    return _UUID;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置页面的显示初始化
    self.showScrollView.showImages = self.showImages;
    [self.showScrollView initImageScrollView];
    self.memoTextView.text = self.showItem.memo;
    self.courseLabel.text = self.showItem.courseName;
    self.createdDateLabel.text = [[PNTools sharedPNTools] dateTostring: self.showItem.dateCreated withFormString:@"EEE yy-MM-dd H:mm"];
    
    
    //添加右侧编辑按钮
    UIBarButtonItem *addItemBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItem)];
    UIBarButtonItem *deleteItemBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem)];
    self.navigationItem.rightBarButtonItems = @[addItemBtn,deleteItemBtn];
    
    //添加声音播放器
    if ([self checkHaveSoundFile]) {
        [self setupSoundPlayer];
    }

}
//画面推出时
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sPlayer resetPlayer];
}

//检查是否有声音文件
-(BOOL)checkHaveSoundFile
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/soundFiles/%@.caf", self.UUID]];
    BOOL isShow = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isShow) {
        self.soundFilePath = path;
        return YES;
    }
    else
    {
        NSLog(@"不存在音频文件");
        return NO;
    }
}
//如果有录音文件就初始化播放器
-(void)setupSoundPlayer
{
    soundPlayer *sPlayer = [soundPlayer instanceSelf];
    sPlayer.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-41);
    self.sPlayer = sPlayer;
    sPlayer.URLForPlay = [NSURL fileURLWithPath:self.soundFilePath];
    [self.view addSubview:self.sPlayer];
    [sPlayer setSoundPlayerUI];
}


//点击编辑按钮后
-(void)editItem
{
    PNAddItemViewController *addItemVC = [[PNAddItemViewController alloc]init];
    addItemVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [addItemVC prepareForEditItemDataWithItem:self.showItem];
    addItemVC.delegate = self;
    [self presentViewController:addItemVC animated:YES completion:nil];
    
}



//点击删除按钮后
-(void)deleteItem
{
    UIAlertView *deletAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Do you really want delete this Item" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [deletAlert show];
    
}


//编辑完成后返回根控制器，刷新视图
-(void)tableNeedReload
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate homeTableNeedReload];
}


//删除按钮点击后删除数据与调用代理方法让视图刷新
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"YES"]) {
        [PNTools deleteWhoItem:self.showItem WithSoundFileOrNot:YES ];
        [self.delegate homeTableNeedReload];
        [self.navigationController popViewControllerAnimated:YES];
    }
}






@end
