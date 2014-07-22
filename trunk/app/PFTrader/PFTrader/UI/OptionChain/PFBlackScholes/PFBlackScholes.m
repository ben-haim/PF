#import "PFBlackScholes.h"
#import "PFBlackSholesStatistic.h"

static const double dayInYear = 365;              //Количество дней в году (расчет временного распада)
static const double timeDif = 1.0 / dayInYear;    //Коэффициент дней в году
static const double vegaDif = 0.01;               //Коэффициент веги
static const double gammaDif = 0.1;               //Коэффициент Гаммы

static const double PFRiskFree = 0.0;
static const double PFDeviation = 0.18;

@implementation PFBlackScholes

#pragma mark - d1 (Расчет величины d1 из формулы Блэка Шолза)

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend
{
   return (log(baseActive / strike) + (riskFree - dividend + deviation * deviation / (2.0)) * timeToExp) / (deviation * sqrt(timeToExp));
}

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes d1WithBaseActive: baseActive
                                     Strike: strike
                           TimeToExpiration: timeToExp
                                   RiskFree: riskFree
                                  Deviation: deviation
                                   Dividend: dividend ];
}

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
{
   return [ PFBlackScholes d1WithBaseActive: baseActive
                                     Strike: strike
                           TimeToExpiration: timeToExp
                                   RiskFree: riskFree
                                  Deviation: deviation
                                   Dividend: 0.0 ];
}

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
{
   return [ PFBlackScholes d1WithBaseActive: baseActive
                                     Strike: strike
                            DayToExpiration: dayToExp
                                   RiskFree: riskFree
                                  Deviation: deviation ];
}

#pragma mark - d2 (Расчет величины d2 из формулы Блэка Шолза)

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend
{
   return [ PFBlackScholes d1WithBaseActive: baseActive
                                     Strike: strike
                           TimeToExpiration: timeToExp
                                   RiskFree: riskFree
                                  Deviation: deviation
                                   Dividend: dividend ] - ( deviation * sqrt(timeToExp) );
}

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes d2WithBaseActive: baseActive
                                     Strike: strike
                           TimeToExpiration: timeToExp
                                   RiskFree: riskFree
                                  Deviation: deviation
                                   Dividend: dividend ];
}

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
{
   return [ PFBlackScholes d2WithBaseActive: baseActive
                                     Strike: strike
                           TimeToExpiration: timeToExp
                                   RiskFree: riskFree
                                  Deviation: deviation
                                   Dividend: 0.0 ];
}

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
{
   return [ PFBlackScholes d2WithBaseActive: baseActive
                                     Strike: strike
                            DayToExpiration: dayToExp
                                   RiskFree: riskFree
                                  Deviation: deviation ];
}


#pragma mark - BS_CALL (Расчет премии по опциону Call)

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
               TimeToExpiration: (double)timeToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation
                       Dividend: (double)dividend
{
   double expRate = exp(-riskFree * timeToExp);
   double expDiv = exp(-dividend * timeToExp);
   
   return baseActive  * expDiv * [ PFBlackSholesStatistic N: [ PFBlackScholes d1WithBaseActive: baseActive
                                                                                        Strike: strike
                                                                              TimeToExpiration: timeToExp
                                                                                      RiskFree: riskFree
                                                                                     Deviation: deviation
                                                                                      Dividend: dividend ] ]
   - strike * expRate * [ PFBlackSholesStatistic N: [ PFBlackScholes d2WithBaseActive: baseActive
                                                                               Strike: strike
                                                                     TimeToExpiration: timeToExp
                                                                             RiskFree: riskFree
                                                                            Deviation: deviation
                                                                             Dividend: dividend ] ];
}

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
                DayToExpiration: (int)dayToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation
                       Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_CALLWithBaseActive: baseActive
                                          Strike: strike
                                TimeToExpiration: timeToExp
                                        RiskFree: riskFree
                                       Deviation: deviation
                                        Dividend: dividend ];
   
}

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
               TimeToExpiration: (double)timeToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation
{
   return [ PFBlackScholes BS_CALLWithBaseActive: baseActive
                                          Strike: strike
                                TimeToExpiration: timeToExp
                                        RiskFree: riskFree
                                       Deviation: deviation
                                        Dividend: 0.0 ];
}

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
                DayToExpiration: (int)dayToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_CALLWithBaseActive: baseActive
                                          Strike: strike
                                TimeToExpiration: timeToExp
                                        RiskFree: riskFree
                                       Deviation: deviation ];
}

