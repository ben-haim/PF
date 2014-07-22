#import "PFIndicator.h"

#import "PFIndicatorLocalizedString.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFIndicatorAttribute ()

@property ( nonatomic, strong ) NSString* code;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFIndicatorAttributeType type;

+(id)attributeWithType:( PFIndicatorAttributeType )type_;

@end

@implementation PFIndicatorAttribute

@synthesize code;
@synthesize name;
@synthesize type;

+(NSDictionary*)classByType
{
   static NSDictionary* class_by_type_ = nil;
   if ( !class_by_type_ )
   {
      class_by_type_ = @{
      @(PFIndicatorAttributeTypeColor): [ PFIndicatorAttributeColor class ]
      , @(PFIndicatorAttributeTypeApply): [ PFIndicatorAttributeApply class ]
      , @(PFIndicatorAttributeTypeInterval): [ PFIndicatorAttributeInterval class ]
      , @(PFIndicatorAttributeTypeWidth) : [ PFIndicatorAttributeWidth class ]
      , @(PFIndicatorAttributeTypeDash) : [ PFIndicatorAttributeDash class ]
      , @(PFIndicatorAttributeTypeBool) : [ PFIndicatorAttributeBool class ]
      , @(PFIndicatorAttributeTypeDouble) : [ PFIndicatorAttributeDouble class ]
      };
   }
   return class_by_type_;
}

+(id)attributeWithType:( PFIndicatorAttributeType )type_
{
   Class attribute_class_ = [ self classByType ][@(type_)];

   if ( !attribute_class_ )
      attribute_class_ = [ PFIndicatorAttribute class ];

   PFIndicatorAttribute* attribute_ = [ attribute_class_ new ];
   attribute_.type = type_;
   return attribute_;
}

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   self.name = dictionary_[@"label"];
}

-(NSString*)title
{
   return PFIndicatorLocalizedString( self.name, nil );
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
}

-(NSDictionary*)dictionary
{
   NSMutableDictionary* dictionary_ =
   [ @{
    @"type": @(self.type)
    , @"label": self.name
    } mutableCopy ];
   
   [ self writeToDictionary: dictionary_ ];
   
   return dictionary_;
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeColor

@synthesize colorValue;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];

   NSScanner* scanner_ = [ NSScanner scannerWithString: dictionary_[@"value"] ];
   uint value_ = 0;
   [ scanner_ scanHexInt: &value_ ];
   self.colorValue = value_;
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = [ NSString stringWithFormat: @"0x%08X", self.colorValue ];
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeApply

@synthesize applyType;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];

   self.applyType = (PFIndicatorAttributeApplyType)[ dictionary_[@"value"] integerValue ];
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = @(self.applyType);
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeWidth

@synthesize width;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];

   self.width = [ dictionary_[@"value"] integerValue ];
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = @(self.width);
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeInterval

@synthesize value;
@synthesize min;
@synthesize max;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];

   self.value = [ dictionary_[@"value"] integerValue ];
   self.min = [ dictionary_[@"min"] integerValue ];
   self.max = [ dictionary_[@"max"] integerValue ];
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = @(self.value);
   dictionary_[@"min"] = @(self.min);
   dictionary_[@"max"] = @(self.max);
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeBool

@synthesize value;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];
   
   self.value = [ dictionary_[@"value"] boolValue ];
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = @(self.value);
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeDash

@synthesize dash;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];
   
   self.dash = [ dictionary_[@"value"] integerValue ];
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = @(self.dash);
}

@end

///////////////////////////////////////////////////////////////

@implementation PFIndicatorAttributeDouble

@synthesize value;
@synthesize min;
@synthesize max;
@synthesize step;
@synthesize digits;

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   [ super readFromDictionary: dictionary_ ];
   
   self.value = [ dictionary_[@"value"] doubleValue ];
   self.min = [ dictionary_[@"min"] doubleValue ];
   self.max = [ dictionary_[@"max"] doubleValue ];
   self.step = [ dictionary_[@"step"] doubleValue ];
   self.digits = [ dictionary_[@"digits"] unsignedIntValue ];
}

-(void)writeToDictionary:( NSMutableDictionary* )dictionary_
{
   dictionary_[@"value"] = @(self.value);
   dictionary_[@"min"] = @(self.min);
   dictionary_[@"max"] = @(self.max);
   dictionary_[@"step"] = @(self.step);
   dictionary_[@"digits"] = @(self.digits);
}


