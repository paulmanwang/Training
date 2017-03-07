//
//  MyTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyTrainingMainViewController.h"
#import "MyTrainingViewController.h"
#import "TrainingSearchViewController.h"

@interface MyTrainingMainViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, WLCSegmentedControlDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) WLCSegmentedControl *segmentedControl;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *viewControllers;

@property (assign, nonatomic) NSInteger lastSelectedIndex;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign, nonatomic) BOOL isInitionlized;

@end

@implementation MyTrainingMainViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"我报名的培训";
    self.hidesBottomBarWhenPushed = YES;
    self.viewControllers = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *viewControllers = [self configViewControllers];
    [self.viewControllers addObjectsFromArray:viewControllers];
    
    [self configPageViewController];
    
    [self configSegmentedControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isInitionlized) {
        UIView *whiteLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38.8, self.segmentedControl.width, 1.2)];
        whiteLineView.backgroundColor = [UIColor whiteColor];
        whiteLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.segmentedControl addSubview:whiteLineView];
        
        UIImageView *slider = [self.segmentedControl valueForKey:@"sliderImageView"];
        [self.segmentedControl bringSubviewToFront:slider];
        
        self.isInitionlized = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)configPageViewController
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)configSegmentedControl
{
    self.segmentedControl = [[WLCSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    self.segmentedControl.backgroundColor = [UIColor color255WithRed:210 green:221 blue:228];
    self.segmentedControl.fontColor = [UIColor blackColor];
    self.segmentedControl.selectedFontColor = [UIColor color255WithRed:42 green:142 blue:188];
    self.segmentedControl.dividerWidth = 0;
    self.segmentedControl.sliderColor = [UIColor color255WithRed:42 green:142 blue:188];
    self.segmentedControl.sliderBottomMargin = 0;
    self.segmentedControl.sliderHeight = 1.2;
    self.segmentedControl.sliderWidth = [UIScreen mainScreen].bounds.size.width / 2.0;
    
    self.segmentedControl.delegate = self;
    
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.viewControllers) {
        [titles addObject:vc.title];
    }
    [self.segmentedControl setTitles:titles];
    
    [self.view addSubview:self.segmentedControl];
    
    self.lastSelectedIndex = 0;
}

- (NSArray *)configViewControllers
{
    MyTrainingViewController *trainingVC1 = [MyTrainingViewController new];
    trainingVC1.title = @"未开始";
    trainingVC1.isExpired = 0;
    MyTrainingViewController *trainingVC2 = [MyTrainingViewController new];
    trainingVC2.title = @"已结束";
    trainingVC2.isExpired = 1;
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    [viewControllers addObject:trainingVC1];
    [viewControllers addObject:trainingVC2];
    
    return @[trainingVC1, trainingVC2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    MyTrainingViewController *searchVC = [MyTrainingViewController new];
    searchVC.isExpired = self.segmentedControl.selectedSegmentIndex;
    searchVC.isSearch = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - WLCSegmentedControlDelegate

- (void)segmentedValueChanged:(id)sender
{
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    if (selectedIndex == self.lastSelectedIndex) {
        return;
    }
    
    UIPageViewControllerNavigationDirection direction = selectedIndex > self.lastSelectedIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    [self.pageViewController setViewControllers:@[self.viewControllers[selectedIndex]] direction:direction animated:YES completion:nil];
    
    self.lastSelectedIndex = selectedIndex;
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    
    index--;
    return self.viewControllers[index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    
    index++;
    return self.viewControllers[index];
}

#pragma mark - UIPageViewControllerDeleagte

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.segmentedControl.selectedSegmentIndex = [self.viewControllers indexOfObject:pageViewController.viewControllers[0]];
    self.lastSelectedIndex = self.segmentedControl.selectedSegmentIndex;
}

@end
