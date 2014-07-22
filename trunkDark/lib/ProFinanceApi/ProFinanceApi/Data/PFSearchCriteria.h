#import "../PFTypes.h"

#import "PFReportTableType.h"

#import <Foundation/Foundation.h>

@protocol PFSearchCriteria <NSObject>

-(NSDate*)fromDate;
-(NSDate*)toDateLocal;

-(NSDate*)fromDateLocal;
-(NSDate*)toDate;

-(NSString*)login;
-(PFInteger)userId;

-(PFReportTableType)reportType;
-(PFInteger)tableType;

-(PFBool)showLots;

-(NSString*)reportName;

-(NSDictionary*)keysAndValues;

@end

@protocol PFMutableSearchCriteria <PFSearchCriteria>

-(void)setToDate:( NSDate* )date_;
-(void)setFromDate:( NSDate* )date_;
-(void)setTableType:( PFReportTableType )type_;

@end

@interface PFSearchCriteria : NSObject< PFMutableSearchCriteria >

@property ( nonatomic, assign ) PFReportTableType tableType;

@property ( nonatomic, strong ) NSDate* fromDate;
@property ( nonatomic, strong ) NSDate* toDate;

@property ( nonatomic, strong ) NSDate* fromDateLocal;
@property ( nonatomic, strong ) NSDate* toDateLocal;


@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, assign ) PFInteger userId;

@property ( nonatomic, assign ) PFInteger reportType;

@property ( nonatomic, assign ) PFBool showLots;

@property ( nonatomic, strong, readonly ) NSDictionary* keysAndValues;

-(id)initWithServerOffset:( PFInteger )server_offset_;

@end
