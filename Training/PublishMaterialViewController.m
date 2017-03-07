//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "PublishMaterialViewController.h"
#import "WLCPickerView.h"
#import "TZImagePickerController.h"
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import "TrainingManager+Upload.h"
#import "TrainingManager+Material.h"
#import <Photos/PHAssetResource.h>

@interface PublishMaterialViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *themeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *departmentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *uploadCell;

@property (weak, nonatomic) IBOutlet WLCTextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *photoUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *themeTextField;

@property (assign, nonatomic) NSInteger selectedDepartmentIndex;

@end

@implementation PublishMaterialViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"发布培训资料";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];

    self.photoUrlTextField.textColor = kGlobalTextColor;
    self.themeTextField.textColor = kGlobalTextColor;
    
    [WLCPickerView getDepartmentInfo:^(NSError *error, DepartmentInfo *info) {
        if (info) {
            self.selectedDepartmentIndex = 0;
            [self updateDepartmentInfo];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)updateDepartmentInfo
{
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    self.departmentTextField.text = info.departmentName;
}

#pragma mar- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [self hideKeyBoard];
        [WLCPickerView showDepartmentPickerViewOnViewController:self
                                              withSelectedIndex:self.selectedDepartmentIndex
                                                      doneBlock:^(NSInteger selectedIndex)
         {
             self.selectedDepartmentIndex = selectedIndex;
             [self updateDepartmentInfo];
         } cancelBlock:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Training) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Training) {
        if (indexPath.row == 0) {
            return self.themeCell;
        }
        else {
            return self.uploadCell;
        }
    }
    else {
        if (indexPath.row == 0) {
            return self.departmentCell;
        }
        else if (indexPath.row == 1) {
            return self.themeCell;
        }
        else {
            return self.uploadCell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (IBAction)onUploadBtnClicked:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *images, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (assets.count > 0) {
            PHAsset *asset = [assets firstObject];
            
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [self showLoadingViewWithText:@"正在上传..."];
                [[TrainingManager sharedInstance] uploadFileWithType:1
                                                            fileData:imageData
                                                         contentType:asset.contentType
                                                          completion:^(NSError *error, NSString *url)
                 {
                     [self dismissLoadingView];
                     if (error) {
                         [WLCToastView toastWithMessage:@"上传失败" error:error];
                     }
                     else {
                         self.photoUrlTextField.text = url;
                         [WLCToastView toastWithMessage:@"上传成功"];
                     }
                 }];
            }];
        }
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (IBAction)onSubmitBtnClicked:(id)sender
{
    if (self.themeTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"资料名称不能为空"];
        return;
    }
    if (self.photoUrlTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"请上传培训资料"];
        return;
    }
    
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    NSDictionary *parameters = @{@"department_id":@(info.departmentId), @"theme":self.themeTextField.text, @"link":self.photoUrlTextField.text};
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] addMaterialWithParameters:parameters completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"发布培训资料失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"发布培训资料成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

@end
