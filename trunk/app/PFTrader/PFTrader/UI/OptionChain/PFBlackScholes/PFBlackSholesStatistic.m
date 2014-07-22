#import "PFBlackSholesStatistic.h"

@implementation PFBlackSholesStatistic

+(double) MeanWithArray: (NSArray*)dataRow
{
   double sum = 0.0;
   for (int i = 0; i < dataRow.count; i++)
   {
      sum += [ [ dataRow objectAtIndex: i ] doubleValue ];
   }

   return sum / dataRow.count;
}

+(double) DevWithArray: (NSArray*)dataRow
{
   double meanDataRow = [ PFBlackSholesStatistic MeanWithArray: dataRow ];
   double sum = 0.0;
   
   for (int i = 0; i < dataRow.count; i++)
   {
      double current_value_ = [ [ dataRow objectAtIndex: i ] doubleValue ];
      sum += pow(current_value_ - meanDataRow, 2.0);
   }

   return sqrt(sum / dataRow.count);
}

+(double) CovWithArrayX: (NSArray*)dataRowX AndArrayY: (NSArray*)dataRowY
{
   double meanDataRowX = [ PFBlackSholesStatistic MeanWithArray: dataRowX ];
   double meanDataRowY = [ PFBlackSholesStatistic MeanWithArray: dataRowY ];
   double sum = 0.0;
   
   //Если разной длины, то посчитаем наименьшой длины, но не совсем корректно
   int count_ = (dataRowX.count - dataRowY.count <= 0) ? (int)dataRowX.count : (int)dataRowY.count;
   
   for (int i = 0; i < count_; i++)
   {
      sum += ( [ [ dataRowX objectAtIndex: i ] doubleValue ] - meanDataRowX ) * ( [ [ dataRowY objectAtIndex: i ] doubleValue ] - meanDataRowY );
   }

   return sum / count_;
}

+(double) CorrWithArrayX: (NSArray*)dataRowX AndArrayY: (NSArray*)dataRowY
{
   return [ PFBlackSholesStatistic CovWithArrayX: dataRowX AndArrayY: dataRowY ]
   / sqrt( [ PFBlackSholesStatistic DevWithArray: dataRowX ] * [ PFBlackSholesStatistic DevWithArray: dataRowY ] );
}

+(double) ACorrWithArrayX: (NSArray*)dataRowX AndLag: (int)lag
{
   double sumUp = 0.0;//Сумма числителя
   double sumDown = 0.0;//Сумма знаменателя
   double meanX = [ PFBlackSholesStatistic MeanWithArray: dataRowX ];//Математическое ожидание ряда
   
   for (int i = lag; i < dataRowX.count; i++)
   {
      sumUp += ( [ [ dataRowX objectAtIndex: i ] doubleValue ] - meanX ) * ( [ [ dataRowX objectAtIndex: i - lag ] doubleValue ] - meanX );
   }
      
   
   for (int i = 0; i < dataRowX.count; i++)
   {
      double current_value_ = [ [ dataRowX objectAtIndex: i ] doubleValue ];
      sumDown += ( current_value_ - meanX ) * ( current_value_ - meanX );
   }
   
   return ( sumUp / sumDown );
}

+(double) NormalDistributionWithX: (double)x AndMean: (double)mean AndDeviation: (double)deviation
{
   return exp(-(pow((x - mean) / deviation, 2) / 2)) / (deviation * sqrt(2 * M_PI));
}

+(double) N: (double)X
{
   const double a1 = 0.31938153;
   const double a2 = -0.356563782;
   const double a3 = 1.781477937;
   const double a4 = -1.821255978;
   const double a5 = 1.330274429;
   
   double L = fabs(X);
   double K = 1.0 / (1.0 + 0.2316419 * L);
   double W = 1.0 - 1.0 / sqrt(2 * M_PI) * exp(-L * L / 2.0) * (a1 * K + a2 * K * K + a3 * pow(K, 3.0) + a4 * pow(K, 4.0) + a5 * pow(K, 5.0));
   if (X < 0) W = 1.0 - W;
   
   return W;
}

@end