@end

///////////////////////////////////////////////////////////////

@interface PFIndicatorLine ()

@property ( nonatomic, strong ) NSString* code;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSArray* attributes;

@end

@implementation PFIndicatorLine

@synthesize code;
@synthesize name;
@synthesize attributes;

-(NSString*)title
{
   return PFIndicatorLocalizedString( self.name, nil );
}

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   self.name = dictionary_[@"name"];

   NSArray* attribute_codes_ = dictionary_[@"order"];
   NSMutableArray* attributes_ = [ NSMutableArray arrayWithCapacity: [ attribute_codes_ count ] ];
   for ( NSString* code_ in attribute_codes_ )
   {
      NSDictionary* attribute_dictionary_ = dictionary_[code_];
      
      PFIndicatorAttributeType type_ = (PFIndicatorAttributeType)[ attribute_dictionary_[@"type"] integerValue ];
      
      PFIndicatorAttribute* attribute_ = [ PFIndicatorAttribute attributeWithType: type_ ];
      if ( attribute_ )
      {
         attribute_.code = code_;
         [ attribute_ readFromDictionary: attribute_dictionary_ ];
         [ attributes_ addObject: attribute_ ];
      }
   }
   self.attributes = attributes_;
}

-(NSDictionary*)dictionary
{
   NSMutableDictionary* dictionary_ =
   [ @{
    @"name": self.name
    , @"order": [ self.attributes valueForKeyPath: @"@unionOfObjects.code" ]
    } mutableCopy ];

   for ( PFIndicatorAttribute* attribute_ in self.attributes )
   {
      dictionary_[attribute_.code] = [ attribute_ dictionary ];
   }

   return dictionary_;
}

@end

///////////////////////////////////////////////////////////////

@interface PFIndicator ()

@property ( nonatomic, strong ) NSString* code;
@property ( nonatomic, strong ) NSString* name;

@property ( nonatomic, strong ) NSArray* lines;

@property ( nonatomic, assign ) BOOL main;

@end


@implementation PFIndicator

@synthesize indicatorId;
@synthesize code;
@synthesize name;

@synthesize lines;

@synthesize main;

-(NSString*)title
{
   return PFIndicatorLocalizedString( self.name, nil );
}

-(void)readFromDictionary:( NSDictionary* )dictionary_
{
   self.code = dictionary_[@"code"];
   self.name = dictionary_[@"title"];
   self.main = [ dictionary_[@"mainchart"] integerValue ];

   NSArray* line_codes_ = dictionary_[@"sec_order"];
   NSMutableArray* lines_ = [ NSMutableArray arrayWithCapacity: [ line_codes_ count ] ];
   for ( NSString* code_ in line_codes_ )
   {
      PFIndicatorLine* line_ = [ PFIndicatorLine new ];
      line_.code = code_;

      NSDictionary* line_dictionary_ = dictionary_[code_];
      [ line_ readFromDictionary: line_dictionary_ ];
      [ lines_ addObject: line_ ];
   }

   self.lines = lines_;
}

-(NSDictionary*)dictionary
{
   NSMutableDictionary* dictionary_ =
   [ @{
    @"code": self.code
    , @"title": self.name
    , @"mainchart": @(self.main)
    , @"sec_order": [ self.lines valueForKeyPath: @"@unionOfObjects.code" ]
    } mutableCopy ];
   
   for ( PFIndicatorLine* line_ in self.lines )
   {
      dictionary_[line_.code] = [ line_ dictionary ];
   }

   return dictionary_;
}

-(id)initWithDictionary:( NSDictionary* )dictionary_
{
   self = [ super init ];
   if ( self )
   {
      [ self readFromDictionary: dictionary_ ];
   }
   return self;
}

-(id)copyWithZone:( NSZone* )zone_
{
   return [ [ [ self class ] alloc ] initWithDictionary: self.dictionary ];
}

-(BOOL)isEqualToIndicator:( PFIndicator* )indicator_
{
   return [ self.indicatorId isEqualToString: indicator_.indicatorId ];
}

-(BOOL)isEqual:( id )other_
{
   if ( [ self class ] != [ other_ class ] )
      return NO;

   PFIndicator* indicator_ = ( PFIndicator* )other_;
   return [ self isEqualToIndicator: indicator_ ];
}

@end


