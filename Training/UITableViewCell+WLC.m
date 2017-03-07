//
//  UITableViewCell+WLC.m
//  Training
//
//  Created by lichunwang on 17/1/12.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "UITableViewCell+WLC.h"
#import "NSObject+MethodSwizzle.h"
#import <objc/runtime.h>

@implementation UITableViewCell (WLC)

// 为什么不行，每个UIViewController一定会重载viewDidLoad方法，但是并不是每个cell都重载awakeFromNib方法
+ (void)load
{
    // load方法只会调用一次，因此这里dispatch_once没有必要，加上也无所谓
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethod:@selector(awakeFromNib)
               withNewInstanceMethod:@selector(wlc_awakeFromNib)];
    
//        Class class = [self class];
//        
//        SEL originalSelector = @selector(awakeFromNib);
//        SEL swizzledSelector = @selector(wlc_awakeFromNib);
//        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        // YES if the method was added successfully, otherwise NO (for example, the class already contains a method implementation with that name).
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else { // 失败的话说明该方法已存在，所以可以直接替换
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
    });
}

- (void)wlc_awakeFromNib
{
    [self wlc_awakeFromNib];
    
//    [self traverseSubViewWithBlock:^(UIView *subView) {
//        if ([subView isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel *)subView;
//            label.textColor = [UIColor redColor];
//        }
//    }];
}

@end
