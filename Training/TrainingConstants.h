//
//  TrainingConstants.h
//  Training
//
//  Created by lichunwang on 16/12/22.
//  Copyright © 2016年 springcome. All rights reserved.
//

#ifndef TrainingConstants_h
#define TrainingConstants_h

#pragma mark - Color 

#define kGlobalTextColor [UIColor colorWithHexString:@"444444"]
#define kBluColor        [UIColor color255WithRed:42 green:142 blue:188];
#define kLightBlueColor  [UIColor color255WithRed:210 green:221 blue:228];

#pragma mark - Common Code Blocks

#define TrainingCallBackBlock \
if (code != 0) { \
error = error ? error : commonErrorWithJsonData(responseObject); \
if (completion) { \
completion(error); \
} \
} \
else { \
if (completion) { \
completion(nil); \
} \
}

#define AddKeyboardObserverCodeBlock \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil]; \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];


#define onKeyBoardWillShowCodeBlock \
- (void)onKeyBoardWillShow:(NSNotification *)notification \
{ \
    UIView *view = [self firstResponder]; \
    if (view == nil) { \
        return; \
    } \
    \
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]; \
    CGRect keyboardBounds = [keyboardBoundsValue CGRectValue]; \
    CGFloat keyBoardHeight = keyboardBounds.size.height; \
    \
    CGRect rect = [view convertRect:view.frame toView:self.view]; \
    NSLog(@"top = %f", rect.origin.y); \
    CGFloat dist = (rect.origin.y + rect.size.height) - (self.view.height - keyBoardHeight); \
    \
    CGFloat originYoffset = self.tableView.contentOffset.y; \
    [self.tableView setContentOffset:CGPointMake(0, dist + originYoffset)]; \
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyBoardHeight, 0)]; \
}

#define onKeyBoardWillHideCodeBlock \
- (void)onKeyBoardWillHide:(NSNotification *)notification \
{ \
    self.tableView.contentInset = UIEdgeInsetsZero; \
    self.tableView.contentOffset = CGPointZero; \
}

#define DeleteAndEditDataCodeBlock \
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
    if ([TrainingManager isCommonUser] || [TrainingManager isVerifyAdmin]) { \
        return UITableViewCellEditingStyleNone; \
    } \
    return UITableViewCellEditingStyleDelete; \
} \
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
    \
} \
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) { \
        NSLog(@"修改"); \
        [self editDataWithIndexPath:indexPath]; \
        \
    }]; \
    editAction.backgroundColor = [UIColor color255WithRed:42 green:142 blue:188]; \
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) { \
        NSLog(@"删除"); \
        [self deleteDataWithIndexPath:indexPath]; \
    }]; \
    deleteAction.backgroundColor = [UIColor color255WithRed:255 green:0 blue:0 alpha:0.5]; \
    \
    return @[deleteAction, editAction]; \
}

#define DeleteDataCodeBlock \
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
if ([TrainingManager isCommonUser] || [TrainingManager isVerifyAdmin]) { \
return UITableViewCellEditingStyleNone; \
} \
return UITableViewCellEditingStyleDelete; \
} \
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
\
} \
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath \
{ \
UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) { \
NSLog(@"删除"); \
[self deleteDataWithIndexPath:indexPath]; \
}]; \
deleteAction.backgroundColor = [UIColor color255WithRed:255 green:0 blue:0 alpha:0.5]; \
\
return @[deleteAction]; \
}


#pragma mark - Constants

#define kPageSize 10

#define kLastLoginUserName       @"kLastLoginUserName"

#define kUserLoginSuccess        @"kUserLoginSuccess"
#define kUserLogoutSuccess       @"kUserLogoutSuccess"

#define UMengAliasType    @"rockyye"
#define UMengAppKey       @"5864b76607fe65104300002d"
#define UMentAppSecretKey @"0svizebr9mzkuzcot3i6akktk3jdjwl5"

#define BuglyAppID        @"b9c0305a36"
#define JSPatchAppKey     @"cbb39a8d2ff93fd5"

#define kServerBaseUrl    @"http://139.199.186.81:8080"

// 用户

#define kGetVerifyCodePath    @"/cgi-bin/user/getverificationcode"
#define kSignUpUserPath       @"/cgi-bin/user/signup" // 注册
#define kSignInPath           @"/cgi-bin/user/signin" // 登录
#define kSignOutPath          @"/cgi-bin/user/signout" // 登出
#define kSignUpMeetingPath    @"/cgi-bin/user/signupmeeting" // 分配会议室管理员
#define kSignUpTrainingPath   @"/cgi-bin/user/signuptraining" // 分配培训管理员
#define kSignUpVerifyPath     @"/cgi-bin/user/signupverify" // 分配审核管理员

