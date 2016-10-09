//
//  WHFaceView.m
//  demo
//
//  Created by smjl on 16/1/11.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import "WHFaceView.h"
#import "Emoji.h"
#import "WHFaceCell.h"
#import "UITextField+WHtentRange.h"

#define IPHONE4 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 480)
#define IPHONE5 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 568)
#define IPHONE6 ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 667)
#define IPHONE6P ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 736)
#define SCREENW  [UIScreen mainScreen].bounds.size.width
#define SCREENH  [UIScreen mainScreen].bounds.size.height

//iPhone 5下按屏幕适配
#define  H(x)   (IPHONE4?(x)/2.0:(CGFloat)(x)/(CGFloat)1136 * SCREENH)
#define  W(x)   (IPHONE4?(x)/2.0:(CGFloat)(x)/(CGFloat)640 * SCREENW)



@interface WHFaceView ()<
                        UICollectionViewDataSource,
                        UICollectionViewDelegate,
                        UITextFieldDelegate>

@end


@implementation WHFaceView
{
    NSMutableDictionary *_dict;
    UIPageControl *_pageControl;
    NSArray *_array;
    int _left;// 左边距
    int _right;//边距
    int _distance;//大小
    int _count;//一页多少
    int _page;//几页
    int _space;//间隔
    BOOL _isField;//标志是否是textField
}
- (instancetype)initWithFrame:(CGRect)frame textField:(UITextField *)textField{
    if (self =[super initWithFrame:frame]) {
        self.textField = textField;
        _isField = YES;
        [self setUp];
        [self createScrollView];
        [self createPageControl];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textView:(UITextView *)textView{
    if (self =[super initWithFrame:frame]) {
        self.textView = textView;
        _isField = NO;
        [self setUp];
        [self createScrollView];
        [self createPageControl];
    }
    return self;
}

- (void)createPageControl{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180, SCREENW, H(10))];
    _pageControl.numberOfPages = _page;
    _pageControl.pageIndicatorTintColor = [UIColor greenColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int n = scrollView.contentOffset.x/SCREENW;
    _pageControl.currentPage = n;
}
- (void)setUp{
    if (IPHONE4||IPHONE5) {
        _distance = 60;
        _count = 21;
        _left = 44;
        _right = 42;
        _page = 8;
        _space = 20;
    }
    else if (IPHONE6){
        _distance = 60;
        _count = 24;
        _left = 20;
        _right = 20;
        _page = 7;
        _space = 15;
    }
    else if (IPHONE6P){
        _distance = 60;
        _count = 27;
        _left = 20;
        _right = 20;
        _page = 6;
        _space = 4;
    }
    _array = [Emoji allEmoji];
    _dict = [NSMutableDictionary dictionary];
    for (NSString *key in _array) {
        [_dict setValue:key forKey:key];
    }
}
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 216)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_page*SCREENW, 216);
    for (int i = 0 ;i<_page;i++) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(W(_distance),H(_distance));
        flowLayout.minimumInteritemSpacing = W(_space);
        flowLayout.minimumLineSpacing = H(25);
        flowLayout.sectionInset = UIEdgeInsetsMake(H(40), W(_left), H(100), W(_right));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView * collection = [[UICollectionView alloc] initWithFrame:CGRectMake(i*SCREENW, 0, SCREENW, 216) collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor whiteColor];
        [collection registerClass:[WHFaceCell class] forCellWithReuseIdentifier:@"sdfwefwe"];
        collection.tag = 10+i;
        collection.delegate = self;
        collection.dataSource = self;
        [_scrollView addSubview:collection];
    }
    [self addSubview:_scrollView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag-10==_page-1) {
        return (_array.count)-(_page-1)*(_count-1)+1;
    }
    return _count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    int t = (int)collectionView.tag-10;
    WHFaceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sdfwefwe" forIndexPath:indexPath];
    if (t==_page-1) {
        if (indexPath.row==_array.count-(_page-1)*(_count-1)) {
            cell.myImageView.image = [UIImage imageNamed:@"common_btn_shanbiaoqing"];
        }
        else{
            int x =(int)((_count-1)*t+indexPath.row);
            cell.myLabel.text = _array[x];
        }
    }
    else{
        if (indexPath.row==_count-1) {
            cell.myImageView.image = [UIImage imageNamed:@"common_btn_shanbiaoqing"];
        }
        else{
            int x =(int)((_count-1)*t+indexPath.row);
            cell.myLabel.text = _array[x];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int t = (int)collectionView.tag - 10;
    if (t==_page-1) {
        if (indexPath.row==_array.count-(_page-1)*(_count-1)) {
            //最后一个删除
            [self deleteNSString];
        }
        else{
            int x =(int)((_count-1)*t+indexPath.row);
            NSString *string = _array[x];
            [self addNSString:string];
        }
    }
    else{
        if (indexPath.row==_count-1) {
             //最后一个删除
            [self deleteNSString];
        }
        else{
            int x =(int)((_count-1)*t+indexPath.row);
            NSString *string = _array[x];
            [self addNSString:string];
        }
    }
}
- (void)deleteNSString{
    NSRange range ;
    if (_isField==YES) {
       range = [_textField selectedRangea];
    }
    else{
        range = [_textView selectedRange];
    }
    if (range.location<=0) {
        return;
    }
    else if(range.location<=1){
        if (_isField==YES) {
            _textField.text = [_textField.text substringFromIndex:1];
            [_textField setSelectedRangea:NSMakeRange(0, 0)];
            return;
        }
        _textView.text = [_textView.text substringFromIndex:1];
        [_textView setSelectedRange:NSMakeRange(0, 0)];
        return;
    }
    NSString *string ;
    if (_isField==YES) {
        string = [_textField.text substringWithRange:NSMakeRange(range.location-2, 2)];
    }
    else{
        string = [_textView.text substringWithRange:NSMakeRange(range.location-2, 2)];
    }
    BOOL success = [self isExistInArray:string];
    if (success==YES) {
        if (_isField==YES) {
            NSString *leftString = [_textField.text substringToIndex:range.location-2];
            NSString *rightString = [_textField.text substringFromIndex:range.location];
            _textField.text = [NSString stringWithFormat:@"%@%@",leftString,rightString];
            [_textField setSelectedRangea:NSMakeRange(range.location-2, 0)];
            return;
        }
        NSString *leftString = [_textView.text substringToIndex:range.location-2];
        NSString *rightString = [_textView.text substringFromIndex:range.location];
        _textView.text = [NSString stringWithFormat:@"%@%@",leftString,rightString];
        [_textView setSelectedRange:NSMakeRange(range.location-2, 0)];
        return;
    }
    else{
        if (_isField==YES) {
            NSString *leftString = [_textField.text substringToIndex:range.location-1];
            NSString *rightString = [_textField.text substringFromIndex:range.location];
            _textField.text = [NSString stringWithFormat:@"%@%@",leftString,rightString];
            [_textField setSelectedRangea:NSMakeRange(range.location-1, 0)];
            return;
        }
        else{
            NSString *leftString = [_textView.text substringToIndex:range.location-1];
            NSString *rightString = [_textView.text substringFromIndex:range.location];
            _textView.text = [NSString stringWithFormat:@"%@%@",leftString,rightString];
            [_textView setSelectedRange:NSMakeRange(range.location-1, 0)];
            return;
        }
    }
}
- (void)addNSString:(NSString *)string{
    NSRange range;
    NSString *text;
    if (_isField==YES) {
        range = [_textField selectedRangea];
        text = _textField.text;
    }
    else{
        range = [_textView selectedRange];
        text = _textView.text;
    }
    NSString *leftText = [text substringToIndex:range.location];
    NSString *rightText = [text substringFromIndex:range.location];
    NSString *newText = [NSString stringWithFormat:@"%@%@%@",leftText,string,rightText];
    range.location = range.location+2;
    if (_isField==YES) {
        _textField.text = newText;
        [_textField setSelectedRangea:range];
    }
    else{
        _textView.text = newText;
        [_textView setSelectedRange:range];
    }
}
//检测是否在表情符的字典里
- (BOOL)isExistInArray:(NSString *)string{
    NSString *value = _dict[string];
    if (value!=nil) {
        return YES;
    }
    return NO;
}
@end
