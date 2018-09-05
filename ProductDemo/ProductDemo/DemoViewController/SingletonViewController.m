//
//  SingletonViewController.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "SingletonViewController.h"
#import "Singleton.h"

@interface SingletonViewController ()

@property (nonatomic, strong) UILabel *label;
@end

@implementation SingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"初始化多个单例后的地址";
    // Do any additional setup after loading the view.
    Singleton *single = [[Singleton alloc] init];
    single.singleName = @"name";
    
    Singleton *single1 = [[Singleton alloc] init];
    single1.singleName = @"single1";
    
    Singleton *single2 = [[Singleton alloc] init];
    single2.singleName = @"single2";
    NSString *string = [NSString stringWithFormat:@"%@-----%p------%p-----%p", single.singleName, single, single1, single2];
    
    NSLog(@"%@", string);
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.label];
    self.label.text = string;
    self.label.numberOfLines = 0;
    
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
