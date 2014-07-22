#import "PFTableViewCategory.h"

#import "PFTableViewItem.h"
#import "PFTableViewCategoryLabel.h"

#import "UIImage+PFTableView.h"

@interface PFTableViewCategory ()

@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, assign ) BOOL plain;
@property ( nonatomic, assign ) BOOL hasFooterSeparator;

@end

@implementation PFTableViewCategory

@synthesize title;
@synthesize items = _items;
@synthesize plain;
@synthesize hasFooterSeparator;

-(void)dealloc
{
   self.items = nil;
}

-(void)setItems:( NSArray* )items_
{
   for ( PFTableViewItem* item_ in self.items )
   {
      item_.category = nil;
   }

   for ( PFTableViewItem* item_ in items_ )
   {
      item_.category = self;
   }

   _items = items_;
}

-(id)initWithTitle:( NSString* )title_
             items:( NSArray* )items_
             plain:( BOOL )plain_
hasFooterSeparator:( BOOL )footer_separator_
{
   self = [ super init ];
   if ( self )
   {
      self.title = title_;
      self.items = items_;
      self.plain = plain_;
      self.hasFooterSeparator = footer_separator_;
   }
   return self;
}

+(id)categoryWithTitle:( NSString* )title_
                 items:( NSArray* )items_
                 plain:( BOOL )plain_
    hasFooterSeparator:( BOOL )footer_separator_
{
   return [ [ self alloc ] initWithTitle: title_
                                   items: items_
                                   plain: plain_
                      hasFooterSeparator: footer_separator_ ];
}

+(id)categoryWithTitle:( NSString* )title_
                 items:( NSArray* )items_
{
   return [ self categoryWithTitle: title_
                             items: items_
                             plain: NO
                hasFooterSeparator: NO ];
}

+(id)categoryWithTitle:( NSString* )title_
{
   return [ self categoryWithTitle: title_ items: nil ];
}

-(UIView*)headerViewForTableView:( UITableView* )table_view_
{
   if ( !self.title )
      return nil;

   UILabel* category_header_ = [ PFTableViewCategoryLabel new ];
   category_header_.text = self.title;
   return category_header_;
}

-(UIView*)footerViewForTableView:( UITableView* )table_view_
{
   UIView* footer_view_ = [ [ UIView alloc ] initWithFrame: table_view_.bounds ];
   if ( self.hasFooterSeparator )
   {
      UIImageView* line_view_ = [ [ UIImageView alloc ] initWithImage: [ UIImage tableSectionSeparatorImage ] ];
      CGRect line_rect_ = line_view_.frame;
      line_rect_.size.width = footer_view_.bounds.size.width;
      line_rect_.origin.y = 10.f;
      line_view_.frame = line_rect_;
      line_view_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      [ footer_view_ addSubview: line_view_ ];
   }
   return footer_view_;
}

-(CGFloat)headerHeightForTableView:( UITableView* )table_view_
{
   return self.title ? 30.f : 5.f;
}

-(CGFloat)footerHeightForTableView:( UITableView* )table_view_
{
   return self.hasFooterSeparator ? 35.f : 5.f;
}

-(void)performApplierForObject:( id )object_
{
   [ self.items makeObjectsPerformSelector: @selector( performApplierForObject: )
                                withObject: object_ ];
}

@end