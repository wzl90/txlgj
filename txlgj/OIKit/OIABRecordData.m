//
//  OIABRecordData.m
//  BirthdayReminder
//
//  Created by wuzhuanlin on 15/11/26.
//
//

#import "OIABRecordData.h"
#import <AddressBook/AddressBook.h>
#import "UIDevice-Hardware.h"
#import "OIABDataUtil.h"
#import "CommonUtil.h"
#import "POAPinyin.h"
@implementation OIABRecord

@synthesize name,birthYear,birthMonth,birthDay,isLunar,imgData,recordId,phoneNum,hashedPhone,nIndex;
-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
@end

@implementation OIABRecordData
+(NSArray*)ABRecordsArray
{
    NSMutableArray *recordsArray = [[NSMutableArray alloc]initWithCapacity:2];
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status==kABAuthorizationStatusAuthorized)
    {
        //增加一个校验的字典(电话:名字)，用于处理本地通讯录关联icloud，导致存在两条信息
        NSMutableDictionary * checkDic = [NSMutableDictionary dictionary];
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
        CFArrayRef peoples = ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSInteger nPeople = (NSInteger)ABAddressBookGetPersonCount(addressBook);
        BOOL isIOS8 = [[UIDevice currentDevice].systemVersion floatValue]>=8.0;
        for (NSInteger abIndex = 0; abIndex  < nPeople; abIndex++)
        {
            ABRecordRef record = CFArrayGetValueAtIndex(peoples, abIndex);
            //读取通讯录Id
            NSInteger recordId = [OIABDataUtil getIdFromRecord:record];
            
            //读取姓名
            NSString *abName = [OIABDataUtil getNameFromRecord:record];
            if(abName.length==0)
                continue;
            
            NSMutableString *nIndex = [NSMutableString stringWithString:@""];
            for(int i = 0;i<[abName length];i++)
            {
                NSString *character = [abName substringWithRange:NSMakeRange(i, 1)];
                [nIndex appendFormat:@"%@%@",[POAPinyin stringConvert:character],character];
            }

            //读取生日，先取公历
            NSInteger year = 0;
            NSInteger month = 0;
            NSInteger day = 3;
            BOOL isLunar = NO;
            NSDateComponents *birthDC = [OIABDataUtil getBirthdayFromRecord:record];
            if(birthDC)
            {
                year = [birthDC year];
                if(year == 1604)
                {//1604 suggests user did not set year
                    year = 0;
                }
                else
                {
                    if(year < 1901 || year > 2049)//忽略年份
                    {
                        year = 0;
                    }
                }
                month = [birthDC month];
                day = [birthDC day];
            }
            //iOS8以上系统尝试读取农历生日，有则覆盖生日
            if(isIOS8)
            {
                NSDateComponents *lunarDC = [OIABDataUtil getLunarBirthdayFromRecord:record];
                if(lunarDC)
                {
                    isLunar = YES;
                    year = lunarDC.year;
                    month = lunarDC.month;
                    day = lunarDC.day;
                }
            }
            //读取头像
            NSData *imageData = [OIABDataUtil getImageDataFromRecord:record];

            //读取手机号
            NSArray *mobileArray = [OIABDataUtil getMobilesFromRecord:record];
            if (mobileArray.count>0)
            {
                NSString *mobileString = [mobileArray componentsJoinedByString:@"_"];
                NSString *tempKey = [NSString stringWithFormat:@"%@%@",abName,mobileString];
                if (!checkDic[tempKey])
                {
                    if (tempKey)
                    {
                        [checkDic setObject:@"key" forKey:tempKey];
                    }
                    OIABRecord *ABRecord = [[OIABRecord alloc]init];//HashedPhone取电话的时候直接处理
                    [ABRecord setName:abName];
                    [ABRecord setBirthYear:year];
                    [ABRecord setBirthMonth:month];
                    [ABRecord setBirthDay:day];
                    [ABRecord setIsLunar:isLunar];
                    if (imageData)
                    {
                        [ABRecord setImgData:imageData];
                    }
                    [ABRecord setPhoneNum:mobileString];//电话集合
                    [ABRecord setRecordId:recordId];
                    [ABRecord setNIndex:nIndex];
                    [recordsArray addObject:ABRecord];
                }
//                for(NSString *mobilePhone in mobileArray)
//                {
//                    NSString *tempKey = [NSString stringWithFormat:@"%@%@",abName,mobilePhone];
//                    if ([checkArray containsObject:tempKey])
//                    {
//                        continue;//电话和名字已经有了就跳过
//                    }
//                    else
//                    {
//                        [checkArray addObject:tempKey];
//                    }
//                    OIABRecord *ABRecord = [[OIABRecord alloc]init];
//                    [ABRecord setName:abName];
//                    [ABRecord setBirthYear:year];
//                    [ABRecord setBirthMonth:month];
//                    [ABRecord setBirthDay:day];
//                    [ABRecord setIsLunar:isLunar];
//                    if (imageData)
//                    {
//                        [ABRecord setImgData:imageData];
//                    }
//                    NSString *hashedNum = [CommonUtil hashNum:mobilePhone];
//                    [ABRecord setPhoneNum:mobilePhone];
//                    [ABRecord setHashedPhone:hashedNum];
//                    [ABRecord setRecordId:recordId];
//                    [ABRecord setNIndex:nIndex];
//                    [recordsArray addObject:ABRecord];
//                }
            }
            else
            {
                OIABRecord *ABRecord = [[OIABRecord alloc]init];
                [ABRecord setName:abName];
                [ABRecord setBirthYear:year];
                [ABRecord setBirthMonth:month];
                [ABRecord setBirthDay:day];
                [ABRecord setIsLunar:isLunar];
                [ABRecord setNIndex:nIndex];
                if (imageData)
                {
                    [ABRecord setImgData:imageData];
                }
                [ABRecord setRecordId:recordId];
                [recordsArray addObject:ABRecord];
            }
        }
        CFRelease(peoples);
        CFRelease(addressBook);
    }
    return recordsArray;
}
@end
