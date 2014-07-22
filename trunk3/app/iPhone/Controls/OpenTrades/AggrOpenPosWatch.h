
#import <UIKit/UIKit.h>
#import "GridControler.h"

@class OpenPosWatch;

@interface AggrOpenPosWatch : NSObject
{
    NSMutableDictionary *dicOpen;
    NSMutableDictionary *dicPending;
    
    NSMutableArray *openOrderKeys;
    NSMutableArray *pendingOrderKeys;
}

@property (nonatomic, assign) GridViewController *gridCtl;
@property (nonatomic, assign) OpenPosWatch *parent;

@property (nonatomic, assign) NSMutableDictionary *dicOpen;
@property (nonatomic, assign) NSMutableDictionary *dicPending;

@property (nonatomic, assign) NSMutableArray *openOrderKeys;
@property (nonatomic, assign) NSMutableArray *pendingOrderKeys;

- (void)rebild:(BOOL)keepScroll;
- (BOOL)updateProfits:(BOOL)forceChanged;
- (void)updateSummaryData;

@end
