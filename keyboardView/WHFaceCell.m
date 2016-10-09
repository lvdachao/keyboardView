//
//  WHFaceCell.m
//  demo
//
//  Created by smjl on 16/1/11.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import "WHFaceCell.h"
#define IPHONE4 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 480)
#define SCREENW  [UIScreen mainScreen].bounds.size.width
#define SCREENH  [UIScreen mainScreen].bounds.size.height

//iPhone 5下按屏幕适配
#define  H(x)   (IPHONE4?(x)/2.0:(CGFloat)(x)/(CGFloat)1136 * SCREENH)
#define  W(x)   (IPHONE4?(x)/2.0:(CGFloat)(x)/(CGFloat)640 * SCREENW)
@implementation WHFaceCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(W(5), W(5), W(50), H(50))];
        [self.contentView addSubview:_myImageView];
        _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W(60), H(60))];
        _myLabel.font = [UIFont systemFontOfSize:30];
        _myLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_myLabel];
    }
    return self;
}
@end
