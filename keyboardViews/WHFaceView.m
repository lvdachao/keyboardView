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
#import "UIColor+Hex.h"
@interface WHFaceView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end


@implementation WHFaceView
{
    UIPageControl * _pageControl;
    NSArray * _array;
    int _left;// 左边距
    int _right;//边距
    int _distance;//大小
    int _count;//一页多少
    int _page;//几页
    int _space;//间隔
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithHexString:@"#f0f0f0"];
        [self setUp];
        [self createScrollView];
        [self createPageControl];
    }
    return self;
}
- (void)createPageControl{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180, SCREENW, H(10))];
    _pageControl.numberOfPages = _page;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#dddadb"];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#47b233"];
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
}
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 256)];
    _array = [Emoji allEmoji];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_page*SCREENW, 256);
    _scrollView.showsHorizontalScrollIndicator=NO;
    for (int i = 0 ;i<_page;i++) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(W(_distance),H(_distance));
        flowLayout.minimumInteritemSpacing = W(_space);
        flowLayout.minimumLineSpacing = H(25);
        flowLayout.sectionInset = UIEdgeInsetsMake(H(40), W(_left), H(100), W(_right));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView * collection = [[UICollectionView alloc] initWithFrame:CGRectMake(i*SCREENW, 0, SCREENW, 256) collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
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
        return (_array.count)-(_page-1)*(_count-1);
    }
    return _count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    int t = (int)collectionView.tag-10;
    WHFaceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sdfwefwe" forIndexPath:indexPath];
    if (t==_page-1) {
        int x =(int)((_count-1)*t+indexPath.row);
        cell.myLabel.text = _array[x];
    }
    else{
        int x =(int)((_count-1)*t+indexPath.row);
        cell.myLabel.text = _array[x];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)collectionView.tag);
    NSLog(@"%ld",(long)indexPath.row);
    int t = (int)collectionView.tag - 10;
    if (_delegate) {
        int x =(int)((_count-1)*t+indexPath.row);
        [self.delegate getString:_array[x]];
    }
}
@end
