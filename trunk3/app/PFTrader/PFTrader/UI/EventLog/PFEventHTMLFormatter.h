#import <Foundation/Foundation.h>

@protocol PFReportTable;

@interface PFEventHTMLFormatter : NSObject

-(NSString*)toHTMLReport:( id< PFReportTable > )report_;

@end