#pragma Mark - BS_PUT (Расчет премии по опциону Put)

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
              TimeToExpiration: (double)timeToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation
                      Dividend: (double)dividend
{
   double expRate = exp(-riskFree * timeToExp);
   double expDiv = exp(-dividend * timeToExp);
   
   return strike * expRate * [ PFBlackSholesStatistic N: - [ PFBlackScholes d2WithBaseActive: baseActive
                                                                                      Strike: strike
                                                                            TimeToExpiration: timeToExp
                                                                                    RiskFree: riskFree
                                                                                   Deviation: deviation
                                                                                    Dividend: dividend ] ]
   - baseActive * expDiv * [ PFBlackSholesStatistic N: - [ PFBlackScholes d1WithBaseActive: baseActive
                                                                                    Strike: strike
                                                                          TimeToExpiration: timeToExp
                                                                                  RiskFree: riskFree
                                                                                 Deviation: deviation
                                                                                  Dividend: dividend ] ];
}

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
               DayToExpiration: (int)dayToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation
                      Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return  [ PFBlackScholes BS_PUTWithBaseActive: baseActive
                                          Strike: strike
                                TimeToExpiration: timeToExp
                                        RiskFree: riskFree
                                       Deviation: deviation
                                        Dividend: dividend ];
}

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
              TimeToExpiration: (double)timeToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation
{
   return  [ PFBlackScholes BS_PUTWithBaseActive: baseActive
                                          Strike: strike
                                TimeToExpiration: timeToExp
                                        RiskFree: riskFree
                                       Deviation: deviation
                                        Dividend: 0.0 ];
}

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
               DayToExpiration: (int)dayToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return  [ PFBlackScholes BS_PUTWithBaseActive: baseActive
                                          Strike: strike
                                TimeToExpiration: timeToExp
                                        RiskFree: riskFree
                                       Deviation: deviation ];
}

#pragma mark - BS_CDELTA (Расчет дельты опциона Call)

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   return [ PFBlackSholesStatistic N: [ PFBlackScholes d1WithBaseActive: baseActive
                                                                 Strike: strike
                                                       TimeToExpiration: timeToExp
                                                               RiskFree: riskFree
                                                              Deviation: deviation
                                                               Dividend: dividend ] ];
}

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return  [ PFBlackScholes BS_CDELTAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: riskFree
                                          Deviation: deviation
                                           Dividend: dividend ];
}

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   return  [ PFBlackScholes BS_CDELTAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: riskFree
                                          Deviation: deviation
                                           Dividend: 0.0 ];
}

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return  [ PFBlackScholes BS_CDELTAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: riskFree
                                          Deviation: deviation ];
}

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_CDELTAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: PFRiskFree
                                          Deviation: PFDeviation
                                           Dividend: 0.0 ];
}

#pragma mark - BS_PDELTA (Расчет дельты опциона Put)

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   return [ PFBlackSholesStatistic N: [ PFBlackScholes d1WithBaseActive: baseActive
                                                                 Strike: strike
                                                       TimeToExpiration: timeToExp
                                                               RiskFree: riskFree
                                                              Deviation: deviation
                                                               Dividend: dividend ] ] - 1;
}

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PDELTAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: dividend ];
}

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   return [ PFBlackScholes BS_PDELTAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: 0.0 ];
}

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PDELTAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation ];
}

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_PDELTAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: PFRiskFree
                                          Deviation: PFDeviation
                                           Dividend: 0.0 ];
}

#pragma mark - BS_CTHETA (Расчет временного распада для текущего момента времени у опциона Call)

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double var_d1 = [ PFBlackScholes d1WithBaseActive: baseActive Strike: strike TimeToExpiration: timeToExp RiskFree: riskFree Deviation: deviation Dividend: dividend ];
   double var_d2 = [ PFBlackScholes d2WithBaseActive: baseActive Strike: strike TimeToExpiration: timeToExp RiskFree: riskFree Deviation: deviation Dividend: dividend ];
   
   double nd11 = exp(-var_d1 * var_d1 / 2.0) / sqrt(2 * M_PI);
   double expRate = exp(-riskFree * timeToExp);
   
   return timeDif * (baseActive * deviation * nd11 / (2 * sqrt(timeToExp)) + strike * riskFree * expRate * [ PFBlackSholesStatistic N: var_d2 ]);
}

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_CTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: dividend ];
}


+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   return [ PFBlackScholes BS_CTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: 0.0 ];
}


+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_CTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation ];
}

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_CTHETAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: PFRiskFree
                                          Deviation: PFDeviation
                                           Dividend: 0.0 ];
}

#pragma mark - BS_PTHETA (Расчет временного распада для текущего момента времени у опциона Put)

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double expRate = exp(-riskFree * timeToExp);
   
   return [ PFBlackScholes BS_CTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: dividend ] - timeDif * strike * riskFree * expRate;
}


+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: dividend ];
}

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   return [ PFBlackScholes BS_PTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: 0.0 ];
}

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PTHETAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation ];
}

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_PTHETAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: PFRiskFree
                                          Deviation: PFDeviation
                                           Dividend: 0.0 ];
}

