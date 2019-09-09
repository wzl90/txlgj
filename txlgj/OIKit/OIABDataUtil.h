//
//  OIABDataUtil.h
//  BirthdayReminder
//
//  Created by YuXiao on 15/11/25.
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface OIABDataUtil : NSObject
+(NSInteger)getIdFromRecord:(ABRecordRef)record;
+(NSString*)getNameFromRecord:(ABRecordRef)record;
/** 返回日期结构体，如果是1604年表示未设置年份
 @return NSDateComponents
 */
+(NSDateComponents*)getBirthdayFromRecord:(ABRecordRef)record;
+(NSDateComponents*)getLunarBirthdayFromRecord:(ABRecordRef)record;
+(NSArray*)getMobilesFromRecord:(ABRecordRef)record;
+(NSArray*)getEmailsFromRecord:(ABRecordRef)record;
+(NSData*)getImageDataFromRecord:(ABRecordRef)record;
//从通讯录的日期字段获取设置了纪念日的信息
+ (NSArray *)getAnniversaryFromDateInfoWithRecord:(ABRecordRef)record;
@end
