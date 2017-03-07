//
//  LoginViewController.m
//  Training
//
//  Created by lichunwang on 16/12/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgotPwdViewController.h"

#import "UserMainViewController.h"
#import "MaterialViewController.h"
#import "UserAboutMeViewController.h"

#import "MRAMainViewController.h"
#import "MRAAboutMeViewController.h"

#import "TAMainViewController.h"
#import "TASummaryViewController.h"
#import "MaterialViewController.h"
#import "TAAboutMeViewController.h"

#import "SATrainingAdminViewController.h"
#import "SARoomAdminViewController.h"
#import "SAAboutMeViewController.h"
#import "SAExportViewController.h"
#import "SAManageViewController.h"
#import "SAAdminViewController.h"

#import "TrainingManager+User.h"
#import "TrainingManager+Department.h"

#import "VAAboutMeViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "UMMessageHelper.h"
#import "AppDelegate.h"

@interface ViewControllerItem : NSObject
@property (strong, nonatomic) UIViewController *viewController;
@property (copy, nonatomic) NSString *selectedImageName;
@property (copy, nonatomic) NSString *unselectedImageName;
@end
@implementation ViewControllerItem
@end

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *verifyCodeImageView;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (assign, nonatomic) CGFloat originalContainerViewBottom;

@property (assign, nonatomic) BOOL isQueryingVerifyCode;

@end

@implementation LoginViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self restoreUserName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryVerifyCode];
    
    self.originalContainerViewBottom = self.containerView.bottom;
    
    if ([UIScreen isNarrowScreen]) {
        self.switchButton.right = self.view.width - 12;
        self.verifyCodeImageView.width = 140;
        self.verifyCodeImageView.right = self.view.width - 58;
        self.verifyCodeTextField.width = self.verifyCodeImageView.left - 18 - 5;
    }
    else {
        self.verifyCodeTextField.width = self.verifyCodeImageView.left - 18 - 10;
    }
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    self.originalContainerViewBottom = self.containerView.bottom;
//    
//    self.verifyCodeTextField.width = self.verifyCodeImageView.left - 18 - 10;
//}

#pragma mark - Notifications

- (void)queryVerifyCode
{
    if (self.isQueryingVerifyCode) {
        return;
    }
    self.isQueryingVerifyCode = YES;
    
    [[TrainingManager sharedInstance] queryVerificationCodeWithCompletion:^(NSError *error, NSString *sid, NSString *codeUrl) {
        self.isQueryingVerifyCode = NO;
        if (error) {
            [WLCToastView toastWithMessage:@"获取验证码失败"];
            return;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerBaseUrl, codeUrl]];
        [self.verifyCodeImageView sd_setImageWithURL:url completed:nil];
    }];
}

- (void)onKeyBoardWillShow:(NSNotification *)notification
{
    NSLog(@"onKeyBoardWillShow");
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds = [keyboardBoundsValue CGRectValue];
    CGFloat keyBoardHeight = keyboardBounds.size.height;
    
    CGFloat dist = self.view.height - keyBoardHeight;
    if (dist < self.originalContainerViewBottom) {
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.bottom = dist;
        }];
    }
}

- (void)onKeyBoardWillHide:(NSNotification *)notification
{
    NSLog(@"onKeyBoardWillHide");
    self.containerView.bottom = self.originalContainerViewBottom;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        if (self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
            [self login];
        }
    }
    
    return YES;
}

#pragma mark - Private

