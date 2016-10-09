//
//  WHFaceView.h
//  demo
//
//  Created by smjl on 16/1/11.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol faceViewDelegate <NSObject>

- (void)getString:(NSString *)string;

@end

@interface WHFaceView : UIView

@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)id<faceViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
