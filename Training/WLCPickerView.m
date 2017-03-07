//
//  WLCDatePicker.m
//  Training
//
//  Created by lichunwang on 16/12/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCPickerView.h"
#import "CourseInfo.h"

static NSMutableDictionary *datePickerDic;

@interface WLCPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (copy, nonatomic) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation WLCPickerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
//    NSDate *currentTime = [NSDate date];
//    [self.datePicker setDate:currentTime animated:YES];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [self.datePicker setMinimumDate:[dateFormatter dateFromString:@"2015-01-01"]];
//    [self.datePicker setMaximumDate:[dateFormatter dateFromString:@"2020-01-01"]];
//    self.datePicker.maximumDate = currentTime;
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    [self dismiss];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

+ (void)initialize
{
    // 如果有子类继承，会导致多次调用，这里做一次防护。这里没有子类继承，没有必要
    if (self == [WLCPickerView class]) {
        datePickerDic = [NSMutableDictionary new];
    }
}

+ (instancetype)wlcPickerView
{
    return (WLCPickerView *)[UIView viewWithNib:@"WLCPickerView" owner:nil];
}

- (void)show
{
    self.containerView.top = self.bottom;
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.bottom = self.bottom;
    }];
}

- (void)dismiss
{
    CGFloat orgBottom = self.containerView.bottom;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.top = orgBottom;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (instancetype)showPickerViewOnViewController:(UIViewController *)viewController
                                  withDataList:(NSArray *)dataList
                                 selectedIndex:(NSInteger)selectedIndex
                                     doneBlock:(void(^)(NSInteger selectedIndex))doneBlock
                                   cancelBlock:(void(^)(void))cancelBlock
{
    WLCPickerView *pickerView = [WLCPickerView wlcPickerView];
    pickerView.doneBlock = doneBlock;
    pickerView.cancelBlock = cancelBlock;
    pickerView.dataList = dataList;
    [pickerView.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
    
    UIView *controllerView = viewController.view;
    pickerView.frame = controllerView.bounds;
    [controllerView addSubview:pickerView];
    [pickerView show];
    
    return pickerView;
}

//+ (void)dismissDatePickerOnViewController:(UIViewController *)viewController
//                           withCompletion:(void(^)(void))completion
//{
//    NSString *key = [NSString stringWithFormat:@"%@", viewController];
//    NSLog(@"key2 = %@", key);
//    WLCDatePicker *datePicker = datePickerDic[key];
//    if (datePicker) {
//        UIView *controllerView = viewController.view;
//        [UIView animateWithDuration:0.3 animations:^{
//            datePicker.containerView.top = controllerView.bottom;
//        } completion:^(BOOL finished) {
//            [datePicker removeFromSuperview];
//            [datePickerDic removeObjectForKey:key];
//            
//            if (completion) {
//                completion();
//            }
//        }];
//    }
//    else {
//        NSLog(@"cannot find date picker");
//    }
//}

- (IBAction)onDoneButtonClicked:(id)sender
{
    [self dismiss];
    
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    if (self.doneBlock) {
        self.doneBlock(selectedIndex);
    }
}

- (IBAction)onCancelButtonClicked:(id)sender
{
    [self dismiss];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    id object = self.dataList[row];
    if ([object isKindOfClass:[NSString class]]) {
        title = self.dataList[row];
    }
    else if ([object isKindOfClass:[DepartmentInfo class]]) {
        DepartmentInfo *info = self.dataList[row];
        title = info.departmentName;
    }
    else {
        CourseInfo *curseInfo = self.dataList[row];
        title = curseInfo.theme;
    }
    
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:kGlobalTextColor}];
}

@end
