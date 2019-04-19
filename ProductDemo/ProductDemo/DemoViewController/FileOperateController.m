//
//  FileOperateController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2019/4/9.
//  Copyright © 2019 qizd. All rights reserved.
//

#import "FileOperateController.h"

@interface FileOperateController ()

@property (nonatomic, strong) UIButton* moveButton;
@end

@implementation FileOperateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moveButton.frame = CGRectMake(100, 100, 100, 100);
    [self.moveButton setTitle:@"Move" forState:UIControlStateNormal];
    self.moveButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.moveButton];
    [self filePath];
    [self.moveButton addTarget:self action:@selector(move) forControlEvents:UIControlEventTouchUpInside];
}

-(void)move{
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:[self filePath] toPath:[self toFilePath] error:&error];
    NSLog(@"%@", error.localizedDescription);
}

-(NSString *)filePath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                            , NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/EMUserPackage.db", docDir];
    return filePath;
}

-(NSString *)toFilePath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory
                                                            , NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/EMUserPackage.db", docDir];
    return filePath;
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
