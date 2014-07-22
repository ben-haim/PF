#import "PFRound.h"

NSInteger PFDoubleToInteger( double double_ )
{
   static double possible_rounding_ = 0.4;
   
   return double_ < 0.0 ? double_ - possible_rounding_ : double_ + possible_rounding_;
}
