
#import "ArrayMath.h"


@implementation ArrayMath


-(id)initWithLength:(uint)len
{	
	self = [super init];
    if(self == nil)
        return self;
	length		= len;
	capacity	= 2*length;
	data		= malloc(capacity * sizeof(double));
	
    return self;
}
-(id)initWithArray:(NSMutableArray*)src
{
	self = [self initWithLength:(int)[src count]];
    if(self == nil)
        return self;
	
	int i = 0;
	for( NSNumber* num in src)
	{
		data[i++] = [num doubleValue];
	}
    return self;
}

-(void)dealloc
{	
    if(data)
	{
		free(data);
		data = nil;
	}
}

-(double*)getData
{
	return data;
}

-(uint)getLength
{
	return length;
}

-(void)addElement:(double)elem
{
	if(length>=capacity)
	{
		//realloc
		int new_capacity = capacity * 2;
		data = realloc(data, new_capacity);
		capacity = new_capacity;
	}
	data[length] = elem;
	length++;
}

-(ArrayMath*)add:(ArrayMath*)v
{
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(isnan(a1) || isnan(a2))
            res_data[i] = NAN;
        else
            res_data[i] = a1 + a2;
    }
    
    return res;
}
        
-(ArrayMath*)sub:(ArrayMath*)v
{  
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(isnan(a1) || isnan(a2))
            res_data[i] = NAN;
        else
            res_data[i] = a1 - a2;
    }
    
    return res; 
}

-(ArrayMath*)sub2:(double)a2
{  
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        if(isnan(a1) || isnan(a2))
            res_data[i] = NAN;
        else
            res_data[i] = a1 - a2;
    }
    
    return res; 
}
        
-(ArrayMath*)mul:(ArrayMath*)v
{ 		
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(isnan(a1) || isnan(a2))
            res_data[i] = NAN;
        else
            res_data[i] = a1 * a2;
    }
    
    return res;
}

-(ArrayMath*)mul2:(double)a2
{         
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        if(isnan(a1) || isnan(a2))
            res_data[i] = NAN;
        else
            res_data[i] = a1 * a2;
    }
    
    return res;
}
    
-(ArrayMath*)div:(ArrayMath*)v
{
	ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(isnan(a1) || isnan(a2) || a2==0)
            res_data[i] = NAN;
        else
            res_data[i] = a1 / a2;
    }
    
    return res;
}

-(ArrayMath*)safeDiv:(ArrayMath*)v AndStub:(double)stub
{ 	
	ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(isnan(a1) || isnan(a2) || a2==0)
		{
            if(a1!=0)                
				res_data[i] = NAN;
			else   
				res_data[i] = stub;				
		}
        else
            res_data[i] = a1 / a2;
    }
    
    return res;
}

-(ArrayMath*)acc
{
    double sum = 0.0;    
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        if(isnan(a1))
		{
            res_data[i] = sum;
		}
        else
		{
            sum			= sum + a1;
            res_data[i] = sum;
		}
    }
    
    return res;
}

-(double)min
{
    return [self min2:0 AndLength:length];
}

-(double)max
{
    return [self max2:0 AndLength:length];
}


-(double)min2:(uint)start AndLength:(uint)len
{
    double _min = HUGE_VAL;
	
    for (int i = start; i < start + len; i++) 
    {
        double a1 = data[i];
        if(isnan(a1))
            _min = _min;
        else
            _min = MIN(_min, a1);
    }
    
    return (_min!=HUGE_VAL)?_min:NAN;
}

-(double)max2:(uint)start AndLength:(uint)len
{
    double _max = -HUGE_VAL;
    
    for (int i = start; i < start + len; i++) 
    {
        double a1 = data[i];
        if(isnan(a1))
            _max = _max;
        else
            _max = MAX(_max, a1);
    }
    return (_max!=-HUGE_VAL)?_max:NAN;
	
}

