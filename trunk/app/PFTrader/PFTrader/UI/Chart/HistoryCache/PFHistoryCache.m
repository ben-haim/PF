#import "PFHistoryCache.h"
#import "PFSettings.h"

#import <sqlite3.h>

static PFHistoryCache* history_cache_ = nil;
static sqlite3* database = nil;

@interface PFHistoryCache ()

@property ( nonatomic, assign ) double currentCacheSize;

@end

@implementation PFHistoryCache

@synthesize currentCacheSize;

-(NSString*)databasePath
{
   return [ [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ] stringByAppendingPathComponent: @"PFChartData.sqlite3" ];
}

+(PFHistoryCache*)historyCache
{
   if ( !history_cache_ )
   {
      history_cache_ = [ PFHistoryCache new ];
   }
   
   return history_cache_;
}

-(void)closeCache
{
   sqlite3_close(database);
}

-(void)createTableIfNeed
{
   NSString* create_sql_ = @"CREATE TABLE IF NOT EXISTS History(id INTEGER PRIMARY KEY AUTOINCREMENT, server TEXT, symbol TEXT, history_type INTEGER, raiting INTEGER, md5 TEXT, size REAL, name TEXT, data BLOB);";
   
   char* error_message_;
   
   if ( sqlite3_exec( database, [ create_sql_ UTF8String ], NULL, NULL, &error_message_) != SQLITE_OK )
   {
      [ self closeCache ];
      NSLog(@"ERROR creating database table: %s", error_message_ );
   }
}

-(double)calculateFilesSize
{
   double current_files_size_ = 0.0;
   NSString* query_sql_ = @"SELECT SUM(size) FROM History";
   
   sqlite3_stmt* statement_;
   if ( sqlite3_prepare_v2( database, [ query_sql_ UTF8String ], -1, &statement_, NULL) == SQLITE_OK )
   {
      while ( sqlite3_step(statement_) == SQLITE_ROW )
      {
         current_files_size_ = sqlite3_column_double(statement_, 0);
         break;
      }
   }
   sqlite3_finalize(statement_);
   
   return current_files_size_;
}

-(void)openCache
{
   if ( sqlite3_open([ [ self databasePath ] UTF8String ], &database) == SQLITE_OK )
   {
      [ self createTableIfNeed ];
      self.currentCacheSize = [ self calculateFilesSize ];
   }
   else
   {
      [ self closeCache ];
   }
}

-(void)raitingIncrementForFileWithId: (int)file_id_
                      WithOldRaiting: (int) old_raiting_
{
   NSString* update_sql = [ NSString stringWithFormat: @"UPDATE History SET raiting = %d WHERE id = %d"
                           , ( old_raiting_ < 1000 ? old_raiting_ + 1 : old_raiting_ )
                           , file_id_ ];
   
   sqlite3_stmt* statement_;
   if ( sqlite3_prepare_v2( database, [ update_sql UTF8String ], -1, &statement_, NULL) == SQLITE_OK )
   {
      if ( sqlite3_step(statement_) != SQLITE_DONE )
      {
         NSLog(@"ERROR updating database table");
      }
   }
   sqlite3_finalize(statement_);
}

-(NSData*)datafromFileWithName: (NSString*)name_
                          hash: (NSString*)md5_hash_
                    fromServer: (NSString*)server_
                     forSymbol: (NSString*)symbol_
                          type: (int)type_
{
   NSData* result_;
   int raitng_ = 1;
   int file_id_ = -1;
   
   NSString* query_sql_ = [ NSString stringWithFormat: @"SELECT data, raiting, id FROM History WHERE md5 = '%@' AND server = '%@' AND symbol = '%@' AND history_type = %d AND name = '%@'"
                           , md5_hash_
                           , server_
                           , symbol_
                           , type_
                           , name_ ];
   
   sqlite3_stmt* statement_;
   if ( sqlite3_prepare_v2( database, [ query_sql_ UTF8String ], -1, &statement_, NULL) == SQLITE_OK )
   {
      while ( sqlite3_step(statement_) == SQLITE_ROW )
      {
         result_ = [ [ NSData alloc ] initWithBytes: sqlite3_column_blob(statement_, 0) length: sqlite3_column_bytes(statement_, 0) ];
         raitng_ = sqlite3_column_int(statement_, 1);
         file_id_ = sqlite3_column_int(statement_, 2);
         break;
      }
   }
   sqlite3_finalize(statement_);
   
   if ( result_ )
   {
      [ self raitingIncrementForFileWithId: file_id_ WithOldRaiting: raitng_ ];
   }
   
   return result_;
}

