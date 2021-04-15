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
#import "ZDCircleScrollController.h"
#import "AttributedTextViewController.h"
#import "CollectionAndTable.h"
#import "LayoutTestController.h"
#import "FileOperateController.h"
#import "FontTestViewController.h"
#import "FileTools.h"
#import "NSStringUseAndDisplayController.h"

#import "NSString+Fmt.h"


@interface DemoListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *tmp;

@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@end

@implementation DemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%f, %@", IOS_VERSION_FLOAT, CurrentSystemVersion);
    
    self.title = @"DEMO列表";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dataArray = [NSArray arrayWithObjects:@"字符串各种操作", @"图片各种处理：水印、分割、压缩等", @"测试权限", @"自定义跳转动画present、push", @"Collection轮播与Edit", @"图片圆角", @"单例模式", @"轮播图", @"多样式的字符串", @"tableView嵌套CollectionView", @"layout", @"文件操作", @"动态字体测试", nil];
    
    self.title = [self.title substringToIndex:[self.title length] - 3];
    
    
    
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    [FileTools showAllFileWithPath:docDir WithSuffix:@"jpg"];
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
    NSString *method = self.dataArray[indexPath.row];
    if ([method isEqualToString:@"测试权限"]) {
        [self.navigationController pushViewController:[[TestPermissionViewController alloc] init] animated:YES];
    }else if ([method isEqualToString:@"自定义跳转动画present、push"]) {
        [self.navigationController pushViewController:[[TransitionFirstViewController alloc] init] animated:YES];
    }else if ([method isEqualToString:@"Collection轮播与Edit"]) {
        [self.navigationController pushViewController:[[CollectionViewDemoController alloc] init] animated:YES];
    }else if ([method isEqualToString:@"图片圆角"]) {
        RoundedImageController *roundedImageVC = [[RoundedImageController alloc] initWithNibName:@"RoundedImageController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:roundedImageVC animated:YES];
    }else if ([method isEqualToString:@"单例模式"]) {
        SingletonViewController *singleVC = [[SingletonViewController alloc] init];
        [self.navigationController pushViewController:singleVC animated:YES];
    }else if ([method isEqualToString:@"轮播图"]) {
        ZDCircleScrollController *cirlceScrollVC = [[ZDCircleScrollController alloc] init];
        [self.navigationController pushViewController:cirlceScrollVC animated:YES];
    }else if ([method isEqualToString:@"多样式的字符串"]) {
        AttributedTextViewController *VC = [[AttributedTextViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([method isEqualToString:@"tableView嵌套CollectionView"]) {
        CollectionAndTable *VC = [[CollectionAndTable alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([method isEqualToString:@"layout"]) {
        LayoutTestController *VC = [[LayoutTestController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([method isEqualToString:@"文件操作"]) {
        FileOperateController *VC = [[FileOperateController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([method isEqualToString:@"动态字体测试"]) {
        FontTestViewController *VC = [[FontTestViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([method isEqualToString:@"字符串各种操作"]){
        NSStringUseAndDisplayController *VC = [[NSStringUseAndDisplayController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
