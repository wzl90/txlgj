//
//  Hanzi.h
//  TestGround
//
//  Created by Luc on 11-10-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hanzi : NSObject
+ (NSString *) toPinyinFirstStr:(NSString *) hanzi;
+ (char) toPinyinFirstLetter: (unsigned short) hanzi;
+ (BOOL) isHanziLetter: (unsigned short) hanzi;
@end
