#import "PFTableViewItem.h"

#import "PFTableViewItemCell.h"

#import "UIImage+PFTableView.h"

@interface PFTableViewItem ()

//!weak reference
@property ( nonatomic, weak ) PFTableViewItemCell* cell;

@end

@implementation PFTableViewItem

@synthesize category;
@synthesize cell;
@synthesize title;
@synthesize action;
@synthesize applier;
@synthesize accessoryType;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
{
   self = [ super init ];
   if ( self )
   {
      self.action = action_;
      self.title = title_;
   }
   return self;
}

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
{
   return [ [ self alloc ] initWithAction: action_ title: title_ ];
}

-(Class)cellClass
{
   return [ PFTableViewItemCell class ];
}

-(UITableViewCell*)cellForTableView:( UITableView* )table_view_
{
   Class cell_class_ = [ self cellClass ];

   NSString* const reusable_identifier_ = NSStringFromClass( cell_class_ );

   PFTableViewItemCell* cell_ = ( PFTableViewItemCell* )[ table_view_ dequeueReusableCellWithIdentifier: reusable_identifier_ ];

   if ( !cell_ )
   {
      cell_ = [ cell_class_ cell ];
   }

   if ( self.accessoryType == UITableViewCellAccessoryDisclosureIndicator )
   {
      cell_.accessoryView = [ [ UIImageView alloc ] initWithImage: [ UIImage tableAccessoryIndicatorImage ] ];
   }
   else
   {
      cell_.accessoryType = self.accessoryType;
   }

   cell_.item = self;
   self.cell = cell_;

   return cell_;
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return 44.f;
}

-(void)performApplierForObject:( id )object_
{
   if ( self.applier )
   {
      self.applier( self, object_ );
   }
}

-(void)performAction
{
   [ self.cell performAction ];

   if ( self.action )
   {
      self.action( self );
   }
}

@end
