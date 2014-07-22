#ifndef ProFinanceApi_PFDoneBlockDefs_h
#define ProFinanceApi_PFDoneBlockDefs_h

typedef void (^PFHistoryDoneBlock)( NSArray* quotes_, NSError* error_ );

@protocol PFReportTable;

typedef void (^PFReportDoneBlock)( id< PFReportTable > report_, NSError* error_ );

@protocol PFQuoteFilesReader;

typedef void (^PFChartFilesDoneBlock)( id< PFQuoteFilesReader > file_reader_ );

typedef void (^PFReplaceOrderDoneBlock)();

#endif
