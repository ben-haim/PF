#import <UIKit/UIKit.h>

@class PFTableViewItem;

typedef void (^PFTableViewItemAction)( PFTableViewItem* item_ );
typedef void (^PFTableViewItemApplier)( PFTableViewItem* item_, id object_ );

@class PFTableViewCategory;
@class PFTableViewItemCell;

@interface PFTableViewItem : NSObject

@property ( nonatomic, weak ) PFTableViewCategory* category;
@property ( nonatomic, weak, readonly ) PFTableViewItemCell* cell;

@property ( nonatomic, assign ) UITableViewCellAccessoryType accessoryType;

@property ( nonatomic, strong ) NSString* title;

@property ( nonatomic, copy ) PFTableViewItemAction action;
@property ( nonatomic, copy ) PFTableViewItemApplier applier;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_;

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_;

-(UITableViewCell*)cellForTableView:( UITableView* )table_view_;
-(CGFloat)cellHeightForTableView:( UITableView* )table_view_;

-(void)performApplierForObject:( id )object_;
-(void)performAction;

@end
