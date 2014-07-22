#import "PFGridViewController.h"

#import "PFColumn.h"

#import "PFGridView.h"
#import "PFGridViewDelegate.h"
#import "PFGridViewDataSource.h"

#import "PFGridFooterView.h"
#import "PFGridActionView.h"

#import "PFLayoutManager.h"

#import "UIImage+PFGridView.h"
#import "UIColor+PFGridView.h"

#import "UIView+AddSubviewAndScale.h"

static NSUInteger PFColumnsPerPage = 2;
static NSUInteger PFFixedColumnsCount = 1;

static CGFloat PFOverlayHeight = 30.f;
static CGFloat PFFixedColumnWidth = 160.f;

@interface PFGridViewController ()< PFGridViewDelegate, PFGridViewDataSource, PFGridFooterViewDelegate >

@property ( nonatomic, strong ) PFGridView* gridView;

@property ( nonatomic, strong ) PFGridFooterView* footerView;

@end

@implementation PFGridViewController

@synthesize gridView = _gridView;
@synthesize footerView = _footerView;

@synthesize elements = _elements;
@synthesize columns = _columns;
@synthesize actions;
@synthesize ignoreElementsCount;

-(void)dealloc
{
   self.gridView.dataSource = nil;
   self.gridView.delegate = nil;
   self.footerView.delegate = nil;
}

-(PFGridView*)gridView
{
   if ( !_gridView )
   {
      _gridView = [ [ PFGridView alloc ] initWithFrame: self.view.bounds ];
      _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      _gridView.dataSource = self;
      _gridView.delegate = self;
      [ self.view addSubview: _gridView ];//_gridView.backgroundColor = [ UIColor gridViewBackgroundColor ];
   }
   return _gridView;
}

-(UIColor*)overlayColor
{
   return [ UIColor gridViewOverlayColor ];
}

-(PFGridFooterView*)footerView
{
   if ( !_footerView )
   {
      _footerView = [ [ PFGridFooterView alloc ] initWithFrame: CGRectMake( 0.f, 0.f, self.view.bounds.size.width, PFOverlayHeight )  ];
      _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
      _footerView.delegate = self;
      _footerView.fixedWidth = PFFixedColumnWidth;
      _footerView.backgroundColor = self.overlayColor;
   }
   return _footerView;
}

-(void)setElements:( NSArray* )elements_
{
   if ( !self.ignoreElementsCount )
   {
      self.footerView.summaryTitle = [ NSString stringWithFormat: @"%d", (uint)[ elements_ count ] ];
   }
   
   _elements = elements_;
}

-(void)setSummaryString:( NSString* )summary_string_
{
   if ( self.ignoreElementsCount )
   {
      self.footerView.summaryTitle = summary_string_;
   }
}

-(void)setColumns:( NSArray* )columns_
{
   if ( [ columns_ count ] > PFFixedColumnsCount )
   {
      self.footerView.numberOfPages = ceil( ( [ columns_ count ] - PFFixedColumnsCount ) / PFColumnsPerPage );
      self.footerView.currentPage = 0;
   }
   else
   {
      self.footerView.numberOfPages = 0;
   }
   _columns = columns_;
}

-(void)reloadData
{
   [ self.gridView reloadData ];
}

-(void)updateRows
{
   [ self.gridView updateRows ];
}

-(BOOL)isPaginal
{
   return [ PFLayoutManager currentLayoutManager ].isPaginalGridView;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.gridView.backgroundColor = [ UIColor gridViewBackgroundColor ];
}

