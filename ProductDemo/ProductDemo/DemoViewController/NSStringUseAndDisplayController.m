//
//  NSStringUseAndDisplayController.m
//  ProductDemo
//
//  Created by 祁子栋 on 2021/2/17.
//  Copyright © 2021 qizd. All rights reserved.
//

#import "NSStringUseAndDisplayController.h"
#import "NSString+Fmt.h"

@interface NSStringUseAndDisplayController ()

@end

@implementation NSStringUseAndDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     self.navigationItem.title = @"字符串操作";
     self.title = @"操作字符串";
     这两句在push出来的页面中测试是一样的，谁在后面谁有效果
     */
    self.navigationItem.title = @"字符串操作";
    self.title = @"操作字符串";
    self.view.backgroundColor = [UIColor grayColor];
    
    NSDictionary *strDIc = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"1",@"2",@"2",@"3",@"3",@"4",@"4",@"5",@"5", nil];
    NSArray *strArr = strDIc.allKeys;
    //这里的字符串a就是copy类型的，修改a的值，不会影响数组中的数据
    NSString *a = [strArr objectAtIndex:2];
    NSLog(@"%@, %@", a, strArr);
    
    [self userPdding];
}

- (void)userPdding{
    NSString *a = @"123";
    NSLog(@"%@", [a EI_stringByPadLeft:5]);//'  123'
    NSLog(@"%@", [a EI_stringByPadRight:5]);//'123  '
    
    a = @"1234";
    NSLog(@"%@", [a EI_stringByPadLeft:5]);//' 1234'
    NSLog(@"%@", [a EI_stringByPadRight:5]);//'1234 '
    
    a = @"123456";
    NSLog(@"%@", [a EI_stringByPadLeft:5]);//'123456'
    NSLog(@"%@", [a EI_stringByPadRight:5]);//'123456'
}


@end
