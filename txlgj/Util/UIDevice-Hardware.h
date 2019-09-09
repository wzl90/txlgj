/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING				@"iFPGA"

#define IPHONE_1G_NAMESTRING			@"iPhone 1G"
#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS" 
#define IPHONE_4_NAMESTRING				@"iPhone 4" 
#define IPHONE_4S_NAMESTRING			@"iPhone 4S" 
#define IPHONE_5_NAMESTRING				@"iPhone 5"
#define IPHONE_5C_NAMESTRING			@"iPhone 5C"
#define IPHONE_5S_NAMESTRING			@"iPhone 5S"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6P_NAMESTRING			@"iPhone 6 Plus"
#define IPHONE_6S_NAMESTRING			@"iPhone 6S"
#define IPHONE_6SP_NAMESTRING			@"iPhone 6S Plus"
#define IPHONE_7_NAMESTRING             @"iPhone 7"
#define IPHONE_7P_NAMESTRING			@"iPhone 7 Plus"
#define IPHONE_8_NAMESTRING             @"iPhone 8"
#define IPHONE_8P_NAMESTRING             @"iPhone 8 Plus"
#define IPHONE_X_NAMESTRING            @"iPhone X"
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_5G_NAMESTRING				@"iPod touch 5G"
#define IPOD_6G_NAMESTRING				@"iPod touch 6G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad 1G"
#define IPAD_2G_NAMESTRING				@"iPad 2G"
#define IPAD_3G_NAMESTRING				@"iPad 3G"
#define IPAD_4G_NAMESTRING				@"iPad 4G"
#define IPAD_Air_NAMESTRING				@"iPad Air"
#define IPAD_Air2_NAMESTRING			@"iPad Air 2"
#define IPAD_mini_NAMESTRING			@"iPad mini"
#define IPAD_mini2_NAMESTRING			@"iPad mini 2"
#define IPAD_mini3_NAMESTRING			@"iPad mini 3"
#define IPAD_mini4_NAMESTRING			@"iPad mini 4"
#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

// Nano? Apple TV?
#define APPLETV_2G_NAMESTRING			@"Apple TV 2G"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

typedef enum {
	UIDeviceUnknown,
	
	UIDeviceiPhoneSimulator,
	UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
	UIDeviceiPhoneSimulatoriPad,
	
    UIDeviceiPhone1G,
    UIDeviceiPhone3G,
    UIDeviceiPhone3GS,
    UIDeviceiPhone4,
    UIDeviceiPhone4S,
    UIDeviceiPhone5,
    UIDeviceiPhone5C,
    UIDeviceiPhone5S,
    UIDeviceiPhone6,
    UIDeviceiPhone6P,
    UIDeviceiPhone6S,
    UIDeviceiPhone6SP,
    UIDeviceiPhone7,
    UIDeviceiPhone7P,
    UIDeviceiPhone8,
    UIDeviceiPhone8P,
    UIDeviceiPhoneX,
    
    UIDeviceiPod1G,
    UIDeviceiPod2G,
    UIDeviceiPod3G,
    UIDeviceiPod4G,
    UIDeviceiPod5G,
    UIDeviceiPod6G,
	
	UIDeviceiPad1G, // both regular and 3G
	UIDeviceiPad2G,
    UIDeviceiPad3G,
    UIDeviceiPad4G,
    UIDeviceiPadAir,
    UIDeviceiPadAir2,
    UIDeviceiPadmini,
    UIDeviceiPadmini2,
    UIDeviceiPadmini3,
    UIDeviceiPadmini4,
    
	UIDeviceAppleTV2,
	
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
	UIDeviceUnknowniPad,
	UIDeviceIFPGA,

} UIDevicePlatform;

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;
- (NSString *) platformCode;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;
- (NSString *) DecMacAddress;

- (NSString * )macString;
- (NSString *)idfaString;
- (NSString *)idfvString;

- (NSString *) deviceId;
- (NSString *) channelId;
- (NSString *) material;
- (NSString *)hashMaterial;
@end