-(ArrayMath*)trim:(uint)start AndLength:(uint)new_length
{
    if (new_length == 0)
    {
        new_length = length - start;
    }
    ArrayMath* res = [[ArrayMath alloc] initWithLength:new_length];
	double* res_data = [res getData];
		
    int i = start;
	int c = 0;
    while (i < start + new_length) 
    {
		res_data[c++] = data[i++];
    }
	
    return res;
}

-(ArrayMath*)abs
{	   
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        if(isnan(a1))
            res_data[i] = NAN;
        else
            res_data[i] = fabs(a1);
    }
    
    return res;
}

-(ArrayMath*)delta:(int)shift //default shift 1
{	
    double prev = NAN;
    double cur = NAN;
	
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
	int i = 0;
    while (i < shift && i < length)		
		res_data[i++] = NAN;
	
    i = shift; 
    while (i < length)
    {
        prev = data[i-1];
        cur = data[i];
        
		res_data[i] = cur - prev;
		i++;
    }
    
    return res;
}

-(ArrayMath*)shiftRight:(int)period
{	
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
	int i = 0;
    for(i=0; i<MIN(period, length); i++)
		res_data[i] = NAN;
	
	for(int k=0; k<length - period; k++)
	{
        double a1 = data[k];
		res_data[i++] = a1;
	}
    
    return res;
}



-(ArrayMath*)selectGT:(ArrayMath*)v AndStub:(double)stub
{
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(a1 > a2)
            res_data[i] = a1;
        else
            res_data[i] = stub;
    }
    
    return res;
}
-(ArrayMath*)selectEQZ:(ArrayMath*)v AndStub:(double)stub //default stub == 0
{	
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [v getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(!isnan(a2) && a2 == 0)
            res_data[i] = a1;
        else
            res_data[i] = stub;
    }
    
    return res;
}
-(ArrayMath*)selectLTZ:(double)stub //default stub == 0
{
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [self getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if(!isnan(a2) && a2 < 0)
            res_data[i] = a1;
        else
            res_data[i] = stub;
    }
    
    return res;	
}
-(ArrayMath*)selectGTZ:(double)stub //default stub == 0
{
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	double* v_data = [self getData];
	
    for (int i = 0; i < length; i++) 
    {
        double a1 = data[i];
        double a2 = v_data[i];
        if (!isnan(a2) && a2 > 0)
            res_data[i] = a1;
        else
            res_data[i] = stub;
    }
    
    return res;
}
        
