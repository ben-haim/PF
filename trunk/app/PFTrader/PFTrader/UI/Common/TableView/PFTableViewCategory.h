#import <UIKit/UIKit.h>

@interface PFTableViewCategory : NSObject

@property ( nonatomic, strong ) NSArray* items;
@property ( nonatomic, assign, readonly ) BOOL plain;

+(id)categoryWithTitle:( NSString* )title_
                 items:( NSArray* )items_
                 plain:( BOOL )plain_
    hasFooterSeparator:( BOOL )footer_separator_;

+(id)categoryWithTitle:( NSString* )title_
                 items:( NSArray* )items_;

+(id)categoryWithTitle:( NSString* )title_;

-(UIView*)headerViewForTableView:( UITableView* )table_view_;
-(UIView*)footerViewForTableView:( UITableView* )table_view_;

-(CGFloat)headerHeightForTableView:( UITableView* )table_view_;
-(CGFloat)footerHeightForTableView:( UITableView* )table_view_;

-(void)performApplierForObject:( id )object_;

@end
