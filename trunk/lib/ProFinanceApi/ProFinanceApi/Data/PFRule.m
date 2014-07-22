#import "PFRule.h"

#import "PFMetaObject.h"
#import "PFField.h"

NSString* const PFRuleTerminalHTML = @"TERMINAL_HTML";
NSString* const PFRuleFunctionRiskFromEquity = @"FUNCTION_RISK_FROM_EQUITY";
NSString* const PFRuleFunctionSLTP = @"FUNCTION_SLTP";
NSString* const PFRuleFunctionTrailingStop = @"FUNCTION_TRAILING_STOP";
NSString* const PFRuleFunctionOCO = @"FUNCTION_BINDEDORDERS";
NSString* const PFRuleFunctionChat = @"FUNCTION_CHAT";
NSString* const PFRuleFunctionNews = @"FUNCTION_NEWS";
NSString* const PFRuleFunctionLevel2 = @"FUNCTION_LEVEL2";
NSString* const PFRuleFunctionOptions = @"FUNCTION_OPTIONS";
NSString* const PFRuleFunctionWithdrawal = @"FUNCTION_RESERVER_WITHDRAWAL";
NSString* const PFRuleFunctionEventLog = @"FUNCTION_EVENT_LOG";
NSString* const PFRuleBaseCurrency = @"FUNCTION_BASE_CURRENCY";
NSString* const PFRuleFunctionSymbolInfo = @"FUNCTION_SYMBOL_INFO";
NSString* const PFRuleFunctionTrading = @"FUNCTION_TRADING";
NSString* const PFRuleFunctionNotAllowOpenPosition = @"FUNCTION_NOT_ALLOW_OPEN_POSITION";
NSString* const PFRuleFunctionClosePositionsDisable = @"FUNCTION_CLOSE_POSITIONS_DISABLE";
NSString* const PFRuleFunctionNotAllowShortStock = @"FUNCTION_NOT_ALLOW_SHORT_STOCK";

enum
{
   RFRuleIndexName
   , RFRuleIndexValue
};

@implementation PFRule

@synthesize name;
@synthesize value;
@synthesize accountId;

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer name_value_splitter_ = ^id(id object_, PFFieldOwner* field_owner_, id value_)
   {
      NSString* string_value_ = ( NSString* )value_;
      NSArray* name_value_ = [ string_value_ componentsSeparatedByString: @"=" ];
      PFRule* rule_ = ( PFRule* )object_;
      rule_.name = [ name_value_ objectAtIndex: RFRuleIndexName ];
      return [ name_value_ objectAtIndex: RFRuleIndexValue ];
   };

   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithName: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldValue name: @"value" transformer: name_value_splitter_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldId name: @"accountId" ]
            , nil ] ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.accountId = -1;
   }
   return self;
}

-(PFBool)boolValue
{
   return [ self.value intValue ] != 0;
}

@end
