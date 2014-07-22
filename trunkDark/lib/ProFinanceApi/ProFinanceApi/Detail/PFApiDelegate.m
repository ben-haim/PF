#import "PFApiDelegate.h"

@implementation NSObject (PFApiDelegate)

-(void)notImplementedApiDelegateMethod:( SEL )method_
{
   NSLog( @"WARNING. api delegate %@ method is not implemented", NSStringFromSelector( _cmd ) );
}

-(void)api:( PFApi* )api_ didLogonUser:( PFUser* )user_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLogoutWithReason:( NSString* )reason_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)didFinishTransferApi:( PFApi* )api_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadQuoteMessage:( PFMessage* )message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadLevel2Quote:( PFLevel2Quote* )quote_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadLevel2QuotePackage:( PFLevel2QuotePackage* )package_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadInstrument:( PFInstrument* )instrument_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadInstrumentGroup:( PFInstrumentGroup* )group_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadPositionMessage:( PFMessage* )message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didClosePositionWithId:( PFInteger )position_id_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadOrderMessage:( PFMessage* )message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadTradeMessage:( PFMessage* )message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadRouteMessage:( PFMessage* )message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadAccountMessage:( PFMessage* )message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadStories:( NSArray* )stories_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didReceiveErrorMessage:( NSString* )error_message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didReceiveRejectMessage:( PFRejectMessage* )reject_message_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didLoadReport:( PFReportTable* )report_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

-(void)api:( PFApi* )api_ didAllowReportWithName:( NSString* )report_name_
{
   [ self notImplementedApiDelegateMethod: _cmd ];
}

@end
