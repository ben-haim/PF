#import <UIKit/UIKit.h>

@class PFGridCell;

@protocol PFGridViewDelegate;
@protocol PFGridViewDataSource;

@interface PFGridView : UIView

@property ( nonatomic, assign ) IBOutlet id< PFGridViewDelegate > delegate;
@property ( nonatomic, assign ) IBOutlet id< PFGridViewDataSource > dataSource;

@property ( nonatomic, assign ) NSUInteger activePage;

-(void)setActivePage:( NSUInteger )page_ animated:( BOOL )animated_;

-(void)reloadData;
-(void)updateRows;

-(PFGridCell*)dequeueCellWithIdentifier:( NSString* )identifier_;

@end
