#import "PFAccountDetailRow.h"

#import "PFAccountDetailCell.h"

@implementation PFAccountDetailRow

@synthesize title = _title;
@synthesize initializer = _initializer;

-(void)dealloc
{
   [ _title release ];
   [ _initializer release ];

   [ super dealloc ];
}

+(id)rowWithTitle:( NSString* )title_
      initializer:( PFAccountDetailCellInitializer )initializer_
{
   PFAccountDetailRow* row_ = [ self new ];

   row_.title = title_;
   row_.initializer = initializer_;

   return [ row_ autorelease ];
}

-(void)initializeCell:( PFAccountDetailCell* )cell_
              account:( id< PFAccount > )account_
{
   cell_.titleLabel.text = self.title;
   if ( self.initializer )
   {
      self.initializer( cell_, account_ );
   }
}

@end
