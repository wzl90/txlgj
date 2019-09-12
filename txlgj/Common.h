//
//  Common.h
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/3.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#ifndef Common_h
#define Common_h


#endif /* Common_h */

#define kFont(fontName, fontSize) [CommonUtil getFontWithFontName:fontName andFontSize:fontSize]
#define OIRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kIPhoneXTopHeight ([UIScreen mainScreen].bounds.size.height == 812 ? 24 : 0)
#define kIPhoneXBottomHeight ([UIScreen mainScreen].bounds.size.height == 812 ? 34 : 0)
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kAutoW(a) floor(((a)* 1.0 / 375.0 * kScreenWidth))
