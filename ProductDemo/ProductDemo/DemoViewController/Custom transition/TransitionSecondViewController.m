//
//  TransitionSecondViewController.m
//  ProductDemo
//
//  Created by qizd on 2018/7/11.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "TransitionSecondViewController.h"

@interface TransitionSecondViewController ()
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation TransitionSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.imageView];
    self.imageView.image = [UIImage imageNamed:@"bg2"];
    
    UIButton * dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    dismissButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:dismissButton];
    dismissButton.backgroundColor = [UIColor blackColor];
    [dismissButton setTitle:@"dismissClick" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
