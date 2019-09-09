/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <Security/Security.h>
#import <AdSupport/AdSupport.h>
#import "UIDevice-Hardware.h"
#import "KeychainItemWrapper.h"
#import "NSString+MD5Addition.h"

@implementation UIDevice (Hardware)

/*
 Platforms
 
 iFPGA ->		??

 iPhone1,1 ->	iPhone 1G
 iPhone1,2 ->	iPhone 3G
 iPhone2,1 ->	iPhone 3GS
 iPhone3,1 ->	iPhone 4/AT&T
 iPhone3,2 ->	iPhone 4/Other Carrier?
 iPhone3,3 ->	iPhone 4/Other Carrier?
 iPhone4,1 ->	??iPhone 5

 iPod1,1   -> iPod touch 1G 
 iPod2,1   -> iPod touch 2G 
 iPod2,2   -> ??iPod touch 2.5G
 iPod3,1   -> iPod touch 3G
 iPod4,1   -> iPod touch 4G
 iPod5,1   -> ??iPod touch 5G
 
 iPad1,1   -> iPad 1G, WiFi
 iPad1,?   -> iPad 1G, 3G <- needs 3G owner to test
 iPad2,1   -> iPad 2G (iProd 2,1)
 
 AppleTV2,1 -> AppleTV 2

 i386, x86_64 -> iPhone Simulator
*/


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

- (NSString *) platform
{
	return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Atomicbird
- (NSString *) hwmodel
{
	return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
	return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
	return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) totalMemory
{
	return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
	return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
	return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!
- (NSNumber *) totalDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
	NSString *platform = [self platform];
	// if ([platform isEqualToString:@"XX"])			return UIDeviceUnknown;
	
	if ([platform isEqualToString:@"iFPGA"])		return UIDeviceIFPGA;

    if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceiPhone1G;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceiPhone3G;
    if ([platform isEqualToString:@"iPhone2"])    return UIDeviceiPhone3GS;
    if ([platform isEqualToString:@"iPhone3"])    return UIDeviceiPhone4;
    if ([platform isEqualToString:@"iPhone4"])    return UIDeviceiPhone4S;
    if ([platform isEqualToString:@"iPhone5,1"])    return UIDeviceiPhone5;
    if ([platform isEqualToString:@"iPhone5,2"])    return UIDeviceiPhone5;
    if ([platform isEqualToString:@"iPhone5,3"])    return UIDeviceiPhone5C;
    if ([platform isEqualToString:@"iPhone5,4"])    return UIDeviceiPhone5C;
    if ([platform isEqualToString:@"iPhone6"])    return UIDeviceiPhone5S;
    if ([platform isEqualToString:@"iPhone7,2"])    return UIDeviceiPhone6;
    if ([platform isEqualToString:@"iPhone7,1"])    return UIDeviceiPhone6P;
    if ([platform isEqualToString:@"iPhone8,1"])    return UIDeviceiPhone6S;
    if ([platform isEqualToString:@"iPhone8,2"])    return UIDeviceiPhone6SP;
    if ([platform isEqualToString:@"iPhone9,1"])    return UIDeviceiPhone7;
    if ([platform isEqualToString:@"iPhone9,2"])    return UIDeviceiPhone7P;
    if ([platform isEqualToString:@"iPhone10,1"])    return UIDeviceiPhone8;
    if ([platform isEqualToString:@"iPhone10,2"])    return UIDeviceiPhone8P;
    if ([platform isEqualToString:@"iPhone10,3"])    return UIDeviceiPhoneX;

	if ([platform isEqualToString:@"iPod1,1"])   return UIDeviceiPod1G;
	if ([platform isEqualToString:@"iPod2,1"])   return UIDeviceiPod2G;
	if ([platform isEqualToString:@"iPod3,1"])   return UIDeviceiPod3G;
	if ([platform isEqualToString:@"iPod4,1"])   return UIDeviceiPod4G;
    if ([platform isEqualToString:@"iPod5,1"])   return UIDeviceiPod5G;
    if ([platform isEqualToString:@"iPod7,1"])   return UIDeviceiPod6G;
		
    if ([platform isEqualToString:@"iPad1"])      return UIDeviceiPad1G;
    if ([platform isEqualToString:@"iPad2,1"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,2"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,3"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,4"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,5"])      return UIDeviceiPadmini;
    if ([platform isEqualToString:@"iPad2,6"])      return UIDeviceiPadmini;
    if ([platform isEqualToString:@"iPad2,7"])      return UIDeviceiPadmini;
    if ([platform isEqualToString:@"iPad3,1"])      return UIDeviceiPad3G;
    if ([platform isEqualToString:@"iPad3,2"])      return UIDeviceiPad3G;
    if ([platform isEqualToString:@"iPad3,3"])      return UIDeviceiPad3G;
    if ([platform isEqualToString:@"iPad3,4"])      return UIDeviceiPad4G;
    if ([platform isEqualToString:@"iPad3,5"])      return UIDeviceiPad4G;
    if ([platform isEqualToString:@"iPad3,6"])      return UIDeviceiPad4G;
    if ([platform isEqualToString:@"iPad4,1"])      return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,2"])      return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,3"])      return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,4"])      return UIDeviceiPadmini2;
    if ([platform isEqualToString:@"iPad4,5"])      return UIDeviceiPadmini2;
    if ([platform isEqualToString:@"iPad4,6"])      return UIDeviceiPadmini2;
    if ([platform isEqualToString:@"iPad4,7"])      return UIDeviceiPadmini3;
    if ([platform isEqualToString:@"iPad4,8"])      return UIDeviceiPadmini3;
    if ([platform isEqualToString:@"iPad4,9"])      return UIDeviceiPadmini3;
    if ([platform isEqualToString:@"iPad5,1"])      return UIDeviceiPadmini4;
    if ([platform isEqualToString:@"iPad5,2"])      return UIDeviceiPadmini4;
    if ([platform isEqualToString:@"iPad5,3"])      return UIDeviceiPadAir2;
    if ([platform isEqualToString:@"iPad5,4"])      return UIDeviceiPadAir2;
	
	if ([platform isEqualToString:@"AppleTV2,1"])	return UIDeviceAppleTV2;
	
	/*
	 MISSING A SOLUTION HERE TO DATE TO DIFFERENTIATE iPAD and iPAD 3G.... SORRY!
	 */

	if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
	if ([platform hasPrefix:@"iPad"]) return UIDeviceUnknowniPad;
	
	if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) // thanks Jordan Breeding
	{
		if ([[UIScreen mainScreen] bounds].size.width < 768)
			return UIDeviceiPhoneSimulatoriPhone;
		else 
			return UIDeviceiPhoneSimulatoriPad;

		return UIDeviceiPhoneSimulator;
	}
	return UIDeviceUnknown;
}

