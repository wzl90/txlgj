//
//  OIABRecordData.h
//  BirthdayReminder
//
//  Created by wuzhuanlin on 15/11/26.
//
//

#import <Foundation/Foundation.h>

@interface OIABRecord : NSObject
{
    NSString *name;
    NSInteger birthYear;
    NSInteger birthMonth;
    NSInteger birthDay;
    BOOL isLunar;
    NSString *phoneNum;
    NSString *hashedPhone;
    NSData *imgData;
    NSInteger recordId;
    NSString *nIndex;
}
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger birthYear;
@property(nonatomic,assign)NSInteger birthMonth;
@property(nonatomic,assign)NSInteger birthDay;
@property(nonatomic,assign)BOOL isLunar;
@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *hashedPhone;
@property(nonatomic,strong)NSData *imgData;
@property(nonatomic,assign)NSInteger recordId;
@property(nonatomic,strong)NSString *nIndex;
@property(nonatomic,assign)BOOL isSelected;
@end

@interface OIABRecordData : NSObject
+(NSArray*)ABRecordsArray;
@end
