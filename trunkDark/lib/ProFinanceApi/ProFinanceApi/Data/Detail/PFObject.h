#import "../../PFTypes.h"

#import <Foundation/Foundation.h>

@class PFFieldOwner;
@class PFMetaObject;
@class PFTrigger;

@interface PFObject : NSObject< NSCopying >

+(PFMetaObject*)cachedMetaObject;

+(id)objectWithFieldOwner:( PFFieldOwner* )field_owner_;
-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_;

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  fields:( NSArray* )fields_;

-(void)readFromFieldOwner:( PFFieldOwner* )field_owner_;

+(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_;

+(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
                  fields:( NSArray* )fields_;

+(id)readValueForKey:( NSString* )key_
      fromFieldOwner:( PFFieldOwner* )field_owner_;

-(void)addTrigger:( PFTrigger* )trigger_;

@end
