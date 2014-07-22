#import "PFPammAccountStatus.h"
#import "PFPammInvestor.h"

#import "PFMessage.h"
#import "PFMetaObject.h"
#import "PFField.h"

@interface PFPammAccountStatus ()

@property ( nonatomic, strong ) NSMutableDictionary* investors;

@end

@implementation PFPammAccountStatus

@synthesize pammStatusId;
@synthesize investors;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:
            [ PFMetaObjectField fieldWithId: PFFieldAccountId name:@"pammStatusId" ],
            nil ] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* pamm_investor_groups = [ field_owner_ groupFieldsWithId: PFGroupPammInvestor ];
   investors = [NSMutableDictionary new];
   
   for ( PFGroupField* pamm_investor_group in pamm_investor_groups )
   {
      PFPammInvestor* investor =[ PFPammInvestor objectWithFieldOwner: pamm_investor_group.fieldOwner ];
      [ self.investors setObject:investor forKey: @(investor.investId) ];
   }
}

-(NSArray*)allInvestors
{
   return [self.investors allValues];
}

@end