- (void)internalResignFirstResponder
{
    if ([self.userNameTextField isFirstResponder]) {
        [self.userNameTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
    
    if ([self.verifyCodeTextField isFirstResponder]) {
        [self.verifyCodeTextField resignFirstResponder];
    }
}

- (void)showWindowWithViewControllers:(NSArray *)viewControllers
{
    NSMutableArray *naviControllers = [NSMutableArray new];
    for (ViewControllerItem *item in viewControllers) {
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:item.viewController];
        naviController.tabBarItem.selectedImage = [UIImage imageNamed:item.selectedImageName];
        naviController.tabBarItem.image = [UIImage imageNamed:item.unselectedImageName];
        [naviControllers addObject:naviController];
    }
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = naviControllers;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)showUserViewControler
{
    UserMainViewController *mainViewController = [UserMainViewController new];
    MaterialViewController *resViewController = [MaterialViewController instance];
    UserAboutMeViewController *aboutMeViewController = [UserAboutMeViewController instance];
    
    ViewControllerItem *item1 = [ViewControllerItem new];
    item1.viewController = mainViewController;
    item1.selectedImageName = @"tabbar_home_s";
    item1.unselectedImageName = @"tabbar_home_us";
    
    ViewControllerItem *item2 = [ViewControllerItem new];
    item2.viewController = resViewController;
    item2.selectedImageName = @"tabbar_resource_s";
    item2.unselectedImageName = @"tabbar_resource_us";
    
    ViewControllerItem *item3 = [ViewControllerItem new];
    item3.viewController = aboutMeViewController;
    item3.selectedImageName = @"tabbar_me_s";
    item3.unselectedImageName = @"tabbar_me_us";
    
    [self showWindowWithViewControllers:@[item1, item2, item3]];
}

- (void)showMeetingRoomAdminViewContoller
{
    MRAMainViewController *mainViewController = [MRAMainViewController new];
    MRAAboutMeViewController *aboutMeViewController = [MRAAboutMeViewController instance];
    
    ViewControllerItem *item1 = [ViewControllerItem new];
    item1.viewController = mainViewController;
    item1.selectedImageName = @"tabbar_home_s";
    item1.unselectedImageName = @"tabbar_home_us";
    
    ViewControllerItem *item2 = [ViewControllerItem new];
    item2.viewController = aboutMeViewController;
    item2.selectedImageName = @"tabbar_me_s";
    item2.unselectedImageName = @"tabbar_me_us";
    
    [self showWindowWithViewControllers:@[item1, item2]];
}

- (void)showTrainingAdminViewController
{
    TAMainViewController *mainViewController = [TAMainViewController instance];
    TASummaryViewController *paiViewController = [TASummaryViewController instance];
    MaterialViewController *resViewController = [MaterialViewController instance];
    TAAboutMeViewController *aboutMeViewController = [TAAboutMeViewController instance];
    
    ViewControllerItem *item1 = [ViewControllerItem new];
    item1.viewController = mainViewController;
    item1.selectedImageName = @"tabbar_home_s";
    item1.unselectedImageName = @"tabbar_home_us";
    
    ViewControllerItem *item2 = [ViewControllerItem new];
    item2.viewController = paiViewController;
    item2.selectedImageName = @"tabbar_pai_s";
    item2.unselectedImageName = @"tabbar_pai_us";
    
    ViewControllerItem *item3 = [ViewControllerItem new];
    item3.viewController = resViewController;
    item3.selectedImageName = @"tabbar_resource_s";
    item3.unselectedImageName = @"tabbar_resource_us";
    
    ViewControllerItem *item4 = [ViewControllerItem new];
    item4.viewController = aboutMeViewController;
    item4.selectedImageName = @"tabbar_me_s";
    item4.unselectedImageName = @"tabbar_me_us";
    
    [self showWindowWithViewControllers:@[item1, item2, item3, item4]];
}

- (void)showSuperAdminViewController
{
    SAManageViewController *manageVC = [SAManageViewController instance];
    SAExportViewController *exportVC = [SAExportViewController instance];
    SAAdminViewController *adminVC = [SAAdminViewController instance];
    SAAboutMeViewController *aboutMeVC = [SAAboutMeViewController instance];
    
    ViewControllerItem *item1 = [ViewControllerItem new];
    item1.viewController = manageVC;
    item1.selectedImageName = @"tabbar_manage_s";
    item1.unselectedImageName = @"tabbar_manage_us";
    
    ViewControllerItem *item2 = [ViewControllerItem new];
    item2.viewController = exportVC;
    item2.selectedImageName = @"tabbar_export_s";
    item2.unselectedImageName = @"tabbar_export_us";
    
    ViewControllerItem *item3 = [ViewControllerItem new];
    item3.viewController = adminVC;
    item3.selectedImageName = @"tabbar_trainingadmin_s";
    item3.unselectedImageName = @"tabbar_trainingadmin_us";
    
    ViewControllerItem *item4 = [ViewControllerItem new];
    item4.viewController = aboutMeVC;
    item4.selectedImageName = @"tabbar_me_s";
    item4.unselectedImageName = @"tabbar_me_us";
    
    [self showWindowWithViewControllers:@[item1, item2, item3, item4]];
}

- (void)showVerifyAdminController
{
    TAMainViewController *mainViewController = [TAMainViewController instance];
    TASummaryViewController *paiViewController = [TASummaryViewController instance];
    MaterialViewController *resViewController = [MaterialViewController instance];
    VAAboutMeViewController *aboutMeViewController = [VAAboutMeViewController instance];
    
    ViewControllerItem *item1 = [ViewControllerItem new];
    item1.viewController = mainViewController;
    item1.selectedImageName = @"tabbar_home_s";
    item1.unselectedImageName = @"tabbar_home_us";
    
    ViewControllerItem *item2 = [ViewControllerItem new];
    item2.viewController = paiViewController;
    item2.selectedImageName = @"tabbar_pai_s";
    item2.unselectedImageName = @"tabbar_pai_us";
    
    ViewControllerItem *item3 = [ViewControllerItem new];
    item3.viewController = resViewController;
    item3.selectedImageName = @"tabbar_resource_s";
    item3.unselectedImageName = @"tabbar_resource_us";
    
    ViewControllerItem *item4 = [ViewControllerItem new];
    item4.viewController = aboutMeViewController;
    item4.selectedImageName = @"tabbar_me_s";
    item4.unselectedImageName = @"tabbar_me_us";
    
    [self showWindowWithViewControllers:@[item1, item2, item3, item4]];
}

- (void)login
{
    NSString *verifyCode = self.verifyCodeTextField.text;
    if (verifyCode.length == 0) {
        [WLCToastView toastWithMessage:@"请输入验证码"];
        return;
    }
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self showLoadingViewWithText:@"正在登录..."];
    [[TrainingManager sharedInstance] loginWithUserName:userName
                                               password:password
                                       verificationCode:verifyCode
                                      completionHandler:^(NSError *error)
    {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"登录失败" error:error];
            return;
        }

        NSInteger userType = [TrainingManager sharedInstance].userInfo.userType;
        if (userType == 1) {
            [self showUserViewControler];
        }
        else if (userType == 2) {
            [self showMeetingRoomAdminViewContoller];
        }
        else if (userType == 3) {
            [self showTrainingAdminViewController];
        }
        else if (userType == 4){
            [self showSuperAdminViewController];
        }
        else if (userType == 5) {
            [self showVerifyAdminController];
        }
        
        [[TrainingManager sharedInstance] queryDepartmentsWithCompletion:nil];
        [WLCToastView toastWithMessage:@"登录成功"];
        self.passwordTextField.text = nil;
        
        [self saveUserName];
        self.verifyCodeTextField.text = @"";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (delegate.isLanuchFromNotification) {
                [[UMMessageHelper sharedInstance] onDidReceiveRemoteNotification:delegate.notificationUserInfo];
            }
        });
    }];
}

- (void)saveUserName
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.userNameTextField.text forKey:kLastLoginUserName];
    [userDefault synchronize];
}

- (void)restoreUserName
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefault objectForKey:kLastLoginUserName];
    if (userName.length > 0) {
        self.userNameTextField.text = userName;
    }
}

#pragma mark - Button actions

- (IBAction)onLoginBtnClicked:(id)sender
{
    [self internalResignFirstResponder];
    
    [self login];
}

- (IBAction)onRegesterBtnClicked:(id)sender
{
    [self internalResignFirstResponder];
    
    RegisterViewController *regeisterVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];;
    [self.navigationController pushViewController:regeisterVC animated:YES];
}

- (IBAction)onForgotPwdBtnClicked:(id)sender
{
    [WLCToastView toastWithMessage:@"请联系本单位审核管理员重置密码"];
    
//    [self internalResignFirstResponder];
//    ForgotPwdViewController *vc = [ForgotPwdViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBackgroundClicked:(id)sender
{
    [self internalResignFirstResponder];
}

- (IBAction)onChangeButtonClicked:(id)sender
{
    [self queryVerifyCode];
}

@end
