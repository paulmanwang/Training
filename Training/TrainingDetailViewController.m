//
//  TrainingDetailViewController.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingDetailViewController.h"
#import "CourseInfo.h"
#import "TrainingManager+Course.h"
#import "TrainingManager+Apply.h"

@interface TrainingDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *contactsTextField;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (assign, nonatomic) NSInteger originalApplyCount;

@property (strong, nonatomic) CourseInfo *courseInfo;

@end

@implementation TrainingDetailViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"培训详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.originalApplyCount = 0;
    
    self.contentTipsLabel.layer.cornerRadius = 5;
    self.contentTipsLabel.layer.masksToBounds = YES;
    
    [self showLoadingViewWithText:@"正在加载数据..."];
    [[TrainingManager sharedInstance] queryCourseDetailWithCid:self.cid completion:^(NSError *error, CourseInfo *courseInfo) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"加载失败" error:error];
            return;
        }
        
        self.courseInfo = courseInfo;
        [self updateUI:courseInfo];
        
        [self setAllpyButtonStatus];
    }];
}

- (void)setAllpyButtonStatus
{
    if ([self courseIsExpired]) {
        self.applyButton.hidden = YES;
        return;
    }
    
    if ([TrainingManager sharedInstance].userInfo.userType == 1) {
        [[TrainingManager sharedInstance] queryApplyStatusWithCId:self.cid completion:^(NSError *error, NSInteger status) {
            if (status == 1) {
                [self.applyButton setTitle:@"取消报名"];
            }
            else {
                [self.applyButton setTitle:@"报名培训"];
            }
        }];
    }
    else if ([TrainingManager sharedInstance].userInfo.userType == 5){
        self.applyButton.title = @"审核";
    }
    else {
        self.applyButton.hidden = YES;
    }
}

- (void)updateUI:(CourseInfo *)curseInfo
{
    NSString *strStartTime = [curseInfo.startTime substringToIndex:16];
    NSRange range;
    range.location = 11;
    range.length = 5;
    NSString *strEndTime = [curseInfo.endTime substringWithRange:range];
    
    self.themeLabel.text = [NSString stringWithFormat:@"培训主题：%@", curseInfo.theme];
    self.audienceLabel.text = [NSString stringWithFormat:@"培训对象：%@", curseInfo.audience];
    if ([UIScreen isNarrowScreen]) {
        NSString *timeString = [NSString stringWithFormat:@"培训时间：%@-%@", strStartTime, strEndTime];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:timeString];
        [attrString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"444444"]} range:NSMakeRange(0, 5)];
        [attrString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"444444"]} range:NSMakeRange(5, timeString.length - 5)];
        self.timeLabel.attributedText = attrString;
    }
    else {
         self.timeLabel.text = [NSString stringWithFormat:@"培训时间：%@-%@", strStartTime, strEndTime];
    }
   
    self.placeLabel.text = [NSString stringWithFormat:@"培训地点：%@", curseInfo.place];
    self.departmentLabel.text = [NSString stringWithFormat:@"主办单位：%@", curseInfo.department.departmentName];
    self.publisherLabel.text = [NSString stringWithFormat:@"发布人：%@", curseInfo.userInfo.name];
    self.contactsTextField.text = [NSString stringWithFormat:@"联系人：%@", curseInfo.contacts];
    self.mobileLabel.text = [NSString stringWithFormat:@"联系电话：%@", curseInfo.mobile];
    self.numberLabel.text = [NSString stringWithFormat:@"报名人数：%lu", curseInfo.applyCount];
    self.contentTextView.text = curseInfo.content;
    self.originalApplyCount = curseInfo.applyCount;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button action

- (BOOL)courseIsExpired
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSDate *endDate = [dateFormatter dateFromString:self.courseInfo.endTime];
    NSComparisonResult result = [currentDate compare:endDate];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (void)doApply
{
    [self showLoadingViewWithText:@"正在处理..."];
    if ([self.applyButton.title isEqualToString:@"报名培训"]) {
        [[TrainingManager sharedInstance] addApplyWithCId:self.courseInfo.cid completion:^(NSError *error) {
            [self dismissLoadingView];
            if (error) {
                [WLCToastView toastWithMessage:@"报名失败" error:error];
            }
            else {
                [WLCToastView toastWithMessage:@"报名成功"];
                self.originalApplyCount++;
                self.numberLabel.text = [NSString stringWithFormat:@"报名人数：%lu", self.originalApplyCount];
                self.applyButton.title = @"取消报名";
            }
        }];
    }
    else {
        [[TrainingManager sharedInstance] deleteApplyWithCId:self.courseInfo.cid completion:^(NSError *error) {
            [self dismissLoadingView];
            if (error) {
                [WLCToastView toastWithMessage:@"取消失败" error:error];
            }
            else {
                [WLCToastView toastWithMessage:@"取消成功"];
                self.originalApplyCount--;
                self.numberLabel.text = [NSString stringWithFormat:@"报名人数：%lu", self.originalApplyCount];
                self.applyButton.title = @"报名培训";
            }
        }];
    }
}

- (void)doVerify
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定审核通过该培训？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"通过", @"不通过", nil];
    [alertView show];
}

- (IBAction)onApplyButtonClicked:(id)sender
{
    if ([TrainingManager sharedInstance].userInfo.userType == 1) {
        [self doApply];
    }
    else if ([TrainingManager sharedInstance].userInfo.userType == 5){
        [self doVerify];
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
    [[TrainingManager sharedInstance] verifyCourseWithCId:self.courseInfo.cid isApprove:isApprove completion:^(NSError *error) {
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