#pragma mark - BS_CVEGA (Расчет влияния волатильности на премию опциона Call)

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend
{
   double var_d1 = [ PFBlackScholes d1WithBaseActive: baseActive Strike: strike TimeToExpiration: timeToExp RiskFree: riskFree Deviation: deviation Dividend: dividend ];
   double nd11 = exp(-var_d1 * var_d1 / 2.0) / sqrt(2 * M_PI);
   
   return vegaDif * baseActive * nd11 * sqrt(timeToExp);
}


+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_CVEGAWithBaseActive: baseActive
                                           Strike: strike
                                 TimeToExpiration: timeToExp
                                         RiskFree: riskFree
                                        Deviation: deviation
                                         Dividend: dividend ];
}

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
{
   return [ PFBlackScholes BS_CVEGAWithBaseActive: baseActive
                                           Strike: strike
                                 TimeToExpiration: timeToExp
                                         RiskFree: riskFree
                                        Deviation: deviation
                                         Dividend: 0.0 ];
}

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_CVEGAWithBaseActive: baseActive
                                           Strike: strike
                                 TimeToExpiration: timeToExp
                                         RiskFree: riskFree
                                        Deviation: deviation ];
}

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_CVEGAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: PFRiskFree
                                         Deviation: PFDeviation
                                          Dividend: 0.0 ];
}

#pragma mark - BS_PVEGA (Расчет влияния волатильности на премию опциона Put)

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend
{
   double var_d1 = [ PFBlackScholes d1WithBaseActive: baseActive Strike: strike TimeToExpiration: timeToExp RiskFree: riskFree Deviation: deviation Dividend: dividend ];
   double nd11 = exp(-var_d1 * var_d1 / 2.0) / sqrt(2 * M_PI);
   
   return vegaDif * baseActive * nd11 * sqrt(timeToExp);
}

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PVEGAWithBaseActive: baseActive
                                           Strike: strike
                                 TimeToExpiration: timeToExp
                                         RiskFree: riskFree
                                        Deviation: deviation
                                         Dividend: dividend ];
}

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
{
   return [ PFBlackScholes BS_PVEGAWithBaseActive: baseActive
                                           Strike: strike
                                 TimeToExpiration: timeToExp
                                         RiskFree: riskFree
                                        Deviation: deviation
                                         Dividend: 0.0 ];
}

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PVEGAWithBaseActive: baseActive
                                           Strike: strike
                                 TimeToExpiration: timeToExp
                                         RiskFree: riskFree
                                        Deviation: deviation ];
}

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_PVEGAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: PFRiskFree
                                         Deviation: PFDeviation
                                          Dividend: 0.0 ];
}


#pragma mark - BS_CGAMMA (Расчет скорости изменения дельты опциона Call)

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double var_d1 = [ PFBlackScholes d1WithBaseActive: baseActive Strike: strike TimeToExpiration: timeToExp RiskFree: riskFree Deviation: deviation Dividend: dividend ];
   double nd11 = exp(-var_d1 * var_d1 / 2.0) / sqrt(2 * M_PI);
   
   return gammaDif * nd11 / (baseActive * deviation * sqrt(timeToExp));
}

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return  [ PFBlackScholes BS_CGAMMAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: riskFree
                                          Deviation: deviation
                                           Dividend: dividend ];
}

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   return  [ PFBlackScholes BS_CGAMMAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: riskFree
                                          Deviation: deviation
                                           Dividend: 0.0 ];
}

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return  [ PFBlackScholes BS_CGAMMAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: riskFree
                                          Deviation: deviation ];
}

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_CGAMMAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: PFRiskFree
                                          Deviation: PFDeviation
                                           Dividend: 0.0 ];
}

#pragma mark - BS_PGAMMA (Расчет скорости изменения дельты опциона Put)

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double var_d1 = [ PFBlackScholes d1WithBaseActive: baseActive Strike: strike TimeToExpiration: timeToExp RiskFree: riskFree Deviation: deviation Dividend: dividend ];
   double nd11 = exp(-var_d1 * var_d1 / 2.0) / sqrt(2 * M_PI);
   
   return gammaDif * nd11 / (baseActive * deviation * sqrt(timeToExp));
}

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PGAMMAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: dividend ];
}

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   return [ PFBlackScholes BS_PGAMMAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation
                                          Dividend: 0.0 ];
}

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
{
   double timeToExp = dayToExp / dayInYear;
   
   return [ PFBlackScholes BS_PGAMMAWithBaseActive: baseActive
                                            Strike: strike
                                  TimeToExpiration: timeToExp
                                          RiskFree: riskFree
                                         Deviation: deviation ];
}

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                            Strike: (double)strike
                  TimeToExpiration: (double)timeToExp
{
   return  [ PFBlackScholes BS_PGAMMAWithBaseActive: baseActive
                                             Strike: strike
                                   TimeToExpiration: timeToExp
                                           RiskFree: PFRiskFree
                                          Deviation: PFDeviation
                                           Dividend: 0.0 ];
}

@end