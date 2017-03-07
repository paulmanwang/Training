//
//  UIViewController+WLC.m
//  Training
//
//  Created by lichunwang on 16/12/30.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UIViewController+WLC.h"
#import "NSObject+MethodSwizzle.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>

// 两种方式
// static const char *kHudKey; // 方式一
static const char kHudKey = '\0'; // 方式二 (最节省内存，一个字节就够了)

static const char kTempNaviControllerKey = '\0';

// 思考继承和扩展http://blog.csdn.net/openglnewbee/article/details/51133340
@implementation UIViewController (WLC)

+ (void)load
{
    // load方法只会调用一次，因此这里dispatch_once没有必要，加上也无所谓
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self exchangeInstanceMethod:@selector(viewDidLoad)
//               withNewInstanceMethod:@selector(wlc_viewDidLoad)];
//    });
}

- (void)wlc_viewDidLoad
{
    [self wlc_viewDidLoad];
    // self.view.backgroundColor = [UIColor blackColor];
    
    // scrollview不生效卧槽
//    [self.view traverseSubViewWithBlock:^(UIView *subView) {
//        if ([subView isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel *)subView;
//            label.textColor = [UIColor blueColor];
//        }
//    }];
}

- (void)hideKeyBoard
{
    UIView *subView = [self.view subviewByTraversingWithCompareBlock:^BOOL(UIView *subView) {
        if ([subView isKindOfClass:[UITextField class]] ||
            [subView isKindOfClass:[UITextView class]]) {
            if ([subView isFirstResponder]) {
                return YES;
            }
        }
        
        return NO;
    }];
    
    if (subView) {
        [subView resignFirstResponder];
    }
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, &kHudKey, hud, /*OBJC_ASSOCIATION_RETAIN_NONATOMIC*/OBJC_ASSOCIATION_ASSIGN); // 这里采用若引用，因为vc的view已经强引用了hud
}

- (MBProgressHUD *)hud
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, &kHudKey);
    return hud;
}

- (void)showLoadingViewWithText:(NSString *)text
{
    if ([self hud]) { // 同时最多只有一个转圈
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    [self.view addSubview:hud];
    [hud show:NO];
    [self setHud:hud];
}

- (void)dismissLoadingView
{
    MBProgressHUD *hud = [self hud];
    NSLog(@"hud = %@", hud);
    [hud hide:NO];
    
    // The value to associate with the key key for object. Pass nil to clear an existing association.
    objc_setAssociatedObject(self, &kHudKey, nil, OBJC_ASSOCIATION_ASSIGN); // 删除关联对象
    // 如果是若引用，上面的一行代码没有必要了吧(结论：objc_getAssociatedObject一行会崩溃)
}

- (void)presentViewControllerWithNavi:(UIViewController *)controller
                           completion:(void(^)(void))completion
{
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_close_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBtnClicked)];

    [self setTempNaviController:naviController];
    [self presentViewController:naviController animated:YES completion:completion];
}

- (void)setTempNaviController:(UINavigationController *)naviController
{
    objc_setAssociatedObject(self, &kTempNaviControllerKey, naviController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)onCloseBtnClicked
{
    UINavigationController *naviController = objc_getAssociatedObject(self, &kTempNaviControllerKey);
    [naviController dismissViewControllerAnimated:YES completion:nil];
    objc_setAssociatedObject(self, &kTempNaviControllerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
