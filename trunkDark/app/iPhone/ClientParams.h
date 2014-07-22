

#import <Foundation/Foundation.h>


@interface ClientParams : NSObject {

}

//static
+ (UIColor *)fontColor;
+ (UIColor *)cellColor;
+ (UIColor *)cellColorSelected;
+ (UIColor *)cellBalanceColorSelected;
+ (UIColor *)demoMsgFontColor;
+ (UIColor *)demoMandatoryFontColor;
+ (UIImage *)demoBackground;
+ (UIImage *)marketWatchHeaderImage;
+ (UIColor *)cellBalanceColor;
+ (NSNumber*)cellBalanceLineDash;
+ (NSStringEncoding)newsSubjectEncoding;
+ (NSString*)newsEncodingName;
+ (NSStringEncoding)newsEncoding;
+ (NSStringEncoding)emailSubjectEncoding;
+ (NSStringEncoding)emailEncoding;

@end
