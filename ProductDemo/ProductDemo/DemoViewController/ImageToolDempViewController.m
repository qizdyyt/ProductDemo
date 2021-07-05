//
//  ImageToolDempViewController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2021/4/16.
//  Copyright © 2021 qizd. All rights reserved.
//

#import "ImageToolDempViewController.h"
#import "UIImage+Tools.h"

#define imgH 300
@interface ImageToolDempViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat combineImageHeight;
}
@property (nonatomic, retain)NSMutableArray<UIImage*> *oriImageViewArr;

@property (nonatomic, retain)UIImageView *comImageV;
@property (nonatomic, retain)NSMutableArray *markImageArr;
@property (nonatomic, retain)NSMutableArray *markTextArr;

@property (nonatomic, retain)UITableView *myTableView;


@end

@implementation ImageToolDempViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Image show";
    self.markTextArr = [NSMutableArray array];
    for (int i = 1; i<5; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@".jpeg"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [self.oriImageViewArr addObject:image];
        [self.markTextArr addObject:@"image aaas"];
    }
    for (int i = 1; i<5; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"bg%d", i] ofType:@".png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [self.oriImageViewArr addObject:image];
        [self.markTextArr addObject:@"image aaas"];
    }
    
    combineImageHeight = 0;
    CGFloat imageItemWidth = ScreenWidth / 2;
    
    CGFloat maxImageHeightForRow = 0;
    NSMutableArray *imageItemHeightArr = [NSMutableArray array];
    
    for (int i = 0; i<self.oriImageViewArr.count; i++) {
        if (i % 2 == 0 && i>0) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
            maxImageHeightForRow = 0;
        }
        UIImage *image = self.oriImageViewArr[i];
        CGSize imgSize = image.size;
        
        CGFloat scale = imageItemWidth / image.size.width;
        CGFloat imageItemHeigth = imgSize.height * scale;
        if (maxImageHeightForRow < imageItemHeigth) {
            maxImageHeightForRow = imageItemHeigth;
        }
        if (i == self.oriImageViewArr.count - 1) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
        }
    }
    
    combineImageHeight =1000;
    
    self.markImageArr = [NSMutableArray array];

    for (UIImage *image in self.oriImageViewArr) {
        UIImage *tmpImg = [image waterMarkWithText_New2:@"123123123123"];
        [self.markImageArr addObject:tmpImg];
    }
    //    self.comImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    //    [self.view addSubview:self.comImageV];
//    self.comImageV.image = [UIImage combineImagesVersion2:self.markImageArr];

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor darkGrayColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
        UIImageView *oriImage = [[UIImageView alloc] init];
        oriImage.contentMode = UIViewContentModeScaleAspectFit;
        oriImage.tag = 101;
        cell.contentView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:oriImage];
        
    }
    
    UIImageView *oriImage = [cell viewWithTag:101];
    UIImage *img = NULL;
    if (indexPath.row == 0) {
        img = [UIImage combineImagesVersion3:self.markImageArr withText:self.markTextArr];
        oriImage.frame = CGRectMake(0, 0, ScreenWidth, combineImageHeight);
    }else {
        img = self.oriImageViewArr[indexPath.row - 1];
        img = [img waterMarkWithText_New2:@"123123123123"];
        oriImage.frame = CGRectMake(0, 0, ScreenWidth, imgH);
    }
    oriImage.image =img;
   
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oriImageViewArr.count + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return combineImageHeight;
    }
    return imgH;
}

- (NSMutableArray<UIImage *> *)oriImageViewArr {
    if (_oriImageViewArr == nil) {
        _oriImageViewArr = [NSMutableArray array];
    }
    return _oriImageViewArr;
}
@end