/*
-(void)viewWillAppear:(BOOL)animated_
{
   [ super viewWillAppear: animated_ ];

   [ self.view addSubviewAndScale: self.gridView ];
}

-(void)viewDidDisappear:( BOOL )animated_
{
   [ super viewDidDisappear: animated_ ];

   [ self.gridView removeFromSuperview ];
   self.gridView.dataSource = nil;
   self.gridView.delegate = nil;
   self.gridView = nil;

   [ self.footerView removeFromSuperview ];
   self.footerView.delegate = nil;
   self.footerView = nil;
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSummaryButtonHidden:( BOOL )hidden_
{
   [ self.footerView setSummaryButtonHidden: hidden_ ];
}

#pragma mark PFGridViewDataSource

-(BOOL)isPaginalGridView:( PFGridView* )grid_view_
{
   return [ self isPaginal ];
}

-(CGFloat)widthOfFixedColumnInGridView:( PFGridView* )grid_view_
{
   return PFFixedColumnWidth;
}

-(NSUInteger)gridView:( PFGridView* )grid_view_
numberOfColumnsInPageAtIndex:( NSUInteger )page_index_
{
   return PFColumnsPerPage;
}

-(NSUInteger)numberOfColumnsInGridView:( PFGridView* )grid_view_
{
   return [ self.columns count ];
}

-(NSUInteger)numberOfRowsInGridView:( PFGridView* )grid_view_
{
   return [ self.elements count ];
}

-(PFGridCell*)gridView:( PFGridView* )grid_view_
     cellForRowAtIndex:( NSUInteger )row_index_
         columnAtIndex:( NSUInteger )column_index_
{
   id element_ = [ self.elements objectAtIndex: row_index_ ];
   PFColumn* column_ = [ self.columns objectAtIndex: column_index_ ];
   
   return [ column_ cellForGridView: grid_view_ context: element_ ];
}

-(UIView*)gridView:( PFGridView* )grid_view_
headerViewForColumnAtIndex:( NSUInteger )column_index_
{
   PFColumn* column_ = [ self.columns objectAtIndex: column_index_ ];

   return [ column_ headerViewForGridView: grid_view_ ];
}

-(CGFloat)heightOfRowInGridView:( PFGridView* )grid_view_
{
   return 42.f;
}

-(UIColor*)backgroundColorForHeaderInGridView:( PFGridView* )grid_view_
{
   return self.overlayColor;
}

-(CGFloat)heightOfHeaderInGridView:( PFGridView* )grid_view_
{
   return PFOverlayHeight;
}

#pragma mak PFGridViewDelegate

-(void)gridView:( PFGridView* )grid_view_
didSelectPageAtIndex:( NSUInteger )page_index_
{
   self.footerView.currentPage = page_index_;
}

-(UIView*)footerViewInGridView:( PFGridView* )grid_view_
{
   [ self.footerView setPageControlHidden: ![ self isPaginal ] ];
   return self.footerView;
}

-(CGFloat)heightOfFooterInGridView:( PFGridView* )grid_view_
{
   return PFOverlayHeight;
}

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_
{
   //id element_ = [ self.elements objectAtIndex: row_index_ ];
}

#pragma mark PFGridFooterViewDelegate

-(void)footterView:( PFGridFooterView* )footer_view_
     didSelectPage:( NSUInteger )page_
{
   [ self.gridView setActivePage: page_ animated: YES ];
}

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_
{
}

-(UIView*)gridView:( PFGridView* )grid_view_
viewForSelectedRowAtIndex:( NSUInteger )row_index_
{
   if ( !self.actions )
      return nil;

   PFGridActionView* view_ = [ [ PFGridActionView alloc ] initWithActions: self.actions
                                                                      row: row_index_
                                                                fixedWith: PFFixedColumnWidth ];

   view_.backgroundColor = [ UIColor gridViewBackgroundColor ];

   return view_;
}

-(UIView*)columnsBackgroundViewInGridView:( PFGridView* )grid_view_
{
   UIView* background_view_ = [ UIView new ];
   background_view_.backgroundColor = [ UIColor gridViewColumnsBackgroundColor ];
   return background_view_;
}

-(UIView*)columnsOverlayViewInGridView:( PFGridView* )grid_view_
{
   return [ [ UIImageView alloc ] initWithImage: [ UIImage  columnsShadowImage ] ];
}

-(UIView*)gridView:( PFGridView* )grid_view_
backgroundViewForRowAtIndex:( NSUInteger )row_index_
     columnAtIndex:( NSUInteger )column_index_
{
   if ( column_index_ == 0 )
   {
      return [ [ UIImageView alloc ] initWithImage: [ UIImage  fixedCellBackgroundImage ] ];
   }
   return [ [ UIImageView alloc ] initWithImage: [ UIImage  cellBackgroundImage ] ];
}

@end
