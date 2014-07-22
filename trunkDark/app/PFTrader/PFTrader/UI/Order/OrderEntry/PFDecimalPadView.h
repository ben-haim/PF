#import <UIKit/UIKit.h>

typedef enum
{
   PFDecimalPadCodeBack = -1
   , PFDecimalPadCode0 = 0
   , PFDecimalPadCode1 = 1
   , PFDecimalPadCode2 = 2
   , PFDecimalPadCode3 = 3
   , PFDecimalPadCode4 = 4
   , PFDecimalPadCode5 = 5
   , PFDecimalPadCode6 = 6
   , PFDecimalPadCode7 = 7
   , PFDecimalPadCode8 = 8
   , PFDecimalPadCode9 = 9
   , PFDecimalPadCodePoint = 10
} PFDecimalPadCodeType;

@protocol PFDecimalPadViewDelegate

-(void)pressedButtonWithCode: (PFDecimalPadCodeType)code_;

@end

@interface PFDecimalPadView : UIView

+(id)createDecimalPadWithDelegate: (id<PFDecimalPadViewDelegate>)delegate_;

@end
