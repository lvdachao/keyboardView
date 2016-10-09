//
//  UITextField+WHtentRange.m
//  textFieldDemo
//
//  Created by smjl on 16/1/29.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import "UITextField+WHtentRange.h"

@implementation UITextField (WHtentRange)

- (NSRange)selectedRangea{
    
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *seletionStart = selectedRange.start;
    UITextPosition *seletionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:seletionStart];
    const NSInteger length = [self offsetFromPosition:seletionStart toPosition:seletionEnd];
    return NSMakeRange(location, length);
}
- (void)setSelectedRangea:(NSRange)range{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
