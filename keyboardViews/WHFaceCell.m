//
//  WHFaceCell.m
//  demo
//
//  Created by smjl on 16/1/11.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import "WHFaceCell.h"
@implementation WHFaceCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W(60), H(60))];
        _myLabel.font = [UIFont systemFontOfSize:30];
        _myLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_myLabel];
    }
    return self;
}
@end
