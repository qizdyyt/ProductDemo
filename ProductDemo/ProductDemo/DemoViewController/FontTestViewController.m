//
//  FontTestViewController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2019/8/27.
//  Copyright © 2019 qizd. All rights reserved.
//

#import "FontTestViewController.h"
#import "IconUtil.h"
#import <CoreText/CoreText.h>

@interface FontTestViewController ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, assign) BOOL def;
@property (nonatomic, assign) CGFontRef fontRef;
@end

@implementation FontTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor blueColor];
    self.button.frame = CGRectMake(100, 100, 100, 100);
    [self.button setTitle:@"换字体" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(changeFont) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    self.label.text = @"e83d";
    [self.view addSubview:self.label];
    self.def = false;
}

- (void)changeFont {
    
    CFErrorRef error = NULL;
    
    if (self.fontRef) {
        CTFontManagerUnregisterGraphicsFont(self.fontRef, &error);
        if (error) {
            NSLog(@"%@", ((__bridge NSError*)error).localizedDescription);
            return;
        }
        
    }
    
    NSString *fontFileDirectory = [self fontFileDirectoryPath];
    NSString *fontFilePath = [fontFileDirectory stringByAppendingPathComponent:@"EMIconDefault.ttf"];
    NSURL *fontFileURL = [NSURL fileURLWithPath:fontFilePath];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:fontFilePath]) {
        [NSFileManager.defaultManager removeItemAtPath:fontFilePath error:nil];
    }
    NSString *bundleFontFilePath = nil;
    self.def = !self.def;
    if (self.def) {
        bundleFontFilePath = [[NSBundle mainBundle] pathForResource:@"EMIcon" ofType:@"ttf"];
    }else {
        bundleFontFilePath = [[NSBundle mainBundle] pathForResource:@"EMIcon(1)" ofType:@"ttf"];
    }
//    bundleFontFilePath = [[NSBundle mainBundle] pathForResource:@"EMIcon" ofType:@"ttf"];
    [NSFileManager.defaultManager copyItemAtPath:bundleFontFilePath toPath:fontFilePath error:nil];
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileURL);
    CGFontRef defaultFont = CGFontCreateWithDataProvider(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(defaultFont, &error);
    
    if (error) {
        NSLog(@"%@", ((__bridge NSError*)error).localizedDescription);
        return;
    }
    self.fontRef = defaultFont;
    if (self.def) {
        self.label.font = [UIFont fontWithName:@"EMIcon" size:16.1];
        self.label.text = [IconUtil readIconWithUnicodeStr:@"e83d"];
    }else {
//        self.label.font = [UIFont fontWithName:@"EMIcon" size:14];
        self.label.font = [UIFont fontWithName:@"EMIcon" size:16];
        self.label.text = [IconUtil readIconWithUnicodeStr:@"e83d"];
    }
}

- (NSString *)fontFileDirectoryPath {
    NSString *fontFileDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fontFileDirectoryPath = [fontFileDirectoryPath stringByAppendingPathComponent:@"FontFiles"];
    if (![NSFileManager.defaultManager fileExistsAtPath:fontFileDirectoryPath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:fontFileDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return fontFileDirectoryPath;
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