-(void)updateCacheSizeWithSize: (double)size_
{
   double current_files_size_ = 0.0;
   double max_size_ = MAX(size_, 5 * 1024.0);
   NSMutableArray* remove_ids_ = [ NSMutableArray new ];
   
   NSString* query_sql_ = @"SELECT id, size, raiting FROM History ORDER BY raiting";
   
   sqlite3_stmt* statement_;
   if ( sqlite3_prepare_v2( database, [ query_sql_ UTF8String ], -1, &statement_, NULL) == SQLITE_OK )
   {
      while ( sqlite3_step(statement_) == SQLITE_ROW )
      {
         [ remove_ids_ addObject: [ NSString stringWithFormat: @"%d", sqlite3_column_int(statement_, 0) ] ];
         
         current_files_size_ += sqlite3_column_double(statement_, 1);
         if ( current_files_size_ >= max_size_ )
            break;
      }
   }
   sqlite3_finalize(statement_);
   
   if ( [ remove_ids_ count ] > 0 )
   {
      NSString* remove_sql_ = [ NSString stringWithFormat: @"DELETE FROM History WHERE id IN (%@)", [ remove_ids_ componentsJoinedByString: @", " ] ];
      
      sqlite3_stmt* statement_;
      if ( sqlite3_prepare_v2( database, [ remove_sql_ UTF8String ], -1, &statement_, nil) == SQLITE_OK )
      {
         if ( sqlite3_step(statement_) != SQLITE_DONE )
         {
            NSLog(@"ERROR inserting database table");
         }
      }
      sqlite3_finalize(statement_);
      
      self.currentCacheSize = [ self calculateFilesSize ];
   }
}

-(void)addToCacheSize: (double)size_
{
   if ( ( [ PFSettings sharedSettings ].chartCacheMaxSize * 1024.0 ) > self.currentCacheSize + size_ )
   {
      self.currentCacheSize += size_;
   }
   else
   {
      [ self updateCacheSizeWithSize: size_ ];
   }
}

-(void)saveFileWithName: (NSString*)name_
                   data: (NSData*)data_
                   hash: (NSString*)md5_hash_
             fromServer: (NSString*)server_
              forSymbol: (NSString*)symbol_
                   type: (int)type_
{
   double file_size_ = [ data_ length ] / 1024.0;
   [ self addToCacheSize: file_size_ ];
   
   NSString* update_sql_ = @"INSERT OR REPLACE INTO History (server, symbol, history_type, raiting, md5, size, name, data) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
   
   sqlite3_stmt* statement_;
   if ( sqlite3_prepare_v2( database, [ update_sql_ UTF8String ], -1, &statement_, nil) == SQLITE_OK )
   {
      sqlite3_bind_text(statement_, 1, [ server_ UTF8String ], -1, SQLITE_TRANSIENT);
      sqlite3_bind_text(statement_, 2, [ symbol_ UTF8String ], -1, SQLITE_TRANSIENT);
      sqlite3_bind_int(statement_, 3, type_);
      sqlite3_bind_int(statement_, 4, 1);
      sqlite3_bind_text(statement_, 5, [ md5_hash_ UTF8String ], -1, SQLITE_TRANSIENT);
      sqlite3_bind_double(statement_, 6, file_size_ );
      sqlite3_bind_text(statement_, 7, [ name_ UTF8String ], -1, SQLITE_TRANSIENT);
      sqlite3_bind_blob(statement_, 8, [ data_ bytes ], (int)[ data_ length ], SQLITE_TRANSIENT );
      
   }
   if ( sqlite3_step(statement_) != SQLITE_DONE )
   {
      NSLog(@"ERROR inserting database table");
   }
   sqlite3_finalize(statement_);
}

@end
