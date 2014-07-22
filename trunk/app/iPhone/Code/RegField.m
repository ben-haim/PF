

#import "RegField.h"


@implementation RegField
@synthesize fieldId, name, status, type, inputType, values, fieldView, filter;

+(id)initWithId:(RegFields) lFieldId 
			   withName:(NSString *) lName 
			 withStatus:(FieldStatus) lStatus
			   withType:(FieldType) lType 
		  withInputType:(FieldInputType) lInputType
{	
	id newInstance = [[[self class] alloc] init];
	[newInstance setFieldId:lFieldId];
	[newInstance setName:lName];
	[newInstance setStatus:lStatus];
	[newInstance setType:lType];
	[newInstance setInputType:lInputType];
	[newInstance setFilter:@""];
	
	return [newInstance autorelease];
}

+(id)initWithId:(RegFields) lFieldId 
			   withName:(NSString *) lName 
			 withStatus:(FieldStatus) lStatus
			   withType:(FieldType) lType 
			 withValues:(NSArray *) lValues
{
	id newInstance = [[[self class] alloc] init];
	[newInstance setFieldId:lFieldId];
	[newInstance setName:lName];
	[newInstance setStatus:lStatus];
	[newInstance setType:lType];
	[newInstance setValues:lValues];
	[newInstance setFilter:@""];
	
	return [newInstance autorelease];
}

- (NSArray *)getValues
{
	NSMutableArray *filteredArray = nil;
	if([values count] > 0)
	{				
		if([[values objectAtIndex:0] class] == [ListEntry class] )
		{
			filteredArray = [[NSMutableArray alloc] init];
			if ([filter length] >0)
			{
				for(ListEntry *listEntry in values)
				{
					if ([[listEntry filter] isEqual:filter] || [[listEntry filter] length] == 0 ) 
					{
						[filteredArray addObject:listEntry];
					}
				}
			}
			else 
			{
				for(ListEntry *listEntry in values)
				{
					if ([[listEntry filter] length] == 0 ) 
					{
						[filteredArray addObject:listEntry];
					}
				}
			}
		}
		else 
		{
			filteredArray = [values copy];
		}
		return [filteredArray autorelease];
	 }
	else 
	{
		return nil;
	}
}

- (NSString *)getValue
{
	NSString *value;
	switch (type) 
	{
		case FIELD_TYPE_TEXT:
			value = [((UITextField *)fieldView) text];
			break;
		case FIELD_TYPE_SELECT:
			if ([((DropDown *)fieldView) selectedIndex] > -1)
			{
				if([[values objectAtIndex:0] class] == [ListEntry class])
				{
					value = [NSString stringWithFormat:@"%@", [((ListEntry *)[values objectAtIndex:[((DropDown *)fieldView) selectedIndex]]) value]];
				}
				else 
				{						
					value = [NSString stringWithFormat:@"%@", [values objectAtIndex:[((DropDown *)fieldView) selectedIndex]]];
				}
			}
			else
				value = @"";
			break;
		default:
			break;
	}
	return value;
}

- (NSString *)getFieldLabel
{
	NSString *fieldName;
	switch (status) 
	{
		case FIELD_STATUS_VISIBLE_MANDADORY:
			fieldName = [[NSString alloc] initWithFormat:@"%@*", name];
			break;
		case FIELD_STATUS_VISIBLE:
			fieldName = [[NSString alloc] initWithFormat:@"%@", name];
			break;
		default:
			break;
	} 
	return fieldName;
}

- (UIKeyboardType) getKeyboardType
{
	switch (inputType) 
	{
		case INPUT_TEXT:
			return UIKeyboardTypeASCIICapable;
			break;
		case INPUT_EMAIL:
			return UIKeyboardTypeEmailAddress;
			break;
		case INPUT_PHONE:
		case INPUT_NUMBER:
			return UIKeyboardTypeNumbersAndPunctuation;
			break;
		default:
			return UIKeyboardTypeAlphabet;
			break;
	}
}

- (int)hasValidValue
{
	if (status == FIELD_STATUS_VISIBLE_MANDADORY) 
	{
		NSString *viewValue;
		DropDown *dropDown;
		switch (type) 
		{
			case FIELD_TYPE_TEXT:
				viewValue = [((UITextField *)fieldView) text];
				if ([viewValue length] == 0) 
				{
					//value is empty
					return 1;
				}
				else
				{
					 if (inputType == INPUT_EMAIL) 
					 {
						 NSString* emailRegex = @"(?i)[[a-z][0-9][._%-]]+[@]{1}[[a-z][0-9]]+[.]{1}[a-z]+([.]{1}[a-z]+)?"; 
						 NSPredicate* emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
						 if([emailPredicate evaluateWithObject:viewValue])
						 {
							 //email ok
							 return 0;
						 }	
						 else
						 {
							 //email not ok
							 return 2;
						 }							 
					 }
					else if (inputType == INPUT_PHONE) 
					{
						NSString* phoneRegex = @"[0-9]+"; 
						NSPredicate* phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
						if([phonePredicate evaluateWithObject:viewValue])
						{
							//phone ok
							return 0;
						}	
						else
						{
							//phone not ok
							return 2;
						}	
					}
					else 
					{
						//value is ok
						return 0;
					}
				}
				break;
			case FIELD_TYPE_SELECT:
				dropDown = (DropDown *)fieldView;
				int selection = [dropDown selectedIndex];
				if (selection < 0)
				{
					//nothing selected
					return 1;
				}
				else 
				{
					//will do
					return 0;
				}
				break;
		}
	}
	else 
	{
		return 0;
	}
	
	return 0;

}

- (void) focusOut
{
	if (type == FIELD_TYPE_TEXT)
		[((UITextField *)fieldView) resignFirstResponder];
}
@end
