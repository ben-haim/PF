#import "../PFTypes.h"

#import "Detail/PFObject.h"
#import "PFOwnerType.h"

#import <Foundation/Foundation.h>

extern NSString* const PFRuleTerminalHTML;
extern NSString* const PFRuleFunctionRiskFromEquity;
extern NSString* const PFRuleFunctionSLTP;
extern NSString* const PFRuleFunctionTrailingStop;
extern NSString* const PFRuleFunctionOCO;
extern NSString* const PFRuleFunctionChat;
extern NSString* const PFRuleFunctionNews;
extern NSString* const PFRuleFunctionLevel2;
extern NSString* const PFRuleFunctionOptions;
extern NSString* const PFRuleFunctionWithdrawal;
extern NSString* const PFRuleFunctionEventLog;
extern NSString* const PFRuleBaseCurrency;
extern NSString* const PFRuleFunctionSymbolInfo;
extern NSString* const PFRuleMarginMode;
extern NSString* const PFRuleTransfer;

@protocol PFRule <NSObject>

-(NSString*)value;

-(PFBool)boolValue;

@end

@interface PFRule : PFObject< PFRule >

@property ( nonatomic, assign ) OwnerType ownerType;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSString* value;
@property ( nonatomic, assign ) PFLong accountId;
+(BOOL)compareOwnerTypes: (OwnerType)existing withNew:(OwnerType)newOwnerType;

@end
