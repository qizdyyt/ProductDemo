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

- (UIImage *)waterMarkWithText_New:(NSString *)text{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    //Font set to a fixed size.
    CGFloat borderSize = 10;
    CGFloat fontSize = 18;
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
    
   
    CGSize textBGSize = CGSizeMake(imageWidth, imageHeight * 0.1);
    CGRect textBGRect = CGRectMake(borderSize, imageHeight + borderSize, textBGSize.width, textBGSize.height);
    
    fontSize = textBGSize.height * 0.5;
    fontSize = ceilf(fontSize);
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize textLimitSize = MultiLineSize(text, font, CGSizeMake(imageWidth, CGFLOAT_MAX));
    textLimitSize = CGSizeMake(ceilf(textLimitSize.width), ceilf(textLimitSize.height));
    
    //获得一个位图图形上下文
    CGSize frameSize = CGSizeMake(imageWidth + borderSize*2, imageHeight + textBGSize.height + borderSize*2);//画布大小
    UIGraphicsBeginImageContext(frameSize);
    //画布背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:255 g:255 b:255 a:1].CGColor);
    CGContextFillRect(contextRef, rect);

    
    //文字背景色

    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:0 g:0 b:0 a:1].CGColor);
    CGContextFillRect(contextRef, textBGRect);
    //绘制文字
    NSMutableParagraphStyle *syle = [[NSMutableParagraphStyle alloc] init];
    syle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:syle
                                 };
    NSAttributedString *drawTextStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [drawTextStr drawInRect:CGRectMake(frameSize.width/2 - textLimitSize.width/2, borderSize*1 + imageHeight+(textBGSize.height-textLimitSize.height)/2, textLimitSize.width, textLimitSize.height)];

    //绘制图片
    [self drawInRect:CGRectMake(borderSize, borderSize, imageWidth, imageHeight)];//注意绘图的位置是相对于画布顶点而言，不是屏幕
    
    // 返回新绘制的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)waterMarkWithText_New2:(NSString *)text{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    //Font set to a fixed size.
    CGFloat borderSize = 10;
    CGFloat fontSize = 18;
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
    
    fontSize = borderSize * 1.2;
    fontSize = ceilf(fontSize);
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize textLimitSize = MultiLineSize(text, font, CGSizeMake(imageWidth, CGFLOAT_MAX));
    textLimitSize = CGSizeMake(ceilf(textLimitSize.width), ceilf(textLimitSize.height));
    
    CGSize textBGSize = CGSizeMake(imageWidth, textLimitSize.height * 2);
    CGRect textBGRect = CGRectMake(borderSize, imageHeight + borderSize, textBGSize.width, textBGSize.height);
    
    //获得一个位图图形上下文
    CGSize frameSize = CGSizeMake(imageWidth + borderSize*2, imageHeight + textBGSize.height + borderSize*2);//画布大小
    UIGraphicsBeginImageContext(frameSize);
    //画布背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    CGContextSetFillColorWithColor(contextRef, [UIColor redColor].CGColor);
    CGContextFillRect(contextRef, rect);

    
    //文字背景色
    
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:0 g:0 b:0 a:1].CGColor);
    CGContextFillRect(contextRef, textBGRect);
    //绘制文字
    NSMutableParagraphStyle *syle = [[NSMutableParagraphStyle alloc] init];
    syle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:syle
                                 };
    NSAttributedString *drawTextStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [drawTextStr drawInRect:CGRectMake(frameSize.width/2 - textLimitSize.width/2, borderSize*1 + imageHeight+(textBGSize.height-textLimitSize.height)/2, textLimitSize.width, textLimitSize.height)];

    //绘制图片
    [self drawInRect:CGRectMake(borderSize, borderSize, imageWidth, imageHeight)];//注意绘图的位置是相对于画布顶点而言，不是屏幕
    
    // 返回新绘制的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)combineImages:(NSArray *)imageArr
{
    NSMutableArray *resultImageArr = [imageArr copy];
    CGFloat combineImageHeight = 0;
    CGFloat imageItemWidth = ScreenWidth / 2;
    
    CGFloat maxImageHeightForRow = 0;
    NSMutableArray *imageItemHeightArr = [NSMutableArray array];
    
    for (int i = 0; i<resultImageArr.count; i++) {
        if (i % 2 == 0 && i>0) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
            maxImageHeightForRow = 0;
        }
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        
        CGFloat scale = imageItemWidth / image.size.width;
        CGFloat imageItemHeigth = imgSize.height * scale;
        if (maxImageHeightForRow < imageItemHeigth) {
            maxImageHeightForRow = imageItemHeigth;
        }
        if (i == resultImageArr.count - 1) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
        }
    }
    
    
    UIGraphicsBeginImageContext(CGSizeMake(ScreenWidth, combineImageHeight));
    
    //背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, ScreenWidth, combineImageHeight);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:255 g:255 b:255 a:1].CGColor);
    CGContextFillRect(contextRef, rect);
    
    int preRow = 0;
    CGFloat totalImageH = 0;
    for (int i = 0; i<resultImageArr.count; i++) {
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        if (imgSize.height > 0)
        {
            int imageRow = i / 2;
            if (imageRow != preRow) {
                totalImageH += [imageItemHeightArr[preRow] doubleValue];
                preRow = imageRow;
            }
            CGFloat imageItemHeigth = [imageItemHeightArr[imageRow] doubleValue];
            
            
            CGFloat imageX = (i % 2 == 0 ? 0 : imageItemWidth);
            CGFloat scale = imageItemWidth / image.size.width;
            CGFloat imageHeigth = imgSize.height * scale;
            CGFloat imageY = totalImageH + (imageItemHeigth - imageHeigth);
            [image drawInRect:CGRectMake(imageX, imageY, imageItemWidth, imageHeigth)];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)combineImagesNew:(NSArray *)imageArr
{
    NSMutableArray *resultImageArr = [imageArr copy];
    CGFloat combineImageHeight = 0;
    
    CGFloat maxImageWidth = 0;
    CGFloat maxImageHeightForRow = 0;
    NSMutableArray *imageItemHeightArr = [NSMutableArray array];
    
    for (int i = 0; i<resultImageArr.count; i++) {
        if (i % 2 == 0 && i>0) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
            maxImageHeightForRow = 0;
        }
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        if (imgSize.width > maxImageWidth) {
            maxImageWidth = imgSize.width;
        }
        
        CGFloat imageItemHeigtht = imgSize.height;
        if (maxImageHeightForRow < imageItemHeigtht) {
            maxImageHeightForRow = imageItemHeigtht;
        }
        if (i == resultImageArr.count - 1) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
        }
    }
    
    
    CGSize combineSize = CGSizeMake(maxImageWidth * 2, combineImageHeight);
    UIGraphicsBeginImageContext(combineSize);
    //背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, combineSize.width, combineImageHeight);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:255 g:255 b:255 a:1].CGColor);
    CGContextFillRect(contextRef, rect);
    
    int preRow = 0;
    CGFloat totalImageH = 0;
    for (int i = 0; i<resultImageArr.count; i++) {
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        CGFloat imageWidth = imgSize.width;
        CGFloat imageHeight = imgSize.height;
        
        if (imgSize.height > 0)
        {
            int imageRow = i / 2;
            if (imageRow != preRow) {
                totalImageH += [imageItemHeightArr[preRow] doubleValue];
                preRow = imageRow;
            }
            
            CGFloat imageItemHeigth = [imageItemHeightArr[imageRow] doubleValue];
            if (imageWidth/imageHeight >= maxImageWidth/imageItemHeigth) {
                //宽度相对较宽
                imageWidth = maxImageWidth;
            }
            else{
                CGFloat scale = 1;
                //高度相对较高
                if (imageHeight > maxImageHeightForRow) {
                    scale = maxImageHeightForRow / imageHeight;
                }
                //为了保持不变形
                imageHeight = imageItemHeigth;
                imageWidth = imageWidth *scale;
            }
//            CGFloat xGap = (maxImageWidth -imageWidth) / 2;
//            CGFloat imageX = (i % 2 == 0 ? xGap : maxImageWidth + xGap);
//            CGFloat imageY = totalImageH + (imageItemHeigth - imageHeight);
//            [image drawInRect:CGRectMake(imageX, imageY, imageWidth, imageHeight) blendMode:kCGBlendModeMultiply alpha:1];
            CGFloat imageX = (i % 2 == 0 ? 0 : maxImageWidth);
            CGFloat imageY = totalImageH;
            [image drawInRect:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)combineImagesVersion2:(NSArray *)imageArr
{
    NSMutableArray *resultImageArr = [imageArr copy];
    CGFloat combineImageHeight = 0;
    
    CGFloat maxImageWidth = 0;
    CGFloat maxImageHeightForRow = 0;
    NSMutableArray *imageItemHeightArr = [NSMutableArray array];
    
    for (int i = 0; i<resultImageArr.count; i++) {
        if (i % 2 == 0 && i>0) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
            maxImageHeightForRow = 0;
        }
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        if (imgSize.width > maxImageWidth) {
            maxImageWidth = imgSize.width;
        }
        
        CGFloat imageItemHeigtht = imgSize.height;
        if (maxImageHeightForRow < imageItemHeigtht) {
            maxImageHeightForRow = imageItemHeigtht;
        }
        if (i == resultImageArr.count - 1) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
        }
    }
    
    
    CGSize combineSize = CGSizeMake(maxImageWidth * 2, combineImageHeight);
    UIGraphicsBeginImageContext(combineSize);
    //背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, combineSize.width, combineImageHeight);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:255 g:255 b:255 a:1].CGColor);
    CGContextFillRect(contextRef, rect);
    
    int preRow = 0;
    CGFloat totalImageH = 0;
    for (int i = 0; i<resultImageArr.count; i++) {
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        CGFloat imageWidth = imgSize.width;
        CGFloat imageHeight = imgSize.height;
        
        if (imgSize.height > 0)
        {
            int imageRow = i / 2;
            if (imageRow != preRow) {
                totalImageH += [imageItemHeightArr[preRow] doubleValue];
                preRow = imageRow;
            }
            
            CGFloat imageItemHeigth = [imageItemHeightArr[imageRow] doubleValue];
            
            CGFloat xGap = (maxImageWidth -imageWidth) / 2;
            CGFloat imageX = (i % 2 == 0 ? xGap : maxImageWidth + xGap);
            CGFloat imageY = totalImageH + (imageItemHeigth - imageHeight);
            [image drawInRect:CGRectMake(imageX, imageY, imageWidth, imageHeight) blendMode:kCGBlendModeMultiply alpha:1];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (CGFloat)getWarterBGHeightWithImages:(NSArray *)imageArr{
    CGFloat res = 40;
    for (UIImage *image in imageArr) {
        CGSize imageSize = image.size;
        CGFloat imageWidth = imageSize.width;
        CGFloat imageHeight = imageSize.height;
        //Font set to a fixed size.
        CGFloat borderSize = 10;
        CGFloat fontSize = 18;
        if (imageWidth/imageHeight >= ScreenWidth/(ScreenHeight-108)) {
            borderSize = imageWidth/27/1.4;
        }
        else{
            borderSize = imageHeight/27/1.4/((ScreenHeight-108)/ScreenWidth);
        }
        //适配iPad横屏
        if(ScreenWidth > ScreenHeight)
        {
            if (imageWidth/imageHeight >= ScreenHeight/(ScreenWidth-108)) {
                borderSize = imageWidth/27/1.4;
            }
            else{
                borderSize = imageHeight/27/1.4/((ScreenWidth-108)/ScreenHeight);
            }
        }
        borderSize = ceilf(borderSize);//avoid decimal number
        
    }
    return res;
}

+ (UIImage *)combineImagesVersion3:(NSArray *)imageArr withText:(NSArray *)textArr
{
    NSMutableArray *resultImageArr = [imageArr copy];
    CGFloat combineImageHeight = 0;
    
    CGFloat maxImageWidth = 0;
    CGFloat maxImageHeightForRow = 0;
    NSMutableArray *imageItemHeightArr = [NSMutableArray array];
    
    for (int i = 0; i<resultImageArr.count; i++) {
        if (i % 2 == 0 && i>0) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
            maxImageHeightForRow = 0;
        }
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        if (imgSize.width > maxImageWidth) {
            maxImageWidth = imgSize.width;
        }
        
        CGFloat imageItemHeigtht = imgSize.height;
        if (maxImageHeightForRow < imageItemHeigtht) {
            maxImageHeightForRow = imageItemHeigtht;
        }
        if (i == resultImageArr.count - 1) {
            combineImageHeight = combineImageHeight + maxImageHeightForRow;
            [imageItemHeightArr addObject:@(maxImageHeightForRow)];
        }
    }
    
    CGFloat markHeight = maxImageHeightForRow / 11;//[self getWarterBGHeightWithImages:imageArr];
    CGFloat rowGap = markHeight/2;
    CGFloat columnGap = markHeight/2;
    
    
    CGSize combineSize = CGSizeMake(maxImageWidth * 2 + columnGap * 3, combineImageHeight + imageItemHeightArr.count * (rowGap + markHeight) - rowGap);
    UIGraphicsBeginImageContext(combineSize);
    //背景色
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, combineSize.width, combineSize.height);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:255 g:255 b:255 a:1].CGColor);
    CGContextFillRect(contextRef, rect);
    
    int preRow = 0;
    CGFloat totalImageH = 0;
    for (int i = 0; i<resultImageArr.count; i++) {
        UIImage *image = resultImageArr[i];
        CGSize imgSize = image.size;
        CGFloat imageWidth = imgSize.width;
        CGFloat imageHeight = imgSize.height;
        
        if (imgSize.height > 0)
        {
            int imageRow = i / 2;
            if (imageRow != preRow) {
                totalImageH += [imageItemHeightArr[preRow] doubleValue];
                preRow = imageRow;
            }
            
            CGFloat imageItemHeigth = [imageItemHeightArr[imageRow] doubleValue];
            CGFloat warterBGRectY = totalImageH + imageRow*(rowGap+markHeight) + imageItemHeigth-markHeight;
            CGFloat warterBGRectX = rowGap + (i % 2 == 0 ? 0 : rowGap + maxImageWidth);
            
            CGFloat xGap = (maxImageWidth -imageWidth) / 2 + columnGap;
            CGFloat imageX = (i % 2 == 0 ? xGap : maxImageWidth + xGap + columnGap);
            CGFloat imageY = warterBGRectY - imageHeight;//totalImageH + (imageItemHeigth - imageHeight) + (imageItemHeightArr.count - 1)*rowGap;
            [image drawInRect:CGRectMake(imageX, imageY, imageWidth, imageHeight) blendMode:kCGBlendModeMultiply alpha:1];
            
            
            CGRect warterBGRect = CGRectMake(warterBGRectX, warterBGRectY, maxImageWidth, markHeight);
            CGContextSetFillColorWithColor(contextRef, [UIColor colorFromR:0 g:0 b:0 a:0.5].CGColor);
            CGContextFillRect(contextRef, warterBGRect);
            
            NSString *text =textArr[i];
            UIFont *font = [UIFont systemFontOfSize:markHeight / 2];
            CGSize textLimitSize = MultiLineSize(text, font, CGSizeMake(maxImageWidth, CGFLOAT_MAX));
            textLimitSize = CGSizeMake(ceilf(textLimitSize.width), ceilf(textLimitSize.height));
            NSMutableParagraphStyle *syle = [[NSMutableParagraphStyle alloc] init];
            syle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{NSFontAttributeName : font,
                                         NSForegroundColorAttributeName:[UIColor whiteColor],
                                         NSParagraphStyleAttributeName:syle
                                         };
            NSAttributedString *drawTextStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [drawTextStr drawInRect:CGRectMake(warterBGRectX + (warterBGRect.size.width - textLimitSize.width) / 2, warterBGRectY + (markHeight - textLimitSize.height)/2, textLimitSize.width, textLimitSize.height)];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
@end
