//
//  TrainingDetailViewController.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MaterialDetailViewController.h"
#import "CourseInfo.h"
#import "TrainingManager+Course.h"
#import "TrainingManager+Apply.h"
#import "TrainingManager+Summary.h"
#import "TrainingManager+Material.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "WMPhotoBrowser/MWPhotoBrowser.h"
#import "TrainingManager+User.h"

@interface MaterialDetailViewController ()<UIDocumentInteractionControllerDelegate, MWPhotoBrowserDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet WLCButton *verifyButton;

@property (strong, nonatomic) UIDocumentInteractionController *previewController;
@property (copy, nonatomic) NSString *materialUrl;

@end

@implementation MaterialDetailViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"培训资料详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([TrainingManager isVerifyAdmin]) {
        self.verifyButton.hidden = NO;
    }
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initUI:self.materialInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)initUI:(MaterialInfo *)materialInfo
{
    self.themeLabel.text = [NSString stringWithFormat:@"培训主题：%@", materialInfo.theme];
    self.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@", [materialInfo.createTime substringToIndex:16]];
    self.departmentLabel.text = [NSString stringWithFormat:@"主办单位：%@", materialInfo.department.departmentName];
    self.publisherLabel.text = [NSString stringWithFormat:@"发布人：%@", materialInfo.userInfo.name];
    self.materialUrl = [NSString stringWithFormat:@"%@%@", kServerBaseUrl, materialInfo.link];
    self.linkLabel.text = self.materialUrl;
    
    [self.linkLabel autoAdjustHeight];
}

- (void)previewDocument
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.materialUrl]];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [self showLoadingViewWithText:@"正在获取文件数据..."];
    NSString *fileName = [self.materialUrl pathComponents].lastObject;
    NSString *preferencesPath = [NSString stringWithFormat:@"/Preferences/%@", fileName];
    NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:preferencesPath];
    NSURLSessionDownloadTask *task = [sessionManager downloadTaskWithRequest:request
                                                                    progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                        NSLog(@"progress = %f", downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount);
                                                                    }
                                                                 destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                     return [NSURL fileURLWithPath:savePath];
                                                                 }
                                                           completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                               [self dismissLoadingView];
                                                               if (error) {
                                                                   NSLog(@"error = %@", error);
                                                                   [WLCToastView toastWithMessage:@"获取文件数据失败" error:error];
                                                                   return;
                                                               }
                                                               
                                                               self.previewController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
                                                               self.previewController.delegate = self;
                                                               // [self.previewController presentPreviewAnimated:YES];
                                                               [self.previewController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
                                                           }];
    [task resume];
}

#pragma mark - Button action

- (IBAction)onCopyButtonClicked:(id)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = [NSString stringWithFormat:@"%@%@", kServerBaseUrl, [NSString stringWithFormat:@"%@%@", kServerBaseUrl, self.materialInfo.link]];
    
    [WLCToastView toastWithMessage:@"链接已复制到剪切板"];
}

- (IBAction)onVerifyButtonClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定审核通过该资料？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"通过", @"不通过", nil];
    [alertView show];
}

- (IBAction)onBrowserButtonClicked:(id)sender
{
    NSLog(@"fileUrl = %@", self.materialUrl);
    
    NSString *suffix = [self.materialUrl pathExtension];
    if ([WLCFileTypeCheck checkVideo:suffix]) {
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [self.navigationController pushViewController:photoBrowser animated:YES];
        return;
    }
    
    if ([WLCFileTypeCheck checkImage:suffix]) {
        MWPhotoBrowser *videoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [self.navigationController pushViewController:videoBrowser animated:YES];
        return;
    }
    
    // 预览文件
    [self previewDocument];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    NSString *suffix = [self.materialUrl pathExtension];
    if ([WLCFileTypeCheck checkImage:suffix]) {
        return @"预览图片";
    }
    else {
        return @"预览视频";
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    NSString *suffix = [self.materialUrl pathExtension];
    if ([WLCFileTypeCheck checkImage:suffix]) {
        return [MWPhoto photoWithURL:[NSURL URLWithString:self.linkLabel.text]];
    }
    else {
        MWPhoto *video = [MWPhoto new];
        video.videoURL = [NSURL URLWithString:self.materialUrl];
        return video;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    BOOL isApprove = NO;
    if (buttonIndex == 1) {
        isApprove = YES;
    }
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] verifyMaterailWithMId:self.materialInfo.mid isApprove:isApprove completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"操作失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"操作成功"];
             [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
