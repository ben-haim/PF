#ifndef Trader_HEXCOLOR_h
#define Trader_HEXCOLOR_h

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0]

#endif
