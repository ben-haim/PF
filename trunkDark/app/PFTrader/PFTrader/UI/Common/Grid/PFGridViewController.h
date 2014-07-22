#import "PFViewController.h"

@class PFGridView;
@class PFGridFooterView;

@interface PFGridViewController : PFViewController

@property ( nonatomic, strong ) NSArray* elements;
@property ( nonatomic, strong ) NSArray* columns;
@property ( nonatomic, strong ) NSArray* actions;
@property ( nonatomic, assign ) BOOL ignoreElementsCount;

@property ( nonatomic, strong, readonly ) PFGridFooterView* footerView;
@property ( nonatomic, strong, readonly ) PFGridView* gridView;

-(void)setSummaryButtonHidden:( BOOL )hidden_;
-(void)setSummaryString:( NSString* )summary_string_;

-(void)reloadData;
-(void)updateRows;

-(BOOL)isPaginal;

@end
