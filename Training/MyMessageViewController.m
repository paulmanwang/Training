//
//  MyMessageViewController.m
//  Training
//
//  Created by lichunwang on 16/12/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MessageTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "TrainingManager+Message.h"
#import "MessageInfo.h"
#import "TrainingDetailViewController.h"

@interface MyMessageViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) NSInteger currentPageNum;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation MyMessageViewController

WLC_OBJECT_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"我的消息";
    self.dataList = [NSMutableArray new];
    
    [self showLoadingViewWithText:@"正在加载..."];
    [self queryDataListWithPageNum:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MessageTableViewCell registerForTableView:self.tableView];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    NSArray *internalTargets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
//    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
//    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
//    panGestureRecognizer.delegate = self;
//    [panGestureRecognizer addTarget:internalTarget action:internalAction];
//    [self.navigationController.interactivePopGestureRecognizer.view addGestureRecognizer:panGestureRecognizer];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    // Ignore when no view controller is pushed into the navigation stack.
//    if (self.navigationController.viewControllers.count <= 1) {
//        return NO;
//    }
//    
//    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
//    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
//    CGFloat maxAllowedInitialDistance = 0;
//    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
//        return NO;
//    }
//    
//    // Ignore pan gesture when the navigation controller is currently in transition.
//    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
//        return NO;
//    }
//    
//    // Prevent calling the handler when the gesture begins in an opposite direction.
//    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
//    if (translation.x <= 0) {
//        return NO;
//    }
//    
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Header && Footer

- (void)addRefreshHeader
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            [self queryDataListWithPageNum:1];
        }
    }];
}

- (void)addRefreshFooter
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            if (self.dataList.count == self.currentPageNum * kPageSize) {
                ((MJRefreshAutoNormalFooter *)self.tableView.mj_footer).stateLabel.text = @"正在加载更多的数据...";
                [self queryDataListWithPageNum:self.currentPageNum+1];
            }
            else {
                [self.tableView.mj_footer endRefreshing];
                ((MJRefreshAutoNormalFooter *)self.tableView.mj_footer).stateLabel.text = @"暂无更多";
            }
        }
    }];
    
    // 默认设置为隐藏
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - Private

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    
    [[TrainingManager sharedInstance] queryMessageListWithPageNum:pageNum pageSize:kPageSize completion:^(NSError *error, NSArray *dataList) {
        [self dismissLoadingView];
        self.isLoadingData = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [WLCToastView toastWithMessage:@"加载失败" error:error];
            [WLCEmptyView showOnView:self.view withText:@"暂无消息" icon:@"message_icon"];
            return;
        }
        
        self.currentPageNum = pageNum;
        if (pageNum == 1) {
            [self.dataList removeAllObjects];
            if (dataList.count < kPageSize) {
                self.tableView.mj_footer.hidden = YES;
            }
            else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        [self.dataList addObjectsFromArray:dataList];
        [self.tableView reloadData];
        
        if (self.dataList.count == 0) {
            [WLCEmptyView showOnView:self.view withText:@"暂无消息" icon:@"message_icon"];
        }
        else {
            [self dismissEmptyView];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [MessageTableViewCell dequeueReusableCellForTableView:tableView];
    MessageInfo *info = self.dataList[indexPath.row];
    [cell setMessageInfo:info];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *info = self.dataList[indexPath.row];
    if (info.messageType != 3) {
        TrainingDetailViewController *detailVC = [TrainingDetailViewController new];
        detailVC.cid = info.cid;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteDataWithIndexPath:indexPath];
    }];
    deleteAction.backgroundColor = [UIColor color255WithRed:255 green:0 blue:0 alpha:0.5];
    
    return @[deleteAction];
}

- (void)deleteDataWithIndexPath:(NSIndexPath *)indexPath
{   
    self.selectedIndexPath = indexPath;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要删除该消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    MessageInfo *info = self.dataList[self.selectedIndexPath.row];
    [self showLoadingViewWithText:@"正在删除..."];
    [[TrainingManager sharedInstance] deleteMessageWithMId:info.mid completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"删除失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"删除成功"];
            for (NSInteger i = 0; i < self.dataList.count; i++) {
                MessageInfo *tmpInfo = self.dataList[i];
                if ([tmpInfo.mid isEqualToString:info.mid]) {
                    [self.dataList removeObject:tmpInfo];
                    break;
                }
            }
            
            if (self.dataList.count == 0) {
                [WLCEmptyView showOnView:self.view withText:@"暂无消息" icon:@"message_icon"];
            }
            
            [self.tableView reloadData];
        }
    }];
}

@end
