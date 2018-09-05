//
//  DemoListViewController.m
//  ProductDemo
//
//  Created by qizd on 2018/6/13.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "DemoListViewController.h"
#import "TestPermissionViewController.h"
#import "TransitionFirstViewController.h"
#import "CollectionViewDemoController.h"
#import "RoundedImageController.h"
#import "SingletonViewController.h"
#import "ZDCycleScrollView.h"


@interface DemoListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *tmp;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation DemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%f, %@", IOS_VERSION_FLOAT, CurrentSystemVersion);
    
    self.title = @"DEMO列表";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dataArray = [NSArray arrayWithObjects:@"测试权限", @"自定义跳转动画present、push", @"Collection轮播与Edit", @"图片圆角", @"单例模式", nil];
    
    self.title = self.tmp;
    ZDCycleScrollView *cycleView = [[ZDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[TestPermissionViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[TransitionFirstViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[CollectionViewDemoController alloc] init] animated:YES];
            break;
        case 3:
        {
            RoundedImageController *roundedImageVC = [[RoundedImageController alloc] initWithNibName:@"RoundedImageController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:roundedImageVC animated:YES];
        }
            break;
        case 4:
        {
            SingletonViewController *singleVC = [[SingletonViewController alloc] init];
            [self.navigationController pushViewController:singleVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

@end
