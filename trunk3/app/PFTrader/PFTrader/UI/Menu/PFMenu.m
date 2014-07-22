#import "PFMenu.h"

#import "PFMenuItem.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFMenu ()

@property ( nonatomic, strong ) NSArray* allItems;

@end

@implementation PFMenu

@synthesize allItems;

+(id)menuWithItems:( NSArray* )items_
{
   PFMenu* menu_ = [ self new ];
   menu_.allItems = items_;
   return menu_;
}

-(NSArray*)items
{
   return [ self.allItems select: ^BOOL( id object_ )
           {
              return [ object_ isVisible ];
           }];
}

@end
