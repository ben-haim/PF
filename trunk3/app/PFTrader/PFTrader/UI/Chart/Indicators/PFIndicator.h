#import <Foundation/Foundation.h>

typedef enum
{
   PFIndicatorAttributeTypeColor
   , PFIndicatorAttributeTypeInterval = 1
   , PFIndicatorAttributeTypeWidth = 2
   , PFIndicatorAttributeTypeDash = 3
   , PFIndicatorAttributeTypeApply = 4
   , PFIndicatorAttributeTypeBool = 5
   , PFIndicatorAttributeTypeDouble = 6
} PFIndicatorAttributeType;

@interface PFIndicatorAttribute : NSObject

@property ( nonatomic, strong, readonly ) NSString* code;
@property ( nonatomic, strong, readonly ) NSString* title;
@property ( nonatomic, assign, readonly ) PFIndicatorAttributeType type;

@end

typedef enum
{
   PFIndicatorAttributeApplyTypeClose
   , PFIndicatorAttributeApplyTypeOpen
   , PFIndicatorAttributeApplyTypeHigh
   , PFIndicatorAttributeApplyTypeLow
   , PFIndicatorAttributeApplyTypeHL2
   , PFIndicatorAttributeApplyTypeHLC2
   , PFIndicatorAttributeApplyTypeHLC3
   , PFIndicatorAttributeApplyTypeHLCC4
} PFIndicatorAttributeApplyType;

@interface PFIndicatorAttributeColor : PFIndicatorAttribute

@property ( nonatomic, assign ) uint colorValue;

@end

@interface PFIndicatorAttributeApply : PFIndicatorAttribute

@property ( nonatomic, assign ) PFIndicatorAttributeApplyType applyType;

@end

@interface PFIndicatorAttributeWidth : PFIndicatorAttribute

@property ( nonatomic, assign ) NSUInteger width;

@end

@interface PFIndicatorAttributeInterval : PFIndicatorAttribute

@property ( nonatomic, assign ) NSInteger value;
@property ( nonatomic, assign ) NSInteger min;
@property ( nonatomic, assign ) NSInteger max;

@end

@interface PFIndicatorAttributeDash : PFIndicatorAttribute

@property ( nonatomic, assign ) NSUInteger dash;

@end

@interface PFIndicatorAttributeBool : PFIndicatorAttribute

@property ( nonatomic, assign ) BOOL value;

@end

@interface PFIndicatorAttributeDouble : PFIndicatorAttribute

@property ( nonatomic, assign ) double value;
@property ( nonatomic, assign ) double min;
@property ( nonatomic, assign ) double max;
@property ( nonatomic, assign ) double step;
@property ( nonatomic, assign ) uint digits;

@end

@interface PFIndicatorLine : NSObject

@property ( nonatomic, strong, readonly ) NSString* code;
@property ( nonatomic, strong, readonly ) NSString* title;
@property ( nonatomic, strong, readonly ) NSArray* attributes;

@end


@interface PFIndicator : NSObject< NSCopying >

@property ( nonatomic, strong ) NSString* indicatorId;
@property ( nonatomic, strong, readonly ) NSString* code;
@property ( nonatomic, strong, readonly ) NSString* title;
@property ( nonatomic, strong, readonly ) NSArray* lines;

@property ( nonatomic, assign, readonly ) BOOL main;

-(id)initWithDictionary:( NSDictionary* )dictionary_;

-(NSDictionary*)dictionary;

-(BOOL)isEqualToIndicator:( PFIndicator* )indicator_;

@end


