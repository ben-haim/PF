

#import <Foundation/Foundation.h>
#import "ListEntry.h"
#import "DropDown.h"

typedef enum
{
	FIELD_STATUS_INVISIBLE,
	FIELD_STATUS_VISIBLE,
	FIELD_STATUS_VISIBLE_MANDADORY
} FieldStatus;

typedef enum
{
	REG_FIELD_NAME = 0,
	REG_FIELD_EMAIL,
	REG_FIELD_COUNTRY,
	REG_FIELD_STATE,
	REG_FIELD_CITY,
	REG_FIELD_ZIPCODE,
	REG_FIELD_ADDRESS,
	REG_FIELD_PHONE,
	REG_FIELD_GROUP,
	REG_FIELD_LEVERAGE,
	REG_FIELD_DEPOSIT,
	REG_FIELD_TOTAL
}RegFields;

typedef enum
{
	FIELD_TYPE_TEXT,
	FIELD_TYPE_SELECT
} FieldType;

typedef enum
{
	INPUT_TEXT,
	INPUT_EMAIL,
	INPUT_PHONE,
	INPUT_NUMBER
} FieldInputType;

@interface RegField : NSObject 
{
	RegFields fieldId;
	NSString *name;
	FieldStatus status;
	FieldType type;
	FieldInputType inputType;
	NSArray *values; 
	UIView *fieldView;
	
	NSString *filter;
}

@property(assign) RegFields fieldId;
@property(assign) NSString *name;
@property(assign) FieldStatus status;
@property(assign) FieldType type;
@property(assign) FieldInputType inputType;
@property(assign) NSArray *values; 
@property(assign) UIView *fieldView;
@property(assign) NSString *filter;

+(id)initWithId:(RegFields) fieldId 
			   withName:(NSString *) name
			 withStatus:(FieldStatus) status
			   withType:(FieldType) type 
		  withInputType:(FieldInputType) inputType;

+(id)initWithId:(RegFields) fieldId 
			   withName:(NSString *) name
			 withStatus:(FieldStatus) status
			   withType:(FieldType) type 
			 withValues:(NSArray *) values;

- (NSArray *)getValues;

- (NSString *)getValue;

- (NSString *)getFieldLabel;

- (UIKeyboardType) getKeyboardType;

- (int)hasValidValue;

- (void) focusOut;
@end
