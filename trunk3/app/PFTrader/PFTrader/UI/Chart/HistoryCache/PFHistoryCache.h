#import <Foundation/Foundation.h>

@interface PFHistoryCache : NSObject

+(PFHistoryCache*)historyCache;

-(NSData*)datafromFileWithName: (NSString*)name_
                          hash: (NSString*)md5_hash_
                    fromServer: (NSString*)server_
                     forSymbol: (NSString*)symbol_
                          type: (int)type_;

-(void)saveFileWithName: (NSString*)name_
                   data: (NSData*)data_
                   hash: (NSString*)md5_hash_
             fromServer: (NSString*)server_
              forSymbol: (NSString*)symbol_
                   type: (int)type_;

-(void)openCache;
-(void)closeCache;

@end
