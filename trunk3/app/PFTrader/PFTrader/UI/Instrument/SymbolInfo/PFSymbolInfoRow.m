#import "PFSymbolInfoRow.h"

@interface PFSymbolInfoRow ()

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSString* value;

@end


@implementation PFSymbolInfoRow

@synthesize name;
@synthesize value;

+(id)infoRowWithName:( NSString* )name_
            andValue:( NSString* )value_
{
   PFSymbolInfoRow* info_row_ = [ PFSymbolInfoRow new ];
   
   info_row_.name = name_;
   info_row_.value = value_;
   
   return info_row_;
}

@end