-(ArrayMath*)movMin:(uint)period
{
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	int data_count = [res getLength];
	int i = 0;
    for(i=0; i<MIN(period, length)-1; i++)
		res_data[i] = NAN;
	i = period - 1;
	
    while (i < data_count) 
	{
        double max_val = HUGE_VAL;
        int j = 0;
        while (j < period) 
        {
            max_val = MIN(max_val, data[i - j]);
            j++;
        }
        res_data[i] = max_val;
        i++;		
	}
    return res;
    /*var loc1:*;
    loc1 = null;
    var loc2:*;
    loc2 = 0;
    var loc3:*;
    loc3 = null;
    var loc4:*;
    loc4 = NaN;
    var loc5:*;
    loc5 = 0;
    loc1 = new Array();
    loc2 = 0;
    while (loc2 < (arg1 - 1)) 
    {
        loc1.push(Number.NaN);
        ++loc2;
    }
    loc2 = (arg1 - 1);
    while (loc2 < data.length) 
    {
        loc4 = Number.MAX_VALUE;
        loc5 = 0;
        while (loc5 < arg1) 
        {
            loc4 = Math.min(loc4, data[(loc2 - loc5)]);
            ++loc5;
        }
        loc1.push(loc4);
        ++loc2;
    }
    return (loc3 = new Xogee.Charts.ArrayMath(loc1)).trim(0, data.length);*/
}        
-(ArrayMath*)movMax:(uint)period
{
    ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	int data_count = [res getLength];
	int i = 0;
    for(i=0; i<MIN(period, length)-1; i++)
		res_data[i] = NAN;
	i = period - 1;
	
    while (i < data_count) 
	{
        double max_val = -HUGE_VAL;
        int j = 0;
        while (j < period) 
        {
            max_val = MAX(max_val, data[i - j]);
            j++;
        }
        res_data[i] = max_val;
        i++;		
	}
    return res;
	/*var loc1:*;
	loc1 = null;
	var loc2:*;
	loc2 = 0;
	var loc3:*;
	loc3 = null;
	var loc4:*;
	loc4 = NaN;
	var loc5:*;
	loc5 = 0;
	loc1 = new Array();
	loc2 = 0;
	while (loc2 < (arg1 - 1)) 
	{
		loc1.push(Number.NaN);
		++loc2;
	}
	loc2 = (arg1 - 1);
	while (loc2 < data.length) 
	{
		loc4 = Number.MIN_VALUE;
		loc5 = 0;
		while (loc5 < arg1) 
		{
			loc4 = Math.max(loc4, data[(loc2 - loc5)]);
			++loc5;
		}
		loc1.push(loc4);
		++loc2;
	}
	return (loc3 = new Xogee.Charts.ArrayMath(loc1)).trim(0, data.length);*/
}
-(ArrayMath*)movAvg:(uint)period
{
	ArrayMath* res = [[ArrayMath alloc] initWithLength:length];

	if ( length == 0 )
		return res;

	int i = 0;
	int data_count = length;
    double sum = NAN;
    int iSum = 0;	

	double* res_data = [res getData];
	
	while (i < MIN(period, length) - 1) 
    {
        res_data[i++] = NAN;
    }
	i = period - 1;
    while (i < data_count) 
    {
        sum = 0;
		iSum = 0;
        while (iSum < period) 
        {
			double a1 = data[i - iSum];
            sum = sum + a1;
			iSum++;
        }
		res_data[i] = (sum / period);
        i++;
    }	
    return res;
}

-(ArrayMath*)movAvgRsi:(uint)period
{
	int i = 0;
	int data_count = length;
    double sum = NAN;
    int iSum = 0;	
	
	ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	
	while (i < MIN(period, length)) 
    {
        res_data[i++] = NAN;
    }
	i = period;
	
	double last_value = NAN;
	
	while (i < data_count) 
    {
        sum = 0;
		iSum = 0;
		if(isnan(last_value))
		{
			while (iSum <= period) 
			{
				sum = sum + data[i - iSum];
				iSum++;
			}
			res_data[i] = (sum / period);
			last_value = sum / period;
		}
		else
		{
			last_value = (last_value*(period-1) + data[i])/period;					
			res_data[i] = last_value;
		}
        i++;
    }	
    return res;
	
}


-(ArrayMath*)expAvg:(double)k
{
	ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	double* res_data = [res getData];
	int i = 0;
	int data_count = length;
	double Xi = NAN;
	
	
    while (i < data_count) 
	{
		if (i != 0)
		{
			if (!isnan(data[i]) && !isnan(res_data[i - 1]))
			{
				Xi = data[i] * k + res_data[i - 1] * (1 - k);
				res_data[i] = Xi;
			}
			else 
			{
				res_data[i] = data[i];
			}
		}
		else 
		{
			res_data[i] = data[i];
		}
		i++;
	}
	
    return res;
}

-(ArrayMath*)movStdDev:(uint)period
{
	ArrayMath* res = [[ArrayMath alloc] initWithLength:length];
	ArrayMath* sma	= [self movAvg:period];
	double* res_data = [res getData];
	double* sma_data = [sma getData];
	int i = 0;
	int data_count = length;
    double Sum = NAN;
    int iSum = 0;	
	while (i < MIN(period, length) - 1) 
    {
        res_data[i++] = NAN;
    }
	i = period - 1;
	
    while (i < data_count) 
    {
        Sum = 0;
        iSum = 0;
        while (iSum < period) 
        {
			double val = data[i - iSum] - sma_data[i];
            Sum = Sum + val*val;
            iSum++;
        }
		res_data[i] = (period != 0) ? sqrt(Sum / period) : 0;
        i++;
    }
    return res;
}
        

        

        

@end
