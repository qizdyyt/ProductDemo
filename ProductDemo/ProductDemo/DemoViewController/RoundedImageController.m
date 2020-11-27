//
//  RoundedImageController.m
//  ProductDemo
//
//  Created by qizd on 2018/8/28.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "RoundedImageController.h"
#import "UIImageView+RoundImage.h"

@interface RoundedImageController () <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat cellHeight;
    CGFloat imageSize;
    CGFloat gap;
    CGFloat cornerRadius;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RoundedImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellHeight = 50;
    imageSize = 40;
    gap = 4;
    cornerRadius = imageSize / 2;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        CGFloat imageV_x = 0;
        for (int i = 0; i < 15; i++) {
            if (i < 5) {
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(imageV_x, 0, imageSize, imageSize)];
//    普通圆角会造成卡顿明显
//                imageV.layer.cornerRadius = 10;
//                imageV.layer.masksToBounds = YES;
//                imageV.image = [UIImage imageNamed:@"1"];

//    使用masklayer，使用了遮罩层mask，还是会离屏渲染，卡顿
//                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageV.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
//                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//                maskLayer.frame = imageV.bounds;
//                maskLayer.path = maskPath.CGPath;
//                imageV.layer.mask = maskLayer;
//                imageV.image = [UIImage imageNamed:@"1"];
                
                //正确的姿势
                [imageV zd_drawRectWithRoundedCornerRadius:cornerRadius size:CGSizeMake(imageSize, imageSize) image:[UIImage imageNamed:@"1"]];
                
                [cell.contentView addSubview:imageV];
            } else {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageV_x, 0, imageSize, imageSize)];
                label.text = @"圆";
                label.textAlignment = NSTextAlignmentCenter;

//                一样会卡的死死的
//                label.backgroundColor = [UIColor redColor];
//                label.layer.cornerRadius = cornerRadius;
//                label.layer.masksToBounds = YES;
                
                //这种办法简单，且可以实现效果,不卡,推荐用这种
                label.layer.backgroundColor = [UIColor redColor].CGColor;
                label.layer.cornerRadius = cornerRadius;

                //自己画一个圆View，并加入label，但是看着如果是圆形，不够圆
//                [self addCornerForUIView:label radius: cornerRadius];
                
                [cell.contentView addSubview:label];
            }
            
            imageV_x += (imageSize + 2);
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)addCornerForUIView:(UIView *)view radius:(CGFloat)radius{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//    CGContextMoveToPoint(context, CGRectGetMidX(drawRect), CGRectGetMinY(drawRect));
    //绘制曲线---------无论哪种回执曲线的方法都不够圆
//    CGContextAddArcToPoint(context, CGRectGetMaxX(drawRect), CGRectGetMinY(drawRect), CGRectGetMaxX(drawRect), CGRectGetMidY(drawRect), radius);
//    CGContextAddArcToPoint(context,CGRectGetMaxX(drawRect), CGRectGetMaxY(drawRect), CGRectGetMidX(drawRect), CGRectGetMaxY(drawRect), radius);
//    CGContextAddArcToPoint(context, CGRectGetMinX(drawRect), CGRectGetMaxY(drawRect), CGRectGetMinX(drawRect), CGRectGetMidY(drawRect), radius);
//    CGContextAddArcToPoint(context, CGRectGetMinX(drawRect), CGRectGetMinY(drawRect), CGRectGetMidX(drawRect), CGRectGetMinY(drawRect), radius);
    
    //绘制曲线
//    CGContextAddArcToPoint(context, CGRectGetMaxX(drawRect), CGRectGetMinY(drawRect), CGRectGetMaxX(drawRect), CGRectGetMaxY(drawRect), radius);
//    CGContextAddArcToPoint(context,CGRectGetMaxX(drawRect), CGRectGetMaxY(drawRect), CGRectGetMinX(drawRect), CGRectGetMaxY(drawRect), radius);
//    CGContextAddArcToPoint(context, CGRectGetMinX(drawRect), CGRectGetMaxY(drawRect), CGRectGetMinX(drawRect), CGRectGetMinY(drawRect), radius);
//    CGContextAddArcToPoint(context, CGRectGetMinX(drawRect), CGRectGetMinY(drawRect), CGRectGetMaxX(drawRect), CGRectGetMinY(drawRect), radius);
//    CGContextClosePath(context);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:drawRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextResetClip(UIGraphicsGetCurrentContext());
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
//    [[NSString stringWithFormat:@"123"] drawInRect:drawRect withAttributes:nil];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *insertImageV = [[UIImageView alloc] initWithImage:viewImage];
    insertImageV.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    [view insertSubview:insertImageV atIndex:0];
}

@end
