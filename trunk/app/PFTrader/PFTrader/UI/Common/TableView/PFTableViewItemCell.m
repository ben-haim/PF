#import "PFTableViewItemCell.h"

#import "PFTableViewItem.h"

@interface PFTableViewItemCell ()

@property ( nonatomic, strong ) PFTableViewItem* currentItem;

@end

@implementation PFTableViewItemCell

@synthesize itemContentView = _itemContentView;
@synthesize nameLabel;

@synthesize currentItem;

-(void)setItemContentView:( UIView* )view_
{
   [ _itemContentView removeFromSuperview ];

   view_.frame = self.contentView.bounds;
   view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ self.contentView addSubview: view_ ];

   _itemContentView = view_;
}

-(Class)expectedItemClass
{
   return [ PFTableViewItem class ];
}

-(PFTableViewItem*)item
{
   return self.currentItem;
}

-(void)performAction
{
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
}

-(void)setItem:( PFTableViewItem* )item_
{
   NSAssert( [ item_ isKindOfClass: self.expectedItemClass ], @"incorrect item type" );

   self.currentItem = item_;

   self.nameLabel.text = item_.title;
   [ self reloadDataWithItem: item_ ];
}

@end
