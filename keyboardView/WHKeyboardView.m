//
//  WHKeyboardView.m
//  shareView
//
//  Created by Jiafei on 16/1/25.
//  Copyright © 2016年 com.wahool. All rights reserved.
//

#import "WHKeyboardView.h"
#import "UIColor+Hex.h"
#define SCREENW  [UIScreen mainScreen].bounds.size.width
#define SCREENH  [UIScreen mainScreen].bounds.size.height
#define IPHONE4 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 480)
#define IPHONE5 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 568)
#define IPHONE6 ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 667)
#define IPHONE6P ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 736)

//iPhone 5下按屏幕适配
#define  H(x)   (IPHONE4?(x)/2.0:(CGFloat)(x)/(CGFloat)1136 * SCREENH)
#define  W(x)   (IPHONE4?(x)/2.0:(CGFloat)(x)/(CGFloat)640 * SCREENW)
@implementation WHKeyboardView
{
    UIView      *_keyboardBackView;
    //底部视图
    UIView      *_keyboardBottomView;
    //输入框
    UITextView  *_keyboardTextView;
    //占位符
    UILabel     *_KeyboardDispalylabel;
    //转换按钮
    UIButton    *_keyBoardEmojiButton;
    //表情键盘
    WHFaceView  *_keyBoardFaceView;
    BOOL         _emojiMark;
    float        _keyboardHeight;
}
-(instancetype)init{
    self=[super initWithFrame:CGRectMake(0, SCREENH-H(101), SCREENW, H(101))];
    if (self) {
        [self setUpData];
        [self setUI];
        [self registerForKeyboardNotifications];
    }
    return self;
}
-(void)setUpData{
    _emojiMark=NO;
}
-(void)setUI{
    self.backgroundColor=[UIColor clearColor];
    //输入部分的View
    _keyboardBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, H(101))];
    _keyboardBottomView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_keyboardBottomView];
    //上方横线
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 0.5)];
    lineView.backgroundColor=[UIColor colorWithHexString:@"#dedede"];
    [_keyboardBottomView addSubview:lineView];
    //输入框
    _keyboardTextView=[[UITextView alloc]initWithFrame:CGRectMake(W(20), H(20), SCREENW-W(107), H(60))];
    _keyboardTextView.backgroundColor=[UIColor colorWithHexString:@"dedede"];
    _keyboardTextView.font=[UIFont systemFontOfSize:H(26)];
    _keyboardTextView.layer.cornerRadius=H(4);
    _keyboardTextView.layer.masksToBounds=YES;
    _keyboardTextView.tintColor = [UIColor colorWithHexString:@"#47b233"];
    _keyboardTextView.returnKeyType=UIReturnKeySend;
    _keyboardTextView.delegate=self;
    [_keyboardBottomView addSubview:_keyboardTextView];
    _keyBoardEmojiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _keyBoardEmojiButton.frame=CGRectMake(SCREENW-H(87), H(8), H(87), H(87));
    [_keyBoardEmojiButton setImage:[UIImage imageNamed:@"common_btn_biaoqing"] forState:UIControlStateNormal];
    [_keyBoardEmojiButton addTarget:self action:@selector(emojiButton:) forControlEvents:UIControlEventTouchUpInside];
    //表情键盘
    _keyBoardFaceView=[[WHFaceView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 216) textView:_keyboardTextView];

    //
    _KeyboardDispalylabel=[[UILabel alloc]initWithFrame:CGRectMake(W(10), H(16), W(370), H(26))];
    _KeyboardDispalylabel.text=@"说点什么吧";
    _KeyboardDispalylabel.numberOfLines=1;
    _KeyboardDispalylabel.textColor=[UIColor colorWithHexString:@"#717171"];
    _KeyboardDispalylabel.font=[UIFont systemFontOfSize:H(26)];
    [_keyboardTextView addSubview:_KeyboardDispalylabel];
    [_keyboardBottomView addSubview:_keyBoardEmojiButton];
    //背景图层
    _keyboardBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 0)];
    _keyboardBackView.backgroundColor=[UIColor blackColor];
    _keyboardBackView.alpha=0.4;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired=1;
    [_keyboardBackView addGestureRecognizer:tap];
    _keyboardBackView.hidden=YES;
    [self addSubview:_keyboardBackView];
}
-(void)tapAction:(UITapGestureRecognizer*)tap{
    [_keyboardTextView resignFirstResponder];
}
-(void)emojiButton:(UIButton*)button{
    _emojiMark=!_emojiMark;
    if (_emojiMark) {
        [button setImage:[UIImage imageNamed:@"common_btn_jianpan"] forState:UIControlStateNormal];
        _keyboardTextView.inputView=_keyBoardFaceView;
        [_keyboardTextView reloadInputViews];
        [_keyboardTextView becomeFirstResponder];
        
    }else{
        _keyboardTextView.inputView=nil;
        [_keyboardTextView reloadInputViews];
        [button setImage:[UIImage imageNamed:@"common_btn_biaoqing"] forState:UIControlStateNormal];
    }
}
#pragma mark-键盘监听
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
#pragma mark-键盘出现时
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //背景改变
    _keyboardBackView.hidden=NO;
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyboardHeight=kbSize.height;
    self.frame=[UIScreen mainScreen].bounds;
    [self changeTextHeight:_keyboardTextView.text];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark-键盘消失时
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _keyboardBackView.hidden=YES;
    [_keyBoardEmojiButton setImage:[UIImage imageNamed:@"common_btn_biaoqing"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.4 animations:^{
        //
        _keyboardBackView.frame=CGRectMake(0, 0, SCREENW, 0);
        self.frame=CGRectMake(0, SCREENH-H(101), SCREENW, H(101));
        _keyboardBottomView.frame=CGRectMake(0, 0, SCREENW, H(101));
        _keyboardTextView.frame=CGRectMake(W(20), H(20), SCREENW-W(107),H(60));
        _keyBoardEmojiButton.frame=CGRectMake(SCREENW-H(87), H(8), H(87), H(87));
    }];
}
#pragma mark-textView的代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString: @"\n"]) {
        [self.delegate sendInfoAction:_keyboardTextView.text];
        _keyboardTextView.text=@"";
        _KeyboardDispalylabel.hidden=NO;
        [self.delegate sendInfoAction:_keyboardTextView.text];
        _keyboardTextView.text=@"";
        [_keyboardTextView resignFirstResponder];
        return YES;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
