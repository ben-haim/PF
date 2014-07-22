#import "PFTableViewCategory.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <Foundation/Foundation.h>

@class PFMarketOperationViewController;

@interface PFTableViewCategory (Order)

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                                type:( PFOrderType )order_type_;

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                         level2Quote:( id< PFLevel2Quote > )level2_quote_;

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                                type:( PFOrderType )order_type_
                        defaultPrice:( double )default_price_;

+(id)quantityCategoryWithController:( PFMarketOperationViewController* )controller_
                               lots:( PFDouble )lots_;

+(id)categoryWithValidity:( PFOrderValidityType )validity_
     andAllowedValidities:( NSArray* )allowed_validities_
               controller:( PFMarketOperationViewController* )controller_;

+(id)stopLossCategoryWithController:( PFMarketOperationViewController* )controller_;

+(id)takeProfitCategoryWithController:( PFMarketOperationViewController* )controller_;

+(id)accountCategoryWithController:( PFMarketOperationViewController* )controller_
                              type:( PFOrderType )order_type_
                       level2Quote:( id< PFLevel2Quote > )level2_quote_
                      isLevel4Mode:( BOOL )is_level4_mode_;

@end

@protocol PFOrder;
@protocol PFLevel2Quote;

@interface PFTableViewCategory (ModifyOrder)

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                               order:( id< PFOrder > )order_;

+(id)quantityCategoryWithController:( PFMarketOperationViewController* )controller_
                              order:( id< PFOrder > )order_;

+(id)validityCategoryWithOrder:( id< PFOrder > )order_
                    controller:( PFMarketOperationViewController* )controller_;

@end
