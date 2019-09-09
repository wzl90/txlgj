//
//  NSNull+NSNull_Category.h
//  BirthdayReminder
//
//  Created by YuXiao on 15/2/11.
//
//

#import <Foundation/Foundation.h>

@interface NSNull (Category)
- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
@end