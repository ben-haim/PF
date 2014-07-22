#import "PFAccountCell.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFAccountCell

@synthesize nameLabel;

-(void)setModel:( id< PFAccount > )account_
{
   self.nameLabel.text = account_.name;
}

@end
