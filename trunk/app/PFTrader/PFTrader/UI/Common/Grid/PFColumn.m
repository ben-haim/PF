#import "PFColumn.h"

@implementation PFColumn

@synthesize title;
@synthesize secondTitle;

@synthesize cellBuilder;
@synthesize headerBuilder;

-(PFGridCell*)cellForGridView:( PFGridView* )grid_view_
                      context:( id )context_
{
   if ( self.cellBuilder )
   {
      return self.cellBuilder( grid_view_, context_ );
   }
   return nil;
}

-(UIView*)headerViewForGridView:( PFGridView* )grid_view_
{
   if ( self.headerBuilder )
   {
      return self.headerBuilder( grid_view_ );
   }
   return nil;
}

@end
