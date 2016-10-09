//
//  WHKeyboardView.h
//  shareView
//
//  Created by Jiafei on 16/1/25.
//  Copyright © 2016年 com.wahool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHFaceView.h"
@protocol WHKeyboardViewDelegate<NSObject>
-(void)sendInfoAction:(NSString*)content;
@end
@interface WHKeyboardView : UIView<UITextViewDelegate>

@property(nonatomic,assign)id<WHKeyboardViewDelegate>delegate;
//初始化
-(instancetype)init;
@end
