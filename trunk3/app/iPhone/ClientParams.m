

#import "ClientParams.h"
#import "ParamsStorage.h"

@implementation ClientParams

+ (UIColor *)fontColor
{
	return [UIColor blackColor];
}

+ (UIColor *)cellColor
{
	return HEXCOLOR(0xE7E3DEFF);
}

+ (UIColor *)cellColorSelected
{
	return [UIColor lightGrayColor];
}

+ (UIColor *)cellBalanceColor
{
	return HEXCOLOR(0xE7E3DEFF);
}

+ (UIColor *)cellBalanceColorSelected
{
	return HEXCOLOR(0xE7E3DEFF);
}

+ (NSNumber*)cellBalanceLineDash
{
	return [NSNumber numberWithFloat:1]; 
}

+ (UIColor *)demoMsgFontColor
{
	return [UIColor blackColor];
}

+ (UIColor *)demoMandatoryFontColor
{
	return [UIColor blackColor];
}

+ (UIImage *)demoBackground
{	
	return [UIImage imageNamed:@"reg_bg.png"];
}

+ (UIImage *)marketWatchHeaderImage
{
	return [UIImage imageNamed:@"market_header.png"];
}

+ (NSStringEncoding)newsSubjectEncoding
{
    return NSWindowsCP1251StringEncoding;
}

+ (NSString*)newsEncodingName
{
    return @"";
}

+ (NSStringEncoding)newsEncoding
{
    return NSASCIIStringEncoding;    
}

+ (NSStringEncoding)emailSubjectEncoding
{
    return NSWindowsCP1251StringEncoding;
}

+ (NSStringEncoding)emailEncoding
{
    return NSWindowsCP1251StringEncoding;    
}

@end
