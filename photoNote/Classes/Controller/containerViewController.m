//
//  containerViewController.m
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "containerViewController.h"
#import "homeView.h"
#import "slideView.h"
#import "PNAddItemViewController.h"

//UI的比例宏
#define RightTarget 200 //设置右边的拉出距离
#define LeftTarget -100 //设置左边的拉出距离
#define MaxY 0 //设置homeView拉出后的长度比例
#define animationTime 0.35//设置动画过渡的时间
@interface containerViewController ()<homeViewDelegate,UIGestureRecognizerDelegate,PNAddItemViewControllerDelegate,slideViewDelegate>

@property(nonatomic,weak)UIView *rightView;
@property(nonatomic,weak)homeView *midView;
@property(nonatomic,weak)slideView *leftView;
@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;

@property(nonatomic,assign)BOOL isDraging;//用于判断是拖动还是点击

@end

@implementation containerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.添加子视图
    [self addChildView];
    //2.监听KVC,只能监听对象属性，不能监听结构体属性
    [_midView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addNavigationBarItems];
    
    [self creatFileFold];
    self.isDraging = NO;
}

/**
 *  添加三种视图
 */
- (void)addChildView
{
    //left
    slideView *leftView = [[[NSBundle mainBundle] loadNibNamed:@"slideView" owner:nil options:nil] firstObject];
    leftView.frame = [UIScreen mainScreen].bounds;
    leftView.delegate = self;
    [self.view addSubview:leftView];
    _leftView = leftView;
    
    //right
    UIView *rightView = [[UIView alloc]initWithFrame: [UIScreen mainScreen].bounds];
    rightView.backgroundColor = [UIColor  blueColor];
    [self.view addSubview:rightView];
    _rightView = rightView;
    
    //mid
    homeView *midView = [[[NSBundle mainBundle] loadNibNamed:@"homeView" owner:nil options:nil] firstObject];
    midView.delegate = self;
    __weak UIViewController *weakVC = self;
    midView.superViewController = weakVC;
    [self.view addSubview:midView];
    _midView = midView;
    
    //homeTableView滑动的手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveHomeView:)];
    [self.midView addGestureRecognizer:panGesture];
    //homeView上的点击手势
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveBackHomeView:)];
    self.tapGesture = tapGesture;
    //[self.midView addGestureRecognizer:tapGesture];
    
}

-(void)creatFileFold
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *foldPath = [doc stringByAppendingString:@"/soundFiles"];
    [[NSFileManager defaultManager] createDirectoryAtPath:foldPath withIntermediateDirectories:YES attributes:nil error:nil];

}

-(void)addNavigationBarItems
{
    self.navigationItem.title = @"TimeLine";
    
    //添加左侧导航按钮
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.bounds = CGRectMake(0, 0, 25, 20);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showLefMenu:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

    //添加右侧导航按钮
    UIBarButtonItem *addItemBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    self.navigationItem.rightBarButtonItem = addItemBtn;

    /*
    //设置中间的添加按钮
    UIButton *addItemBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.navigationItem.titleView = addItemBtn;*/

}

//增加Item
-(void)addItem
{
    PNAddItemViewController *addItemVC = [[PNAddItemViewController alloc]init];
    [self presentViewController:addItemVC animated:YES completion:nil];
    addItemVC.delegate = self;
}

//midView和addItemView的代理方法
//item增加活着删除完成后刷新hometable和slideTable
-(void)tableNeedReload
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.midView refreshHomeTable];
        //更新侧边栏
        [self.leftView refreshSlideTable];
    });
   
}

//lefView的代理方法 根据courseName显示items
-(void)showSelectedItemsInHomeTableByCourseName:(NSString *)courseName
{
    self.midView.searchWord = nil;
    self.midView.showCourseName = courseName;
    NSLog(@"courseName: %@",courseName);
    [self moveBackToHomeView];
    [self tableNeedReload];
    self.navigationItem.title = courseName;
}
-(void)showSelectedItemsInHomeTableBySearchWords:(NSString *)searchWords withSearchLevel:(NSUInteger)searchLevel
{
    self.midView.searchWord = searchWords;
    self.midView.searchLevel = searchLevel;
    NSLog(@"searchWords: %@",searchWords);
    [self moveBackToHomeView];
    [self tableNeedReload];
    self.navigationItem.title = @"SearchItems";
}


//*******************************************************************************************************************************//

/**
 *  下面的代码是侧边栏的UI框架
 *
 *
 */

#pragma mark - 设置UI的代码

-(void)hidNavigationBar
{
    [UIView animateWithDuration:animationTime animations:^{
        self.navigationController.navigationBar.alpha = 0;
    }];
}