//    [self addSubview:_keyboardBackView];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length==0) {
        _KeyboardDispalylabel.hidden=NO;
    }else{
        _KeyboardDispalylabel.hidden=YES;
        [self changeTextHeight:textView.text];
    }
}

#pragma mark-判断输入的文字的高度
-(void)changeTextHeight:(NSString*)text{
    CGRect rect=[text boundingRectWithSize:CGSizeMake(_keyboardTextView.frame.size.width-W(19), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:H(26)]} context:nil];
    if (rect.size.height<H(60)){
        [self changeFramesWith:0 andheight:H(40)];
        return;
    }
    
    float vale=rect.size.height-H(60)+H(20);
    if ( SCREENH-H(128+101)-_keyboardHeight-vale<0) {
        return;
    }
    [self changeFramesWith:vale andheight:rect.size.height];
}
-(void)changeFramesWith:(float)vale andheight:(float)height{
    //CGRectMake(W(20), H(28), H(47), H(47))
    [UIView animateWithDuration:0.2 animations:^{
        _keyboardBottomView.frame=CGRectMake(0, SCREENH-H(101)-_keyboardHeight-vale, SCREENW, H(101)+vale);
        _keyboardTextView.frame=CGRectMake(W(20), H(20), SCREENW-W(107),height+H(20));
        _keyBoardEmojiButton.frame=CGRectMake(SCREENW-H(87), H(8)+vale, H(87), H(87));
        _keyboardBackView.frame=CGRectMake(0,0, SCREENW,SCREENH-H(101)-_keyboardHeight-vale);
    }];
}
#pragma mark-表情键盘的代理
-(void)getString:(NSString *)string{
    [self changeTextHeight:_keyboardTextView.text];
    _KeyboardDispalylabel.hidden=YES;
    _keyboardTextView.text = [[NSString alloc] initWithFormat:@"%@%@",_keyboardTextView.text,string];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
