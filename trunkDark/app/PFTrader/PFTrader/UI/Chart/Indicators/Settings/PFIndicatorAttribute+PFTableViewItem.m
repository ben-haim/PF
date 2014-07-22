#import "PFIndicatorAttribute+PFTableViewItem.h"

#import "PFTableViewItem.h"
#import "PFTableViewIntervalItem.h"
#import "PFTableViewColorItem.h"
#import "PFTableViewDashItem.h"
#import "PFTableViewApplyItem.h"
#import "PFTableViewSwitchItem.h"
#import "PFTableViewDoubleItem.h"
#import "PFTableViewWidthItem.h"

@implementation PFIndicatorAttribute (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ PFTableViewItem itemWithAction: nil title: self.title ];
}

@end

@implementation PFIndicatorAttributeInterval (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ [ PFTableViewIntervalItem alloc ] initWithInterval: self ];
}

@end

@implementation PFIndicatorAttributeColor (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ [ PFTableViewColorItem alloc ] initWithColor: self ];
}

@end

@implementation PFIndicatorAttributeDash (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ [ PFTableViewDashItem alloc ] initWithDash: self ];
}

@end

@implementation PFIndicatorAttributeApply (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ [ PFTableViewApplyItem alloc ] initWithApply: self ];
}

@end

@implementation PFIndicatorAttributeBool (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ PFTableViewSwitchItem switchItemWithTitle: self.title
                                                 isOn: self.value
                                         switchAction: ^( PFTableViewSwitchItem* switch_item_ )
           {
              self.value = switch_item_.on;
           } ];
}

@end

@implementation PFIndicatorAttributeDouble (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ [ PFTableViewDoubleItem alloc ] initWithDouble: self ];
}

@end

@implementation PFIndicatorAttributeWidth (PFTableViewItem)

-(PFTableViewItem*)tableViewItem
{
   return [ [ PFTableViewWidthItem alloc ] initWithWidth: self ];
}

@end
