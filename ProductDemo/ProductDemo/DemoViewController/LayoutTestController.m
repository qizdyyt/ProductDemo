//
//  LayoutTestController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2019/3/20.
//  Copyright © 2019 qizd. All rights reserved.
//

#import "LayoutTestController.h"
#import "Masonry.h"
#import "LayoutCellTest.h"

@interface LayoutTestController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation LayoutTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight - 100)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(12));
        make.left.equalTo(@(12));
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LayoutCellTest" bundle:nil] forCellReuseIdentifier:@"ide"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellID = @"CellID";
//    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
    LayoutCellTest *cell = [tableView dequeueReusableCellWithIdentifier:@"ide" forIndexPath:indexPath];
    
//    cell.textLabel.text = @"2212";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    NSLog(@"%f", scrollView.contentOffset.y);
    self.imageV.image = [UIImage imageNamed:@"ice_icon"];
    [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(12));
        make.left.equalTo(@(12 + scrollView.contentOffset.y));
        make.width.equalTo(@(100));
        make.height.equalTo(@(100 + scrollView.contentOffset.y));
    }];
//    [self.view updateConstraints];
}
@end
