//
//  RoomAdminMainViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MRAMainViewController.h"
#import "AllocateRoomViewController.h"
#import "MeetingRoomCollectionViewCell.h"
#import "RoomInfoTableViewCell.h"
#import "WLCDatePicker.h"
#import "TrainingManager+MeetingRoom.h"
#import "TrainingManager+RoomArrangement.h"
#import "MeetingRoomInfo.h"

@interface MRAMainViewController ()<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *timeTextField;

@property (strong, nonatomic) NSMutableArray *meetingRoomList;
@property (assign, nonatomic) NSInteger selectedTime;
@property (assign, nonatomic) BOOL finishedQuery;

@end

@implementation MRAMainViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"首页";
    self.meetingRoomList = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MeetingRoomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MeetingRoomCollectionViewCell"];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    self.dateTextField.text = [formatter stringFromDate:currentDate];
    
    self.selectedTime = 1;
    self.timeTextField.text = @"上午";
    
    [self queryMeetingRooms];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.finishedQuery) {
        [self queryArrangements];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)queryMeetingRooms
{
    [self showLoadingViewWithText:@"正在加载..."];
    [[TrainingManager sharedInstance] queryMeetingRoomsWithCompletion:^(NSError *error, NSArray *meetingRoomList) {
        [self dismissLoadingView];
        if (meetingRoomList.count == 0 || error) {
            [WLCToastView toastWithMessage:@"加载失败" error:error];
            return;
        }
        
        [self.meetingRoomList addObjectsFromArray:meetingRoomList];
        [self.collectionView reloadData];
        
        [self queryArrangements];
    }];
}

- (void)queryArrangements
{
    NSString *dateString = self.dateTextField.text;
    [[TrainingManager sharedInstance] queryRoomArrangementListWithDate:dateString
                                                                  time:self.selectedTime
                                                            completion:^(NSError *error, NSArray *idleList, NSArray *arrangementList)
    {
        if (error) {
            return;
        }
        
        self.finishedQuery = YES;
        
        for (MeetingRoomInfo *roomInfo in self.meetingRoomList) {
            roomInfo.idle = NO;
            NSInteger roomId = roomInfo.roomId;
            for (NSNumber *number in idleList) {
                if (roomId == number.integerValue) {
                    roomInfo.idle = YES;
                }
            }
            if (roomInfo.idle == NO) {
                for (RoomArrangementInfo *arrangementInfo in arrangementList) {
                    if (roomId == arrangementInfo.roomId) {
                        roomInfo.arrangementInfo = arrangementInfo;
                    }
                }
            }
        }
        
        [self.collectionView reloadData];
    }];
}

- (void)allocateMeetingRoom:(MeetingRoomInfo *)roomInfo
{
    AllocateRoomViewController *allocateVC = [AllocateRoomViewController new];
    allocateVC.arrangementDate = self.dateTextField.text;
    allocateVC.arrangementTime = self.selectedTime;
    allocateVC.roomId = roomInfo.roomId;
    allocateVC.title = roomInfo.roomName;
    [self.navigationController pushViewController:allocateVC animated:YES];
}

- (void)modifyArragementInfo:(MeetingRoomInfo *)info
{
    AllocateRoomViewController *allocateVC = [AllocateRoomViewController new];
    allocateVC.arrangementDate = self.dateTextField.text;
    allocateVC.arrangementTime = self.selectedTime;
    allocateVC.roomId = info.roomId;
    allocateVC.title = info.roomName;
    allocateVC.arrangementInfo = info.arrangementInfo;
    
    [self.navigationController pushViewController:allocateVC animated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.dateTextField) {
        [WLCDatePicker showDatePickerOnViewContoller:self.tabBarController withMode:UIDatePickerModeDate doneBlock:^(NSString *timeString) {
            textField.text = timeString;
            [self queryArrangements];
        } cancelBlock:nil];
    }
    else {
        NSArray *timeList = @[@"上午", @"下午", @"晚上"];
        [WLCPickerView showPickerViewOnViewController:self.tabBarController
                                         withDataList:timeList
                                        selectedIndex:self.selectedTime-1
                                            doneBlock:^(NSInteger selectedIndex)
         {
            textField.text = timeList[selectedIndex];
            self.selectedTime = selectedIndex + 1;
            [self queryArrangements];
        } cancelBlock:nil];
    }
    
    return NO;
}

#pragma mark - UICollectionViewDataSource && delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.meetingRoomList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingRoomCollectionViewCell" forIndexPath:indexPath];
    MeetingRoomInfo *info = self.meetingRoomList[indexPath.row];
    cell.roomNameLabel.text = info.roomName;
    if (self.finishedQuery) {
        UIColor *color = nil;
        if (info.idle) {
             color = [UIColor color255WithRed:0 green:255 blue:0 alpha:0.5f];
        }
        else {
            if (info.arrangementInfo.useType == 1) {
                color = [UIColor color255WithRed:255 green:0 blue:0 alpha:0.5f];
            }
            else {
                color = [UIColor yellowColor];
            }
        }
        [cell setRoomColor:color];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingRoomInfo *info = self.meetingRoomList[indexPath.row];
    if (info.idle) {
        [self allocateMeetingRoom:info];
    }
    else {
        [self modifyArragementInfo:info];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(76, 38);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat dist = (collectionView.width - 4 * 76)/5.0;
    return UIEdgeInsetsMake(12, dist, 0, dist);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (collectionView.width - 4 * 76)/5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

@end
