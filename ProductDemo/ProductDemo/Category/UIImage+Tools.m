//
//  UIImage+Tools.m
//  ProductDemo
//
//  Created by 祁子栋 on 2021/2/17.
//  Copyright © 2021 qizd. All rights reserved.
//

#import "UIImage+Tools.h"
#import "UIColor+Util.h"
@implementation UIImage (Tools)
- (UIImage *)waterMarkWithText:(NSString *)text
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    //Font set to a fixed size.
    CGFloat borderSize = 10;
    CGFloat fontSize = 10;
    if (imageWidth/imageHeight >= screenWidth/(screenHeight-108)) {
        borderSize = imageWidth/27/1.4;
    }
    else{
        borderSize = imageHeight/27/1.4/((screenHeight-108)/screenWidth);
    }
    //适配iPad横屏
    if(screenWidth > screenHeight)
    {
        if (imageWidth/imageHeight >= screenHeight/(screenWidth-108)) {
            borderSize = imageWidth/27/1.4;
        }
        else{
            borderSize = imageHeight/27/1.4/((screenWidth-108)/screenHeight);
        }
    }
    borderSize = ceilf(borderSize);//avoid decimal number
    
    fontSize = borderSize;
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGSize textLimitSize = MultiLineSize(text, font, CGSizeMake(imageWidth, CGFLOAT_MAX));
    textLimitSize = CGSizeMake(ceilf(textLimitSize.width), ceilf(textLimitSize.height));
    
    //获得一个位图图形上下文
    CGSize frameSize = CGSizeMake(imageWidth + borderSize*2, imageHeight + textLimitSize.height + borderSize*2);//画布大小
    UIGraphicsBeginImageContext(frameSize);
    //画布背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:54 g:89 b:115 a:1].CGColor);
    CGContextFillRect(contextRef, rect);

    // add text
    NSMutableParagraphStyle *syle = [[NSMutableParagraphStyle alloc] init];
    syle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:syle
                                 };
    NSAttributedString *drawTextStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    //(Task:469254  Reduce the font and move the caption to top of the photo.)
    [drawTextStr drawInRect:CGRectMake(frameSize.width/2 - textLimitSize.width/2, borderSize*0.5, textLimitSize.width, textLimitSize.height)];

    //绘制图片
    [self drawInRect:CGRectMake(borderSize, borderSize + textLimitSize.height, imageWidth, imageHeight)];//注意绘图的位置是相对于画布顶点而言，不是屏幕
    
    // 返回新绘制的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


CG_INLINE CGSize MultiLineSize(NSString *text, UIFont *font, CGSize maxSize){
    if (text.length >0)
    {
        return [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    return CGSizeZero;
}
@end
