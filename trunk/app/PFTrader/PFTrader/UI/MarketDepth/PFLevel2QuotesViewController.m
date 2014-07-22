#import "PFLevel2QuotesViewController.h"

#import "PFLevel2QuoteColumn.h"

#import "UIView+AddSubviewAndScale.h"
#import "UIImage+PFGridView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFLevel2QuotesViewController ()

@property ( nonatomic, strong ) NSArray* levelColors;
@property ( nonatomic, strong ) NSArray* backgroundColors;

@end

@implementation PFLevel2QuotesViewController

@synthesize levelColors;
@synthesize backgroundColors;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.levelColors = [ [ NSArray alloc ] initWithObjects:
                          [ UIColor colorWithRed: 44.0 / 255.0 green: 120.0 / 255.0 blue: 183.0 / 255.0 alpha: 1.0 ]
                          , [ UIColor colorWithRed: 22.0 / 255.0 green: 81.0 / 255.0 blue: 131.0 / 255.0 alpha: 1.0 ]
                          , [ UIColor colorWithRed: 12.0 / 255.0 green: 54.0 / 255.0 blue: 97.0 / 255.0 alpha: 1.0 ]
                          , [ UIColor colorWithRed: 10.0 / 255.0 green: 32.0 / 255.0 blue: 57.0 / 255.0 alpha: 1.0 ]
                          , [ UIColor colorWithRed: 17.0 / 255.0 green: 17.0 / 255.0 blue: 17.0 / 255.0 alpha: 1.0 ]
                          , nil ];
   }
   return self;
}

+(id)bidControllerWithSymbolCellDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   PFLevel2QuotesViewController* controller_ = [ self new ];
   controller_.columns = [ NSArray arrayWithObjects: [ PFLevel2QuoteColumn bidColumnWithDelegate: delegate_ ]
                          , [ PFLevel2QuoteColumn bSizeColumn ]
                          , nil ];
   return controller_;
}

+(id)askControllerWithSymbolCellDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
{
   PFLevel2QuotesViewController* controller_ = [ self new ];
   controller_.columns = [ NSArray arrayWithObjects: [ PFLevel2QuoteColumn askColumnWithDelegate: delegate_ ]
                          , [ PFLevel2QuoteColumn aSizeColumn ]
                          , nil ];
   return controller_;
}

-(void)reloadColors
{
   NSMutableArray* background_colors_ = [ NSMutableArray arrayWithCapacity: [ self.elements count ] ];

   id< PFLevel2Quote > previous_quote_ = nil;
   NSUInteger level_index_ = 0;

   for ( id< PFLevel2Quote > quote_ in self.elements )
   {
      if ( previous_quote_ && quote_.price != previous_quote_.price && level_index_ + 1 < [ self.levelColors count ] )
      {
         ++level_index_;
      }
      [ background_colors_ addObject: [ self.levelColors objectAtIndex: level_index_ ] ];
      previous_quote_ = quote_;
   }

   self.backgroundColors = background_colors_;
}

-(void)reloadData
{
   [ self reloadColors ];

   [ super reloadData ];
}

-(BOOL)isPaginalGridView:( PFGridView* )grid_view_
{
   return YES;
}

-(CGFloat)widthOfFixedColumnInGridView:( PFGridView* )grid_view_
{
   return 0.f;
}

-(NSUInteger)gridView:( PFGridView* )grid_view_
numberOfColumnsInPageAtIndex:( NSUInteger )page_index_
{
   return [ self.columns count ];
}

-(UIView*)footerViewInGridView:( PFGridView* )grid_view_
{
   return nil;
}

-(CGFloat)heightOfFooterInGridView:( PFGridView* )grid_view_
{
   return 0.f;
}

-(UIView*)gridView:( PFGridView* )grid_view_
backgroundViewForRowAtIndex:( NSUInteger )row_index_
     columnAtIndex:( NSUInteger )column_index_
{
   UIView* background_view_ = [ UIView new ];
   background_view_.backgroundColor = [ self.backgroundColors objectAtIndex: row_index_ ];

   UIImageView* frame_view_ = column_index_ == 0
      ? [ [ UIImageView alloc ] initWithImage: [ UIImage  fixedCellBackgroundImage ] ]
      : [ [ UIImageView alloc ] initWithImage: [ UIImage  cellBackgroundImage ] ];

   [ background_view_ addSubviewAndScale: frame_view_ ];

   return background_view_;
}

@end
