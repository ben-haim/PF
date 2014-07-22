#import <ProFinanceApi/ProFinanceApi.h>

extern NSString* NSStringFromPFOrderType( PFOrderType order_type_ );
extern NSString* NSStringOrderTypeFromOperation( id< PFMarketOperation > operation_ );

extern PFOrderType PFOrderTypeFromNSString( NSString* order_type_ );