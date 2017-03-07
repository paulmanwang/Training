//
//  WLCDatePicker.m
//  Training
//
//  Created by lichunwang on 16/12/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCDatePicker.h"

static NSMutableDictionary *datePickerDic;

@interface WLCDatePicker ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation WLCDatePicker

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
//    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [self.datePicker setMinimumDate:[dateFormatter dateFromString:@"2015-01-01"]];
//    [self.datePicker setMaximumDate:[dateFormatter dateFromString:@"2020-01-01"]];
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
    if (self == [WLCDatePicker class]) {
        datePickerDic = [NSMutableDictionary new];
    }
}

+ (instancetype)wlcDatePicker
{
    return (WLCDatePicker *)[UIView viewWithNib:@"WLCDatePicker" owner:nil];
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

+ (instancetype)showDatePickerOnViewContoller:(UIViewController *)viewController
                                     withMode:(UIDatePickerMode)mode
                                    doneBlock:(WLCDatePickerDoneBlock)doneBlock
                                  cancelBlock:(void(^)(void))cancelBlock
{
    WLCDatePicker *datePicker = [WLCDatePicker wlcDatePicker];
    datePicker.datePicker.datePickerMode = mode;
    datePicker.doneBlock = doneBlock;
    datePicker.cancelBlock = cancelBlock;
    datePicker.datePicker.minimumDate = [NSDate date];
    
    UIView *controllerView = viewController.view;
    datePicker.frame = controllerView.bounds;
    [controllerView addSubview:datePicker];
    [datePicker show];
    
    return datePicker;
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

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (self.datePicker.datePickerMode == UIDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (self.datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    NSString *strTime = [dateFormatter stringFromDate:self.datePicker.date];
    if (self.doneBlock) {
        self.doneBlock(strTime);
    }
}

- (IBAction)onCancelButtonClicked:(id)sender
{
    [self dismiss];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
