#import "PFConcreteColumn.h"

#import "PFConcreteGridCell.h"
#import "PFGridHeaderView.h"

#import "PFGridView.h"

@interface PFConcreteColumn ()

@end

@implementation PFConcreteColumn

+(id)columnWithTitle:( NSString* )title_
         secondTitle:( NSString* )second_title_
           cellClass:( Class )cell_class_
       doneCellBlock:( PFDoneCellBlock )done_cell_block_
       headerBuilder:( PFGridHeaderViewBuilder )header_builder_
{
   PFConcreteColumn* column_ = [ self new ];
   column_.title = title_;
   column_.secondTitle = second_title_;

   column_.cellBuilder = ^( PFGridView* grid_view_, id context_ )
   {
      PFConcreteGridCell* cell_ = ( PFConcreteGridCell* )[ grid_view_ dequeueCellWithIdentifier: [ cell_class_ reuseIdentifier ] ];
      if ( !cell_ )
      {
         cell_ = [ cell_class_ cell ];
      }
      [ context_ assignToCell: cell_ ];

      if ( done_cell_block_ )
      {
         done_cell_block_( cell_, context_ );
      }

      return cell_;
   };

   column_.headerBuilder = header_builder_;

   return column_;
}


+(id)columnWithTitle:( NSString* )title_
           cellClass:( Class )cell_class_
       doneCellBlock:( PFDoneCellBlock )done_block_
{
   PFGridHeaderViewBuilder header_builder_ = ^( PFGridView* grid_view_ )
   {
      PFGridHeaderView* header_view_ = [ PFGridHeaderView headerView ];
      header_view_.titleLabel.text = title_;
      return header_view_;
   };

   return [ self columnWithTitle: title_
                     secondTitle: nil
                       cellClass: cell_class_
                   doneCellBlock: done_block_
                   headerBuilder: header_builder_ ];
}

+(id)columnWithTitle:( NSString* )title_
         secondTitle:( NSString* )second_title_
           cellClass:( Class )cell_class_
       doneCellBlock:( PFDoneCellBlock )done_block_
{
   PFGridHeaderViewBuilder header_builder_ = ^( PFGridView* grid_view_ )
   {
      PFDetailGridHeaderView* header_view_ = [ PFDetailGridHeaderView headerView ];
      header_view_.titleLabel.text = title_;
      header_view_.secondTitleLabel.text = second_title_;
      return header_view_;
   };

   return [ self columnWithTitle: title_
                     secondTitle: second_title_
                       cellClass: cell_class_
                   doneCellBlock: done_block_
                   headerBuilder: header_builder_ ];
}

+(id)columnWithTitle:( NSString* )title_
           cellClass:( Class )class_
{
   return [ self columnWithTitle: title_
                       cellClass: class_
                   doneCellBlock: nil ];
}

+(id)columnWithTitle:( NSString* )title_
         secondTitle:( NSString* )bottom_title_
           cellClass:( Class )class_
{
   return [ self columnWithTitle: title_
                     secondTitle: bottom_title_
                       cellClass: class_
                   doneCellBlock: nil ];
}

@end
