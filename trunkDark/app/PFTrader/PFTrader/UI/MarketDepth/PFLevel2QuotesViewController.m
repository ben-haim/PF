#import "PFLevel2QuotesViewController.h"

#import "PFLevel2QuoteColumn.h"

#import "UIView+AddSubviewAndScale.h"
#import "UIImage+PFGridView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFLevel2QuotesViewController ()

@property ( nonatomic, strong ) NSArray* askLevelColors;
@property ( nonatomic, strong ) NSArray* bidLevelColors;
@property ( nonatomic, strong ) NSArray* backgroundColors;

@end

@implementation PFLevel2QuotesViewController

@synthesize askLevelColors;
@synthesize bidLevelColors;
@synthesize backgroundColors;

-(id)init
{
   self = [ super init ];
   
   if ( self )
   {
      self.askLevelColors = [ [ NSArray alloc ] initWithObjects:
                             [ UIColor colorWithRed: 192.f / 255.f green: 72.f / 255.f blue: 72.f / 255.f alpha: 1.f ]
                             , [ UIColor colorWithRed: 192.f / 255.f green: 72.f / 255.f blue: 72.f / 255.f alpha: 0.75f ]
                             , [ UIColor colorWithRed: 192.f / 255.f green: 72.f / 255.f blue: 72.f / 255.f alpha: 0.6f ]
                             , [ UIColor colorWithRed: 192.f / 255.f green: 72.f / 255.f blue: 72.f / 255.f alpha: 0.45f ]
                             , [ UIColor colorWithRed: 192.f / 255.f green: 72.f / 255.f blue: 72.f / 255.f alpha: 0.3f ]
                             , [ UIColor colorWithRed: 192.f / 255.f green: 72.f / 255.f blue: 72.f / 255.f alpha: 0.15f ]
                             , nil ];
      
      self.bidLevelColors = [ [ NSArray alloc ] initWithObjects:
                             [ UIColor colorWithRed: 17.f / 255.f green: 135.f / 255.f blue: 226.f / 255.f alpha: 1.f ]
                             , [ UIColor colorWithRed: 17.f / 255.f green: 135.f / 255.f blue: 226.f / 255.f alpha: 0.75f ]
                             , [ UIColor colorWithRed: 17.f / 255.f green: 135.f / 255.f blue: 226.f / 255.f alpha: 0.6f ]
                             , [ UIColor colorWithRed: 17.f / 255.f green: 135.f / 255.f blue: 226.f / 255.f alpha: 0.45f ]
                             , [ UIColor colorWithRed: 17.f / 255.f green: 135.f / 255.f blue: 226.f / 255.f alpha: 0.3f ]
                             , [ UIColor colorWithRed: 17.f / 255.f green: 135.f / 255.f blue: 226.f / 255.f alpha: 0.15f ]
                             , nil ];
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
}

+(id)depthControllerWithSymbolCellDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
                                    symbol:( id< PFSymbol > )symbol_
{
   PFLevel2QuotesViewController* controller_ = [ self new ];
   
   controller_.columns = [ NSArray arrayWithObjects: [ PFLevel2QuoteColumn level2PriceColumnWithDelegate: delegate_ ]
                          , [ PFLevel2QuoteColumn level2SizeColumn ]
                          , [ PFLevel2QuoteColumn level2CCYSizeColumnWithSymbolName: symbol_.instrument.exp2 ]
                          , nil ];
   
   return controller_;
}

-(void)reloadColors
{
   NSMutableArray* background_colors_ = [ NSMutableArray arrayWithCapacity: [ self.elements count ] ];
   NSMutableArray* asks_ = [ NSMutableArray new ];
   NSMutableArray* bids_ = [ NSMutableArray new ];
   
   for ( id< PFLevel2Quote > quote_ in self.elements )
   {
      if ( quote_.side == PFLevel2QuoteSideAsk )
      {
         [ asks_ addObject: quote_ ];
      }
      else
      {
         [ bids_ addObject: quote_ ];
      }
   }
   
   [ asks_ sortUsingComparator: ^NSComparisonResult( id< PFLevel2Quote > obj1, id< PFLevel2Quote > obj2 )
    {
       return obj1.size == obj2.size ? NSOrderedSame : ( obj1.size > obj2.size ? NSOrderedAscending : NSOrderedDescending );
    } ];
   
   [ bids_ sortUsingComparator: ^NSComparisonResult( id< PFLevel2Quote > obj1, id< PFLevel2Quote > obj2 )
    {
       return obj1.size == obj2.size ? NSOrderedSame : ( obj1.size > obj2.size ? NSOrderedAscending : NSOrderedDescending );
    } ];

   for ( id< PFLevel2Quote > quote_ in self.elements )
   {
      if ( quote_.side == PFLevel2QuoteSideAsk )
      {
         NSUInteger index_ = [ asks_ indexOfObject: quote_ ];

         if ( index_ >= self.askLevelColors.count )
         {
            index_ = self.askLevelColors.count - 1;
         }
         
         [ background_colors_ addObject: [ self.askLevelColors objectAtIndex: index_ ] ];
      }
      else
      {
         NSUInteger index_ = [ bids_ indexOfObject: quote_ ];
         
         if ( index_ >= self.bidLevelColors.count )
         {
            index_ = self.bidLevelColors.count - 1;
         }
         
         [ background_colors_ addObject: [ self.bidLevelColors objectAtIndex: index_ ] ];
      }
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
   UIImageView* background_view_ = [ [ UIImageView alloc ] initWithImage: [ UIImage  transparentCellBackgroundImage ] ];
   background_view_.backgroundColor = [ self.backgroundColors objectAtIndex: row_index_ ];

   return background_view_;
}

@end
