//
//  VersionCompatibleController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2021/7/5.
//  Copyright © 2021 qizd. All rights reserved.
//

#import "VersionCompatibleController.h"
#import "PopoverControllerControllerDemo.h"

@interface VersionCompatibleController () <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSString *tmp;

@property (nonatomic, strong) NSArray<NSString *> *dataArray;

@end

@implementation VersionCompatibleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [NSArray arrayWithObjects:@"PopView in Ipad", nil];
    [self.view addSubview:self.tableView];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VersionCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *name = self.dataArray[indexPath.row];
    cell.textLabel.text = name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *method = self.dataArray[indexPath.row];
    if ([method isEqualToString:@"PopView in Ipad"]) {
        PopoverControllerControllerDemo *VC = [[PopoverControllerControllerDemo alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
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
