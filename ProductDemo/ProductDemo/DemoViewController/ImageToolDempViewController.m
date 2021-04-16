//
//  ImageToolDempViewController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2021/4/16.
//  Copyright © 2021 qizd. All rights reserved.
//

#import "ImageToolDempViewController.h"
#import "UIImage+Tools.h"

@interface ImageToolDempViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain)NSMutableArray<UIImage*> *oriImageViewArr;
@property (nonatomic, retain)UIImageView *markImageView;

@property (nonatomic, retain)UITableView *myTableView;
@end

@implementation ImageToolDempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Image show";
    
    for (int i = 1; i<5; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@".jpeg"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [self.oriImageViewArr addObject:image];
    }
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.myTableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIImageView *oriImage = [[UIImageView alloc] initWithImage:self.oriImageViewArr[indexPath.row]];
        oriImage.contentMode = UIViewContentModeScaleAspectFit;
        oriImage.tag = 101;
        
        UIImage *img = self.oriImageViewArr[indexPath.row];
        img = [img waterMarkWithText:@"123123"];
        oriImage.image =img;
        oriImage.frame = CGRectMake(0, 0, ScreenWidth, 200);
        [cell addSubview:oriImage];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oriImageViewArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (NSMutableArray<UIImage *> *)oriImageViewArr {
    if (_oriImageViewArr == nil) {
        _oriImageViewArr = [NSMutableArray array];
    }
    return _oriImageViewArr;
}
@end