-(void)showNavigationBar
{
    [UIView animateWithDuration:animationTime animations:^{
        self.navigationController.navigationBar.alpha = 1;
    }];
}


-(void)showLefMenu:(UIButton *)button
{
    [UIView animateWithDuration:animationTime animations:^{
    //获取x偏移量
    CGFloat offsetX = RightTarget - _midView.frame.origin.x;
    //获取主视图的fram
    _midView.frame = [self getCurrentFrameWithOffsetX:offsetX];
    self.navigationController.navigationBar.alpha = 0;
    }];
    self.midView.homeTable.userInteractionEnabled = NO;
    [self.midView addGestureRecognizer:self.tapGesture];
    NSLog(@"添加了Tap手势");
    
    //更新侧边栏
    [self.leftView refreshSlideTable];
}

//当midView的frame属性改变的时候就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.midView.homeTable.frame = self.midView.bounds;
    //NSLog(@"%@", change);
    if (_midView.frame.origin.x < 0) {//往左移动
        _rightView.hidden = NO;
        _leftView.hidden = YES;
            }else if(_midView.frame.origin.x > 0){//往右边移动
        _rightView.hidden = YES;
        _leftView.hidden = NO;
    }
}

//midView的手势操作函数
-(void)moveHomeView:(UIPanGestureRecognizer *)gesture
{
    static CGPoint prePoint;
    //开始识别
    if (gesture.state==UIGestureRecognizerStateBegan) {
        //第一次获取上一个点
        prePoint = [gesture locationInView:self.view];
        self.midView.homeTable.userInteractionEnabled = NO;
    }
    //连续识别
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //获取当前点
        CGPoint currentPoint = [gesture locationInView:self.view];
        //x偏移
        CGFloat offsetX =  currentPoint.x - prePoint.x;
        //获取主视图的fram
        _midView.frame = [self getCurrentFrameWithOffsetX:offsetX];
        self.navigationController.navigationBar.alpha = 1-ABS(_midView.frame.origin.x/RightTarget);
        _isDraging = YES;
        //存取上一个点
        prePoint = [gesture locationInView:self.view];
    }
    //识别结束
    if (gesture.state==UIGestureRecognizerStateEnded)
    {
    
        //判断后执行左右滑动的纠正
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat target = 0;
        if (_midView.frame.origin.x > screenW*0.3) {
            target = RightTarget;
    
        }else if(CGRectGetMaxX(_midView.frame) < screenW*0.7){
            target = LeftTarget;
        }
        //执行动画
        [UIView animateWithDuration:animationTime animations:^{
            if (target)
            {
                //获取x偏移量
                CGFloat offsetX = target - _midView.frame.origin.x;
                //获取主视图的fram
                _midView.frame = [self getCurrentFrameWithOffsetX:offsetX];
                self.navigationController.navigationBar.alpha = 0;
                NSLog(@"添加了Tap手势");
                [self.midView addGestureRecognizer:self.tapGesture];
                
            }else
            {
                _midView.frame = self.view.bounds;
                self.navigationController.navigationBar.alpha = 1;
                self.midView.homeTable.userInteractionEnabled = YES;
            }
        }];
        _isDraging =NO;
    }
}
//tap手势的操作函数
-(void)moveBackHomeView:(UITapGestureRecognizer *)tapGesture
{
    if(tapGesture.state == UIGestureRecognizerStateRecognized)
    {
        [self moveBackToHomeView];
    }
}

//返回homeView的函数
-(void)moveBackToHomeView
{
    //复位
    if (_isDraging == NO  && _midView.frame.origin.x != 0) {
        [UIView animateWithDuration:animationTime animations:^{
            _midView.frame = self.view.bounds;
            self.navigationController.navigationBar.alpha = 1;
        }];
    }
    _isDraging =NO;
    self.midView.homeTable.userInteractionEnabled = YES;
    [self.midView removeGestureRecognizer:self.tapGesture];
    NSLog(@"去除了Tap手势");
}

//根据offsetX算出当前视图的frame
-(CGRect)getCurrentFrameWithOffsetX:(CGFloat)offsetX
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat offsetY = offsetX * MaxY / screenW;
    CGFloat scale = (screenH - 2*offsetY)/screenH;
    
    if (_midView.frame.origin.x < 0) {//往左边滑动
        scale = (screenH + 2*offsetY)/screenH;
    }
    
    CGRect frame = _midView.frame;
    frame.origin.x += offsetX;
    frame.size.height = frame.size.height * scale;
    frame.size.width = frame.size.width * scale;
    frame.origin.y = (screenH - frame.size.height)*0.5;
    
    return frame;
}


@end
