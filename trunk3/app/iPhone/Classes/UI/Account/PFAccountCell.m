#import "PFAccountCell.h"

#import "UIView+LoadFromNib.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFAccountCell

@synthesize nameLabel = _nameLabel;

-(void)dealloc
{
   [ _nameLabel release ];

   [ super dealloc ];
}

+(id)accountCell
{
   return [ self viewAsFirstObjectFromNibNamed: NSStringFromClass( self ) ];
}

-(void)setModel:( id< PFAccount > )account_
{
   self.nameLabel.text = account_.name;
}

@end
