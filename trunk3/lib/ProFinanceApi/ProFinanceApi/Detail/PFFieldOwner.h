#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@class PFField;
@class PFGroupField;

@interface PFFieldOwner : NSObject

@property ( nonatomic, strong, readonly ) NSArray* fields;

-(id)fieldWithId:( PFShort )id_;
-(id)writeFieldWithId:( PFShort )id_;

-(NSArray*)groupFieldsWithId:( PFInteger )group_id_;

-(PFGroupField*)groupFieldWithId:( PFInteger )group_id_;
-(PFGroupField*)writeGroupFieldWithId:( PFInteger )group_id_;

-(void)addField:( PFField* )field_;

@end


@interface PFFieldOwner (Optional)

-(PFInteger)integerValueForFieldWithId:( PFShort )id_;

@end
