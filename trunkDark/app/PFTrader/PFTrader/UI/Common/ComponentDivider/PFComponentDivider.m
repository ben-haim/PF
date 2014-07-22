#import "PFComponentDivider.h"

#import "NSString+DoubleFormatter.h"

@interface PFDoubleComponent : NSObject

@property ( nonatomic, strong ) NSString* separator;
@property ( nonatomic, strong ) NSString* stringValue;
@property ( nonatomic, assign ) NSUInteger digitsCount;
@property ( nonatomic, assign ) BOOL isInteger;

@property ( nonatomic, assign, readonly ) NSUInteger maximumValue;

+(id)integerComponentWithValue:( NSString* )value_;
+(id)integerComponentWithValue:( NSString* )value_
                     separator:( NSString* )separator_;

+(id)componentWithDigitsCount:( NSUInteger )digits_count_
                        value:( NSString* )value_;

-(NSString*)stringForValue:( NSUInteger )value_;

-(void)setValue:( NSUInteger )value_;

@end

@implementation PFDoubleComponent

@synthesize separator;
@synthesize stringValue = _stringValue;
@synthesize digitsCount;
@synthesize isInteger;

+(id)integerComponentWithValue:( NSString* )value_
{
   return [ self integerComponentWithValue: value_ separator: nil ];
}

+(id)integerComponentWithValue:( NSString* )value_
                     separator:( NSString* )separator_
{
   PFDoubleComponent* component_ = [ self new ];
   component_.digitsCount = [ value_ length ] + 1;
   component_.stringValue = value_;
   component_.isInteger = YES;
   component_.separator = separator_;
   return component_;
}

+(id)componentWithDigitsCount:( NSUInteger )digits_count_
                        value:( NSString* )value_
{
   PFDoubleComponent* component_ = [ self new ];
   component_.digitsCount = digits_count_;
   component_.stringValue = value_;
   return component_;
}

-(NSUInteger)maximumValue
{
   return pow( 10.0, self.digitsCount ) - 1;
}

-(void)setStringValue:( NSString* )current_value_
{
   NSAssert( [ current_value_ length ] <= self.digitsCount, @"invalid current value" );
   _stringValue = current_value_;
}

-(NSString*)stringForValue:( NSUInteger )value_
{
   NSString* value_formatter_ = self.isInteger ? @"%d" : [ NSString stringWithFormat: @"%%0.%dd", (int)self.digitsCount ];
   
   return [ NSString stringWithFormat: value_formatter_, value_ ];
}

-(void)setValue:( NSUInteger )value_
{
   self.stringValue = [ self stringForValue: value_ ];
}

-(NSString*)description
{
   if ( self.separator )
      return [ self.stringValue stringByAppendingString: self.separator ];

   return self.stringValue;
}

@end

@interface PFComponentDivider ()

@property ( nonatomic, strong ) NSArray* components;

@end

@implementation PFComponentDivider

@synthesize components;

-(NSString*)stringValue
{
   return [ self.components componentsJoinedByString: @"" ];
}

-(double)doubleValue
{
   return [ [ self stringValue ] doubleValue ];
}

-(NSUInteger)componentsCount
{
   return [ self.components count ];
}

+(id)dividerWithDouble:( double )double_
             precision:( NSUInteger )precision_
{
   PFComponentDivider* divider_ = [ self new ];

   NSString* double_string_ = [ NSString stringWithDouble: double_ precision: precision_ ];

   NSRange point_range_ = [ double_string_ rangeOfCharacterFromSet: [ NSCharacterSet punctuationCharacterSet ] ];

   NSMutableArray* components_ = [ NSMutableArray new ];
   if ( point_range_.location == NSNotFound )
   {
      [ components_ addObject: [ PFDoubleComponent integerComponentWithValue: double_string_ ] ];
   }
   else
   {
      NSString* integer_string_ = [ double_string_ substringToIndex:  point_range_.location ];
      NSString* separator_ = [ double_string_ substringWithRange:  point_range_ ];

      [ components_ addObject: [ PFDoubleComponent integerComponentWithValue: integer_string_
                                                                   separator: separator_ ] ];

      NSUInteger maximum_digits_in_component_ = 2;

      NSString* fraction_string_ = [ double_string_ substringFromIndex:  point_range_.location + 1 ];

      for ( NSUInteger location_ = 0; location_ < [ fraction_string_ length ]; )
      {
         NSUInteger precision_left_ = [ fraction_string_ length ] - location_;
         NSUInteger digits_in_component_ = fmin( precision_left_, maximum_digits_in_component_ );

         NSString* component_value_ = [ fraction_string_ substringWithRange: NSMakeRange( location_, digits_in_component_ ) ];

         [ components_ addObject: [ PFDoubleComponent componentWithDigitsCount: digits_in_component_ value: component_value_ ] ];

         location_ += digits_in_component_;
      }
   }
   
   divider_.components = components_;
   
   return divider_;
}

-(PFDoubleComponent*)componentAtIndex:( NSUInteger )index_
{
   return [ self.components objectAtIndex: index_ ];
}

-(NSUInteger)maximumValueForComponentWithIndex:( NSUInteger )index_
{
   return [ self componentAtIndex: index_ ].maximumValue;
}

-(void)setCurrentRow:( NSUInteger )current_row_
forComponentWithIndex:( NSUInteger )index_;
{
   [ self componentAtIndex: index_ ].value = current_row_;
}

-(NSUInteger)currentRowForComponentWithIndex:( NSUInteger )index_
{
   return [ [ self componentAtIndex: index_ ].stringValue integerValue ];
}

-(NSString*)valueForRow:( NSUInteger )row_
  forComponentWithIndex:( NSUInteger )index_
{
   return [ [ self componentAtIndex: index_ ] stringForValue: row_ ];
}

@end
