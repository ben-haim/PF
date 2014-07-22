#import <Foundation/Foundation.h>

@interface PFBlackSholesStatistic : NSObject

/*
 Вычисление математического ожидания (среднее значение числового ряда)
 
 "dataRow"- Числовая последовательность
 return - Математическое ожмдание
 */
+(double) MeanWithArray: (NSArray*)dataRow;

/*
 Вычисление дисперсии (отклонение от среднего значения числового ряда)(Deviation)
 
 "dataRow" - Числовая последовательность
 return - Корень из дисперсии
 */
+(double) DevWithArray: (NSArray*)dataRow;

/*
 Вычисление коварияцию между числовыми рядами (Covariance)
 
 "dataRowX" - Первая числовая последовательность
 "dataRowY" - Вторая числовая последовательность
 
 return - Ковариацию между рядами
 */
+(double) CovWithArrayX: (NSArray*)dataRowX AndArrayY: (NSArray*)dataRowY;

/*
 Вычисление корреляцию между числовыми рядами (Correlation)
 
 "dataRowX" - Первая числовая последовательность
 "dataRowY" - Вторая числовая последовательность
 
 return - Корреляцию между рядами. Число из диапазона [-1;1]
 */
+(double) CorrWithArrayX: (NSArray*)dataRowX AndArrayY: (NSArray*)dataRowY;

/*
 Автокорреляция(Autocorrelation)
 
 "dataRowX" - Числовая последовательность
 "lag" - Отставание или задержка с которой осуществляем поиск корреляции по числовому ряду
 */
+(double) ACorrWithArrayX: (NSArray*)dataRowX AndLag: (int)lag;

/*
 Нормальное распределение или распределение Гаусса
 
 "x" - непрерывная случайная величина
 "mean" - Математическое ожидание
 "deviation" - среднеквадратичное отклонение
 */
+(double) NormalDistributionWithX: (double)x AndMean: (double)mean AndDeviation: (double)deviation;

/*
 Функция нормального распределения
 
 "X" - величина от которой расчитывают распределение (d1 и d2)
 return - вероятность того, что будет выигрых или будет исполнен
 */
+(double) N: (double)X;

@end
