#import <Foundation/Foundation.h>

/*
 Модель Блэка — Шоулза. Класс расчета премии по опционам Call и Put. Расчет основных греков
 
 BS_CALL       Calculates the theoretical price of a call option
 BS_CDELTA     Calculates the delta (hedge ratio) of call option
 BS_CTHETA     Calculates the theta of a call
 BS_CGAMMA     Calculates the gamma of a call
 BS_CVEGA      Calculates the vega of a call
 BS_PUT        Calculates the theoretical price of a put option
 BS_PDELTA     Calculates the delta (hedge ratio) of a put
 BS_PTHETA     Calculates the theta of a put
 BS_PGAMMA     Calculates the gamma of a put
 BS_PVEGA      Calculates the vega of a put
 
 "baseActive" - Значение базового актива
 "strike" - Страйк опциона
 "timeToExp" - Время до экспирации (сколько лет осталось)
 "dayToExp" - Дней до экспирации (сколько дней осталось)
 "riskFree" - Безрисковай процентная ставка
 "deviation" - Стандартное отклонение
 "dividend" - Размер дивиденда по акциям
 
 */

@interface PFBlackScholes : NSObject

#pragma mark - d1 (Расчет величины d1 из формулы Блэка Шолза)

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend;

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend;

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation;

+(double) d1WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation;

#pragma mark - d2 (Расчет величины d2 из формулы Блэка Шолза)

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend;

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation
                  Dividend: (double)dividend;

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
          TimeToExpiration: (double)timeToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation;

+(double) d2WithBaseActive: (double)baseActive
                    Strike: (double)strike
           DayToExpiration: (int)dayToExp
                  RiskFree: (double)riskFree
                 Deviation: (double)deviation;

#pragma mark - BS_CALL (Расчет премии по опциону Call)

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
               TimeToExpiration: (double)timeToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation
                       Dividend: (double)dividend;

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
                DayToExpiration: (int)dayToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation
                       Dividend: (double)dividend;

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
               TimeToExpiration: (double)timeToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation;

+(double) BS_CALLWithBaseActive: (double)baseActive
                         Strike: (double)strike
                DayToExpiration: (int)dayToExp
                       RiskFree: (double)riskFree
                      Deviation: (double)deviation;

#pragma Mark - BS_PUT (Расчет премии по опциону Put)

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
              TimeToExpiration: (double)timeToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation
                      Dividend: (double)dividend;

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
               DayToExpiration: (int)dayToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation
                      Dividend: (double)dividend;

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
              TimeToExpiration: (double)timeToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation;

+(double) BS_PUTWithBaseActive: (double)baseActive
                        Strike: (double)strike
               DayToExpiration: (int)dayToExp
                      RiskFree: (double)riskFree
                     Deviation: (double)deviation;

#pragma mark - BS_CDELTA (Расчет дельты опциона Call)

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_CDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp;

#pragma mark - BS_PDELTA (Расчет дельты опциона Put)

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_PDELTAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp;

#pragma mark - BS_CTHETA (Расчет временного распада для текущего момента времени у опциона Call)

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_CTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp;

#pragma mark - BS_PTHETA (Расчет временного распада для текущего момента времени у опциона Put)

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_PTHETAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp;

#pragma mark - BS_CVEGA (Расчет влияния волатильности на премию опциона Call)

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend;

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend;

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation;

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation;

+(double) BS_CVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp;

#pragma mark - BS_PVEGA (Расчет влияния волатильности на премию опциона Put)

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend;

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation
                        Dividend: (double)dividend;

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation;

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                 DayToExpiration: (int)dayToExp
                        RiskFree: (double)riskFree
                       Deviation: (double)deviation;

+(double) BS_PVEGAWithBaseActive: (double)baseActive
                          Strike: (double)strike
                TimeToExpiration: (double)timeToExp;

#pragma mark - BS_CGAMMA (Расчет скорости изменения дельты опциона Call)

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_CGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp;

#pragma mark - BS_PGAMMA (Расчет скорости изменения дельты опциона Put)

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation
                         Dividend: (double)dividend;

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                 TimeToExpiration: (double)timeToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                           Strike: (double)strike
                  DayToExpiration: (int)dayToExp
                         RiskFree: (double)riskFree
                        Deviation: (double)deviation;

+(double) BS_PGAMMAWithBaseActive: (double)baseActive
                            Strike: (double)strike
                  TimeToExpiration: (double)timeToExp;

@end
