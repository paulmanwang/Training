//
//  TrainingDetailViewController.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SummaryDetailViewController.h"
#import "CourseInfo.h"
#import "TrainingManager+Course.h"
#import "TrainingManager+Apply.h"
#import "TrainingManager+Summary.h"
#import "TrainingManager+User.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface SummaryDetailViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pictureTipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet WLCButton *verifyButton;

@end

@implementation SummaryDetailViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"随手拍详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.contentTipsLabel.layer.cornerRadius = 5;
    self.contentTipsLabel.layer.masksToBounds = YES;
    self.pictureTipsLabel.layer.cornerRadius = 5;
    self.pictureTipsLabel.layer.masksToBounds = YES;
    
    self.contentTipsLabel.layer.cornerRadius = 5;
    self.contentTipsLabel.layer.masksToBounds = YES;
    
    if ([TrainingManager isVerifyAdmin]) {
        self.verifyButton.hidden = NO;
    }
    
    [self showLoadingViewWithText:@"正在获取..."];
    [[TrainingManager sharedInstance] querySummaryDetailWithSId:self.sid completion:^(NSError *error, CourseInfo *info) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"加载失败" error:error];
        }
        else {
            [self setCurseInfo:info];
        }
    }];
}

- (void)setCurseInfo:(CourseInfo *)courseInfo
{
    self.themeLabel.text = [NSString stringWithFormat:@"培训主题：%@", courseInfo.theme];
    self.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@", courseInfo.startTime];
    self.departmentLabel.text = [NSString stringWithFormat:@"主办单位：%@", courseInfo.departmentName];
    self.publisherLabel.text = [NSString stringWithFormat:@"发布人：%@", courseInfo.name];
    self.contentTextView.text = courseInfo.content;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerBaseUrl, courseInfo.picture]];
    [self.pictureImageView setImageWithURL:url placeholderImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button action

- (IBAction)onVerifyButtonClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定审核通过该随手拍？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"通过", @"不通过", nil];
    [alertView show];
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
    [[TrainingManager sharedInstance] verifySummaryWithSId:self.sid isApprove:isApprove completion:^(NSError *error) {
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
