#import <UIKit/UIKit.h>

@class PFGridCell;

@protocol PFGridViewDelegate;
@protocol PFGridViewDataSource;

typedef void (^PFGridViewSelectedRowViewDoneBlock)( NSUInteger row_index_ );

@interface PFGridView : UIView

@property ( nonatomic, assign ) IBOutlet id< PFGridViewDelegate > delegate;
@property ( nonatomic, assign ) IBOutlet id< PFGridViewDataSource > dataSource;
@property ( nonatomic, copy ) PFGridViewSelectedRowViewDoneBlock selectedRowViewBlock;

@property ( nonatomic, assign ) NSUInteger activePage;

-(void)setActivePage:( NSUInteger )page_ animated:( BOOL )animated_;

-(void)reloadData;
-(void)updateRows;

-(PFGridCell*)dequeueCellWithIdentifier:( NSString* )identifier_;

@end
