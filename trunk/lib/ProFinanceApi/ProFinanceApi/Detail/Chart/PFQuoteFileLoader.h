#import <Foundation/Foundation.h>

@protocol PFQuoteFileLoaderDelegate;

@class PFQuoteFile;
@class PFServerInfo;

@interface PFQuoteFileLoader : NSObject

@property ( nonatomic, strong, readonly ) PFQuoteFile* file;

+(id)loaderWithFile:( PFQuoteFile* )file_
           delegate:( id< PFQuoteFileLoaderDelegate > )delegate_;

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_;
-(void)loadData:( NSData* )data_;
-(void)disconnect;

@end

@protocol PFQuoteFileLoaderDelegate <NSObject>

-(void)loader:( PFQuoteFileLoader* )loader_
didLoadQuotes:( NSArray* )quotes_;

-(void)loader:( PFQuoteFileLoader* )loader_
didLoadQuotes:( NSArray* )quotes_
     needSave:( BOOL )need_save_;

-(void)loader:( PFQuoteFileLoader* )loader_
didFailWithError:( NSError* )error_;

@end
