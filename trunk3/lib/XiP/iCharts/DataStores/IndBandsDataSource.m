#import "IndBandsDataSource.h"

#import "PropertiesStore.h"
#import "ArrayMath.h"

@implementation IndBandsDataSource

@synthesize priceField;
@synthesize period;
@synthesize deviation;

- (id)initWithDataSource: (BaseDataStore*)base_data_
           AndProperties: (PropertiesStore*)properties_
                 AndPath: (NSString*)path_
{
   self = [ super initWithDataSource: base_data_ AndProperties: properties_ AndPath: path_ ];
   
   if( self )
   {
      self.priceField = [ properties_ getApplyToParam: [ NSString stringWithFormat: @"%@.bands.apply", path_ ] ];
      self.period = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.bands.interval", path_ ] ];
      self.deviation = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.bands.deviation", path_ ] ];
   }
   
   return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
   recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
   ArrayMath* src_data_arr_ = [ src GetVector: self.priceField ];
   ArrayMath* mov_mav_ = [ src_data_arr_ movAvg: recalc_period ];
   ArrayMath* mov_dev_ = [ [ src_data_arr_ movStdDev: recalc_period ] mul2: self.deviation ];
   
   [ self SetVector: mov_mav_ forKey: @"indData1" ];
   [ self SetVector: [ mov_mav_ add: mov_dev_ ] forKey: @"indData2" ];
   [ self SetVector: [ mov_mav_ sub: mov_dev_ ] forKey: @"indData3" ];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
   ArrayMath* src_data_ = [ src GetVector: self.priceField ];
   
   ArrayMath* ind_data1_ = [ self GetVector: @"indData1" ];
   ArrayMath* ind_data2_ = [ self GetVector: @"indData2" ];
   ArrayMath* ind_data3_ = [ self GetVector: @"indData3" ];
   
   int src_len_ = [ src_data_ getLength ];
   if( src_len_ > [ self GetLength ] )
   {
      while ( src_len_ > [ self GetLength ] )
      {
         int last_index_ = [ self GetLength ];
         
         [ ind_data1_ addElement: NAN ];
         [ ind_data2_ addElement: NAN ];
         [ ind_data3_ addElement: NAN ];
         
         [ self SourceDataProcedureWithLastIndex: last_index_ andSrcData: src_data_ andIndData1: ind_data1_ andIndData2: ind_data2_ andIndData3: ind_data3_ ];
      }
   }
   else
   {
      [ self SourceDataProcedureWithLastIndex: src_len_ andSrcData: src_data_ andIndData1: ind_data1_ andIndData2: ind_data2_ andIndData3: ind_data3_ ];
   }
}

-(void)SourceDataProcedureWithLastIndex: (int)last_index_
                             andSrcData: (ArrayMath*) scr_data_
                            andIndData1: (ArrayMath*)ind_data1_
                            andIndData2: (ArrayMath*)ind_data2_
                            andIndData3: (ArrayMath*)ind_data3_
{
   recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
   int i_start_ = last_index_ - recalc_period - 1;
   int i_len_ = recalc_period + 1;
   
   ArrayMath* src_data_trim_ = [ scr_data_ trim: i_start_ AndLength: i_len_ ];
   ArrayMath* mov_mav_ = [ src_data_trim_ movAvg: recalc_period ];
   ArrayMath* mov_dev_ = [ [ src_data_trim_ movStdDev: recalc_period ] mul2: self.deviation ];
   
   [ ind_data1_ getData ][ last_index_ - 1 ] = [ mov_mav_ getData ][ i_len_ - 1 ];
   [ ind_data2_ getData ][ last_index_ - 1 ] = [ [ mov_mav_ add: mov_dev_ ] getData ][ i_len_ - 1 ];
   [ ind_data3_ getData ][ last_index_ - 1 ] = [ [ mov_mav_ sub: mov_dev_ ] getData ][ i_len_ - 1 ];
}

@end