#define kGetUserInfoPath      @"/cgi-bin/user/getuser" // 获取用户信息

#define kModifyPasswordPath   @"/cgi-bin/user/changepwd" // 修改密码
#define kResetPasswordPath    @"/cgi-bin/user/resetpwd" // 超级管理员重置别人密码

#define kAuditPath            @"/cgi-bin/user/audit" // 审核用户
#define kGetUnauditedPath     @"/cgi-bin/user/getunaudited" // 获取待审核的用户列表

#define kGetAdminListPath     @"/cgi-bin/user/getmanagerlist" // 获取会议室管理员、课程管理员列表
#define kDeleteAdminPath      @"/cgi-bin/user/deletemanager" // 删除管理员

// 单位
#define kGetDepartmentsPath   @"/cgi-bin/department/getdepartment" // 获取单位列表

// 培训课程
#define kAddCoursePath        @"/cgi-bin/course/addcourse" // 添加培训课程
#define kEditCoursePath       @"/cgi-bin/course/editcourse" // 编辑课程
#define kDeleteCoursePath     @"/cgi-bin/course/deletecourse" // 删除培训课程
#define kGetCourseListPath    @"/cgi-bin/course/getcourselist" // 获取课程列表
#define kGetCourseDetailPath  @"/cgi-bin/course/getcoursedetail" // 获取课程详情
#define kVerifyCoursePath     @"/cgi-bin/course/verifycourse" // 审核课程

// 随手拍
#define kAddSummaryPath         @"/cgi-bin/summary/addsummary" // 添加培训课程
#define kEditSummaryPath        @"/cgi-bin/summary/editsummary" // 编辑课程
#define kDeleteSummaryPath      @"/cgi-bin/summary/deletesummary" // 删除培训课程
#define kGetSummaryListPath     @"/cgi-bin/summary/getsummarylist" // 获取课程列表
#define kGetSummaryDetailPath   @"/cgi-bin/summary/getsummarydetail" // 获取课程详情
#define kGetSummaryThemeListPath @"/cgi-bin/summary/getsummarythemelist" // 获取主题列表
#define kVerifySummaryPath       @"/cgi-bin/summary/verifysummary" // 审核随手拍

// 课程资料
#define kAddMaterialPath        @"/cgi-bin/material/addmaterial" // 添加资料
#define kEditMaterialPath       @"/cgi-bin/material/editmaterial" // 编辑资料
#define kDeleteMaterialPath     @"/cgi-bin/material/deletematerial" // 删除资料
#define kGetMaterialListPath    @"/cgi-bin/material/getmateriallist" // 获取资料
#define kGetMaterialDetailPath  @"/cgi-bin/material/getmaterialdetail" // 获取资料详情
#define kVerifyMaterialPath     @"/cgi-bin/material/verifymaterial" // 审核资料

// 报名参加
#define kAddApplyPath         @"/cgi-bin/apply/addapply" // 报名参加培训
#define kDeleteApplyPath      @"/cgi-bin/apply/deleteapply" // 取消报名
#define kGetApplyStatusPath   @"/cgi-bin/apply/getapplystatus" // 获取报名状态
#define kGetApplyListPath     @"/cgi-bin/apply/getapplylist" // 获取我的报名列表接口

// 会议室
#define kGetMeetingRoomListPath @"/cgi-bin/meetingroom/getmeetingroom" // 获取会议室列表

// 会议室安排
#define kGetArrangementListPath @"/cgi-bin/roomarrangement/getarrangementlist" // 获取会议室安排列表
#define kAddArrangementPath         @"/cgi-bin/roomarrangement/addarrangement" // 添加安排
#define kEditArrangementPath        @"/cgi-bin/roomarrangement/editarrangement" // 修改安排
#define kDeleteArrangementPath      @"/cgi-bin/roomarrangement/deletearrangement" // 删除安排

// 上传
#define kUploadSummaryFilePath      @"/cgi-bin/file/uploadfile"
#define kUploadMaterialFilePath     @"/cgi-bin/file/uploadmaterial"

// 导出
#define kExportCoursePath           @"/cgi-bin/exportdata/exportcourse"
#define kExportSummaryPath          @"/cgi-bin/exportdata/exportsummary"
#define kExportRoomArrangementPath  @"/cgi-bin/exportdata/exportroomarrangement"

// 消息
#define kGetMessageListPath         @"/cgi-bin/message/getmessagelist"
#define kDeleteMessagePath          @"/cgi-bin/message/deletemessage"


#endif /* TrainingConstants_h */