- (NSString *) platformString
{
	switch ([self platformType])
	{
		case UIDeviceiPhone1G: return IPHONE_1G_NAMESTRING;
		case UIDeviceiPhone3G: return IPHONE_3G_NAMESTRING;
		case UIDeviceiPhone3GS:	return IPHONE_3GS_NAMESTRING;
		case UIDeviceiPhone4:	return IPHONE_4_NAMESTRING;
        case UIDeviceiPhone4S:  return IPHONE_4S_NAMESTRING;
		case UIDeviceiPhone5:	return IPHONE_5_NAMESTRING;
        case UIDeviceiPhone5C:	return IPHONE_5C_NAMESTRING;
        case UIDeviceiPhone5S:	return IPHONE_5S_NAMESTRING;
        case UIDeviceiPhone6:	return IPHONE_6_NAMESTRING;
        case UIDeviceiPhone6P:	return IPHONE_6P_NAMESTRING;
        case UIDeviceiPhone6S:	return IPHONE_6S_NAMESTRING;
        case UIDeviceiPhone6SP:	return IPHONE_6SP_NAMESTRING;
        case UIDeviceiPhone7:	return IPHONE_7_NAMESTRING;
        case UIDeviceiPhone7P:	return IPHONE_7P_NAMESTRING;
        case UIDeviceiPhone8:    return IPHONE_8_NAMESTRING;
        case UIDeviceiPhone8P:    return IPHONE_8P_NAMESTRING;
        case UIDeviceiPhoneX:    return IPHONE_X_NAMESTRING;
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
		
		case UIDeviceiPod1G: return IPOD_1G_NAMESTRING;
		case UIDeviceiPod2G: return IPOD_2G_NAMESTRING;
		case UIDeviceiPod3G: return IPOD_3G_NAMESTRING;
		case UIDeviceiPod4G: return IPOD_4G_NAMESTRING;
        case UIDeviceiPod5G: return IPOD_5G_NAMESTRING;
        case UIDeviceiPod6G: return IPOD_6G_NAMESTRING;
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDeviceiPad1G : return IPAD_1G_NAMESTRING;
		case UIDeviceiPad2G : return IPAD_2G_NAMESTRING;
        case UIDeviceiPad3G : return IPAD_3G_NAMESTRING;
        case UIDeviceiPad4G : return IPAD_4G_NAMESTRING;
        case UIDeviceiPadAir : return IPAD_Air_NAMESTRING;
        case UIDeviceiPadAir2 : return IPAD_Air2_NAMESTRING;
        case UIDeviceiPadmini : return IPAD_mini_NAMESTRING;
        case UIDeviceiPadmini2 : return IPAD_mini2_NAMESTRING;
        case UIDeviceiPadmini3 : return IPAD_mini3_NAMESTRING;
        case UIDeviceiPadmini4 : return IPAD_mini4_NAMESTRING;
			
		case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
			
		case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
		case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
		case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_IPAD_NAMESTRING;
			
		case UIDeviceIFPGA: return IFPGA_NAMESTRING;
			
		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
	int					mib[6];
	size_t				len;
	char				*buf;
	unsigned char		*ptr;
	struct if_msghdr	*ifm;
	struct sockaddr_dl	*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error\n");
		return @"";
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1\n");
		return @"";
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!\n");
		return @"";
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return @"";
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	// NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

- (NSString *)DecMacAddress
{
    int					mib[6];
	size_t				len;
	char				*buf;
	unsigned char		*ptr;
	struct if_msghdr	*ifm;
	struct sockaddr_dl	*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error\n");
		return 0;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1\n");
		return 0;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!\n");
		return 0;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return 0;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
    
    long long mac1 = *ptr;
    long long mac2 = *(ptr+1);
    long long mac3 = *(ptr+2);
    long long mac4 = *(ptr+3);
    long long mac5 = *(ptr+4);
    long long mac6 = *(ptr+5);
    
    long long decMac = mac1*256*256*256*256*256 + mac2*256*256*256*256 + mac3*256*256*256 + mac4*256*256 + mac5*256 + mac6;
    
	free(buf);
    
    return [NSString stringWithFormat:@"%015lld",decMac];
}

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}


- (NSString *) platformCode
{
	switch ([self platformType])
	{
		case UIDeviceiPhone1G: return @"M68";
		case UIDeviceiPhone3G: return @"N82";
		case UIDeviceiPhone3GS:	return @"N88";
		case UIDeviceiPhone4: return @"N89";
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDeviceiPod1G: return @"N45";
		case UIDeviceiPod2G: return @"N72";
		case UIDeviceiPod3G: return @"N18";
		case UIDeviceiPod4G: return @"N80";
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDeviceiPad1G: return @"K48";
		case UIDeviceUnknowniPad: return IPAD_UNKNOWN_NAMESTRING;
			
		case UIDeviceAppleTV2:	return @"K66";

		case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
			
		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}

- (NSString *)deviceId
{
    NSString *deviceId = [[KeychainItemWrapper sharedWrapper]objectForKey:(__bridge NSString*)kSecValueData];
    if (deviceId==nil||[deviceId isEqualToString:@""])
    {
        CGFloat version = [[self systemVersion]floatValue];
        if(version<7.0)
        {
            NSString *mac = [self macaddress];
            deviceId = [mac stringFromMD5];
        }
        else
        {
            if([self respondsToSelector:@selector(identifierForVendor)])//iOS6方法
            {
                NSString *tempString = [[self identifierForVendor]UUIDString];
                deviceId = [tempString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            else
            {   
                CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
                CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
                
                CFRelease(uuid_ref);
                NSString *tempString = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
                deviceId = [tempString stringByReplacingOccurrencesOfString:@"-" withString:@""];
                CFRelease(uuid_string_ref);
            }
        }
        [[KeychainItemWrapper sharedWrapper]setObject:deviceId forKey:(__bridge NSString*)kSecValueData];
    }
    
    return deviceId;
}

- (NSString *)channelId
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"channelId"])//联网取下来的channel
    {
        return [NSString stringWithFormat:@"%ld",[[[NSUserDefaults standardUserDefaults]objectForKey:@"channelId"]integerValue]];
    }
    return @"0";
//    NSString *channel = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"channel" ofType:@"chn"] encoding:NSUTF8StringEncoding error:nil];
//    
//    if(channel==nil)
//        channel = @"0";
//    return channel;
}

// Illicit Bluetooth check -- cannot be used in App Store
/* 
Class  btclass = NSClassFromString(@"GKBluetoothSupport");
if ([btclass respondsToSelector:@selector(bluetoothStatus)])
{
	printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
	bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
	printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
}
*/
-(NSString*)material
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"material"])//联网取下来的material
    {
        return [[NSUserDefaults standardUserDefaults]objectForKey:@"material"];
    }
    return @"0";
}
- (NSString *)hashMaterial
{
    NSString * hashMaterial = [[NSUserDefaults standardUserDefaults] objectForKey:@"hash_material"];
    if (hashMaterial)
    {
        return hashMaterial;
    }
    else
    {
        return nil;
    }
}
@end
