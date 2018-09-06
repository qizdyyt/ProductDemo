//
//  ZDCircleScrollController.m
//  ProductDemo
//
//  Created by qizd on 2018/9/6.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDCircleScrollController.h"
#import "ZDCycleScrollView.h"

@interface ZDCircleScrollController ()

@end

@implementation ZDCircleScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"轮播图";
    
    ZDCycleScrollView *cycleView = [[ZDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [self.view addSubview:cycleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
