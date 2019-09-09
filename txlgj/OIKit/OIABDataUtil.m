//
//  OIABDataUtil.m
//  BirthdayReminder
//
//  Created by YuXiao on 15/11/25.
//
//

#import "OIABDataUtil.h"
#import "CommonUtil.h"
#import "OICalendarUtil.h"

@implementation OIABDataUtil

+(NSInteger)getIdFromRecord:(ABRecordRef)record
{
    return (NSInteger)ABRecordGetRecordID(record);
}

+(NSString*)getNameFromRecord:(ABRecordRef)record
{
    NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
    NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
    if(firstName==nil)
        firstName = @"";
    if(lastName==nil)
        lastName = @"";
    
    NSString *name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return name;
}

+(NSDateComponents*)getBirthdayFromRecord:(ABRecordRef)record
{
    NSDate *birthday = (NSDate *)CFBridgingRelease(ABRecordCopyValue(record, kABPersonBirthdayProperty));
    if(birthday)
    {
        return [[OICalendarUtil currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:birthday];
    }
    return nil;
}

+(NSDateComponents*)getLunarBirthdayFromRecord:(ABRecordRef)record
{
    NSDictionary *alternateBirthday = (NSDictionary*)CFBridgingRelease(ABRecordCopyValue(record, kABPersonAlternateBirthdayProperty));
    if(alternateBirthday)
    {
        NSString *calendarIdent = [alternateBirthday objectForKey:(NSString*)kABPersonAlternateBirthdayCalendarIdentifierKey];
        NSNumber *eraNumber = [alternateBirthday objectForKey:(NSString*)kABPersonAlternateBirthdayEraKey];
        NSNumber *yearNumber = [alternateBirthday objectForKey:(NSString*)kABPersonAlternateBirthdayYearKey];
        NSNumber *monthNumber = [alternateBirthday objectForKey:(NSString*)kABPersonAlternateBirthdayMonthKey];
        NSNumber *dayNumber = [alternateBirthday objectForKey:(NSString*)kABPersonAlternateBirthdayDayKey];
        NSNumber *isLeapMonth = [alternateBirthday objectForKey:(NSString*)kABPersonAlternateBirthdayIsLeapMonthKey];
        
        NSCalendar *chineseCal = [[NSCalendar alloc]initWithCalendarIdentifier:calendarIdent];
        NSDateComponents *dateDC = [[NSDateComponents alloc]init];
        [dateDC setEra:eraNumber.integerValue];
        [dateDC setYear:yearNumber.integerValue];
        [dateDC setMonth:monthNumber.integerValue];
        [dateDC setLeapMonth:isLeapMonth.boolValue];
        [dateDC setDay:dayNumber.integerValue];
        
        NSDate *tureDate = [chineseCal dateFromComponents:dateDC];
        NSDateComponents *solarDC = [[OICalendarUtil currentCalendar]components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:tureDate];
        if([NSCalendarIdentifierChinese isEqualToString:calendarIdent])//判断是否农历生日
        {
            if(solarDC.year>1901&&solarDC.year<2049)
            {
               return [OICalendarUtil toChineseDateWithYear:solarDC.year month:solarDC.month day:solarDC.day];
            }
            else
            {
                NSDateComponents *retDC = [[NSDateComponents alloc]init];
                [retDC setYear:1112];
                [retDC setMonth:monthNumber.integerValue];
                [retDC setDay:dayNumber.integerValue];
                return  retDC;
            }
        }
    }
    return nil;
}

+(NSArray*)getMobilesFromRecord:(ABRecordRef)record
{
    NSMutableArray *mobileArray = [NSMutableArray array];
    ABMultiValueRef phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
    if (phones)
    {
        CFIndex count = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < count; i++)
        {
            NSString *mobilePhone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
            if(mobilePhone)
            {
                mobilePhone = [CommonUtil mobileNum:mobilePhone];
                if(mobilePhone.length==11&&[mobilePhone hasPrefix:@"1"])
                {
                    [mobileArray addObject:mobilePhone];
                }
            }
        }
    }
    CFRelease(phones);
    return mobileArray;
}

+(NSArray*)getEmailsFromRecord:(ABRecordRef)record
{
    NSMutableArray *emailArray = [NSMutableArray array];
    ABMultiValueRef emails = ABRecordCopyValue(record, kABPersonEmailProperty);
    if(emails)
    {
        CFIndex emailcount = ABMultiValueGetCount(emails);
        for (CFIndex i = 0; i < emailcount; i++)
        {
            NSString *email = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
            [emailArray addObject:email];
        }
    }
    CFRelease(emails);
    return emailArray;
}

+(NSData*)getImageDataFromRecord:(ABRecordRef)record
{
    if(ABPersonHasImageData(record))
    {
        return (NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail));
    }
    return nil;
}

+ (NSArray *)getAnniversaryFromDateInfoWithRecord:(ABRecordRef)record
{
    ABMultiValueRef multiValue = (__bridge ABMultiValueRef)(CFBridgingRelease(ABRecordCopyValue(record, kABPersonDateProperty)));
    CFArrayRef arrayRef = ABMultiValueCopyArrayOfAllValues(multiValue);
    if (arrayRef == NULL)
    {
        return nil;
    }
    CFIndex count = CFArrayGetCount(arrayRef);
    NSMutableArray * tempArray = [NSMutableArray array];
    for (CFIndex i = 0; i < count; i++)
    {
        CFStringRef tempStrRef = ABMultiValueCopyLabelAtIndex(multiValue,i);
        NSString * tempStr = (__bridge NSString *)(tempStrRef);
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        NSDate * date = (__bridge NSDate *)(ABMultiValueCopyValueAtIndex(multiValue,i));
        if (CFStringCompare(kABPersonAnniversaryLabel, tempStrRef, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
        {
            if (date && tempStr)
            {
                [dic setObject:date forKey:@"纪念日"];
            }
        }
        else if(CFStringCompare(kABOtherLabel, tempStrRef, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
        {
            
        }
        else
        {
            if (date && [tempStr rangeOfString:@"纪念日"].location != NSNotFound)
            {
                [dic setObject:date forKey:tempStr];
            }
        }
        if (dic.count > 0)
        {
            [tempArray addObject:dic];
        }
        CFRelease(tempStrRef);
    }
    CFRelease(arrayRef);
    return tempArray;
}
@end
