//
//  WHFaceView.h
//  demo
//
//  Created by smjl on 16/1/11.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHFaceView : UIView

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITextView *textView;

- (instancetype)initWithFrame:(CGRect)frame textField:(UITextField *)textField;
- (instancetype)initWithFrame:(CGRect)frame textView:(UITextView *)textView;
@end
