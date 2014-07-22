#import <UIKit/UIKit.h>

@class PFTableViewCategory;
@class PFTableViewItem;

@interface PFTableView : UIView

@property ( nonatomic, strong ) IBOutlet UIView* tableHeaderView;
@property ( nonatomic, strong ) IBOutlet UIView* tableFooterView;

@property ( nonatomic, strong ) UIColor* backgroundColor;
@property ( nonatomic, strong ) NSArray* categories;
@property ( nonatomic, strong, readonly ) UITableView* tableView;
@property ( nonatomic, assign, readonly ) CGSize contentSize;
@property ( nonatomic, assign ) UIEdgeInsets contentInset;
@property ( nonatomic, assign ) BOOL skipCellsBackground;

-(void)scrollToSelectedRowAnimated:( BOOL )animated_;

-(void)reloadData;

-(void)reloadCategory:( PFTableViewCategory* )category_
     withRowAnimation:( UITableViewRowAnimation )animation_;

-(void)reloadCategory:( PFTableViewCategory* )category_
          reloadRange:( NSRange )reload_range_
          insertRange:( NSRange )insert_range_
          deleteRange:( NSRange )delete_range_
     withRowAnimation:( UITableViewRowAnimation )animation_;

-(PFTableViewItem*)itemAtIndexPath:( NSIndexPath* )index_path_;

-(void)tableView:( UITableView* )table_view_
didSelectRowAtIndexPath:( NSIndexPath* )index_path_;

@end
