#import <Foundation/Foundation.h>

@class PFGridCell;
@class PFGridView;

typedef PFGridCell* (^PFGridCellBuilder)( PFGridView* grid_view_, id context_ );
typedef UIView* (^PFGridHeaderViewBuilder)( PFGridView* grid_view_ );

@interface PFColumn : NSObject

@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, strong ) NSString* secondTitle;

@property ( nonatomic, copy ) PFGridCellBuilder cellBuilder;
@property ( nonatomic, copy ) PFGridHeaderViewBuilder headerBuilder;

-(PFGridCell*)cellForGridView:( PFGridView* )grid_view_
                      context:( id )context_;

-(UIView*)headerViewForGridView:( PFGridView* )grid_view_;

@end
