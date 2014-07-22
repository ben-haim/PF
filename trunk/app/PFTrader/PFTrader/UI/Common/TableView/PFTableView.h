#import <UIKit/UIKit.h>

@class PFTableViewCategory;

@interface PFTableView : UIView

@property ( nonatomic, strong ) IBOutlet UIView* tableHeaderView;
@property ( nonatomic, strong ) IBOutlet UIView* tableFooterView;

@property ( nonatomic, assign ) UIEdgeInsets contentInset;

@property ( nonatomic, strong ) NSArray* categories;

@property ( nonatomic, strong ) UIColor* backgroundColor;

@property ( nonatomic, assign, readonly ) CGSize contentSize;

-(void)scrollToSelectedRowAnimated:( BOOL )animated_;

-(void)reloadData;

-(void)reloadCategory:( PFTableViewCategory* )category_
     withRowAnimation:( UITableViewRowAnimation )animation_;

-(void)reloadCategory:( PFTableViewCategory* )category_
          reloadRange:( NSRange )reload_range_
          insertRange:( NSRange )insert_range_
          deleteRange:( NSRange )delete_range_
     withRowAnimation:( UITableViewRowAnimation )animation_;

@end
