//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "PublishSummaryViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import "TrainingManager+Upload.h"
#import "TrainingManager+Summary.h"
#import <Photos/PHAssetResource.h>
#import "CourseInfo.h"

@interface PublishSummaryViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *themeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *uploadPicCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *notesCell;

@property (weak, nonatomic) IBOutlet UITextField *themeTextField;
@property (weak, nonatomic) IBOutlet UITextField *photoUrlTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (copy, nonatomic) NSArray *themeList;
@property (assign, nonatomic) NSInteger selectedCourseIndex;

@end

@implementation PublishSummaryViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
    
    if (self.courseInfo) {
        self.title = @"修改随手拍";
        self.themeTextField.textColor = [UIColor color255WithRed:210 green:221 blue:228];
    }
    else {
        self.title = @"发布随手拍";
        self.themeTextField.textColor = kGlobalTextColor;
    }
    
    self.themeTextField.textColor = kGlobalTextColor;
    self.photoUrlTextField.textColor = kGlobalTextColor;
    self.noteTextView.textColor = kGlobalTextColor;
    
    if (self.courseInfo) {
        self.photoUrlTextField.text = self.courseInfo.picture;
        self.noteTextView.text = self.courseInfo.content;
        self.themeTextField.text = self.courseInfo.theme;
    }else{
        [self queryThemeList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)queryThemeList
{
    [[TrainingManager sharedInstance] querySummaryThemeListWithCompletion:^(NSError *error, NSArray *themeList) {
        if (!error) {
            if (themeList.count > 0) {
                self.themeList = themeList;
                self.selectedCourseIndex = 0;
                CourseInfo *info = self.themeList[0];
                self.themeTextField.text = info.theme;
            }
        }
    }];
}

#pragma mark - UITextViewDelegate

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.themeTextField) {
        if (self.courseInfo) {
            [WLCToastView toastWithMessage:@"不能更改培训主题"];
            return NO;
        }
        [self hideKeyBoard];
        if (self.themeList.count > 0) {
            [WLCPickerView showPickerViewOnViewController:self withDataList:self.themeList selectedIndex:self.selectedCourseIndex doneBlock:^(NSInteger selectedIndex) {
                self.selectedCourseIndex = selectedIndex;
                CourseInfo *info = self.themeList[selectedIndex];
                textField.text = info.theme;
            } cancelBlock:nil];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.themeCell;
    }
    else if (indexPath.row == 1) {
        return self.uploadPicCell;
    }
    else {
        return self.notesCell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 200;
    }
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Button actions

- (IBAction)onUploadButtonClicked:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *images, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (assets.count > 0) {
            PHAsset *asset = [assets firstObject];

            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

                [self showLoadingViewWithText:@"正在上传..."];
                [[TrainingManager sharedInstance] uploadFileWithType:0
                                                            fileData:imageData
                                                         contentType:asset.contentType
                                                          completion:^(NSError *error, NSString *url)
                {
                    [self dismissLoadingView];
                    if (error) {
                        [WLCToastView toastWithMessage:@"上传图片失败" error:error];
                    }
                    else {
                        self.photoUrlTextField.text = url;
                        [WLCToastView toastWithMessage:@"上传图片成功" error:error];
                    }
                }];
            }];
        }
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
- (IBAction)onSubmitBtnClicked:(id)sender
{
    if (self.themeList.count == 0) {
        [WLCToastView toastWithMessage:@"培训主题不能为空"];
        return;
    }
    
    if (self.photoUrlTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"请上传随手拍图片"];
        return;
    }
    
    if (self.noteTextView.text.length == 0) {
        [WLCToastView toastWithMessage:@"培训总结不能为空"];
        return;
    }
    
    NSMutableDictionary *paramters = [NSMutableDictionary new];
    paramters[@"picture"] = self.photoUrlTextField.text;
    paramters[@"content"] = self.noteTextView.text;
    
    if (self.courseInfo) {
        paramters[@"sid"] = self.courseInfo.sid;
        [self showLoadingViewWithText:@"正在处理..."];
        [[TrainingManager sharedInstance] editSummaryWithParameters:paramters completion:^(NSError *error) {
            [self dismissLoadingView];
            if (error) {
                [WLCToastView toastWithMessage:@"修改失败" error:error];
            }
            else {
                [WLCToastView toastWithMessage:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else {
        CourseInfo *info = self.themeList[self.selectedCourseIndex];
        paramters[@"cid"] = info.cid;
        [self showLoadingViewWithText:@"正在处理..."];
        [[TrainingManager sharedInstance] addSummaryWithParameters:paramters completion:^(NSError *error) {
            [self dismissLoadingView];
            if (error) {
                [WLCToastView toastWithMessage:@"提交失败" error:error];
            }
            else {
                [WLCToastView toastWithMessage:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}


@end
