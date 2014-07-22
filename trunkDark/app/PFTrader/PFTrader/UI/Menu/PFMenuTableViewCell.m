#import "PFMenuTableViewCell.h"
#import "PFMenuCell.h"
#import "UIView+LoadFromNib.h"

@interface PFMenuTableViewCell ()

@property ( nonatomic, strong ) UITableView* horizontalTable;

@end

@implementation PFMenuTableViewCell

@synthesize horizontalTable;
@synthesize menuItems = _menuItems;
@synthesize menuController;

-(id)initWithFrame:( CGRect) frame_ reuseIdentifier:( NSString* )reuse_identifier_
{
   self = [ super initWithStyle: UITableViewCellStyleDefault reuseIdentifier: reuse_identifier_ ];
   
   if ( self )
   {
      self.backgroundColor = [ UIColor clearColor ];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.frame = frame_;
      
      self.horizontalTable = [ [ UITableView alloc ] initWithFrame: frame_ ];
      self.horizontalTable.showsVerticalScrollIndicator = NO;
      self.horizontalTable.showsHorizontalScrollIndicator = NO;
      self.horizontalTable.transform = CGAffineTransformMakeRotation( -M_PI * 0.5 );
      self.horizontalTable.backgroundColor = [ UIColor clearColor ];
      self.horizontalTable.bounces = NO;
      self.horizontalTable.rowHeight = frame_.size.width / 3;
      self.horizontalTable.frame = frame_;
      self.horizontalTable.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.horizontalTable.dataSource = self;
      self.horizontalTable.delegate = self;
      
      [ self addSubview: self.horizontalTable ];
   }
   
   return self;
}

-(void)setMenuItems:( NSArray* )menu_items_
{
   _menuItems = menu_items_;
   [ self.horizontalTable reloadData ];
}

#pragma mark - UITableViewDelegate

-(void)tableView:( UITableView* )table_view_ didSelectRowAtIndexPath:(NSIndexPath* )index_path_
{
   
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return self.menuItems.count;
}

-(UITableViewCell*)tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFMenuCell";
   PFMenuCell* cell_ = [ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];
   
   if ( !cell_ )
   {
      cell_ = [ PFMenuCell cell ];
   }
   
   cell_.menuItem = (self.menuItems)[index_path_.row];
   cell_.menuController = self.menuController;
   
   return cell_;
}

@end
