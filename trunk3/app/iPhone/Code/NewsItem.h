
#import <Foundation/Foundation.h>


@interface NewsItem : NSObject 
{
	bool		isRead;
	int			news_id;
	NSString *	subject;
	NSString *	category;
	NSString *	description;
	NSString *	date;
}

@property( assign) bool isRead;
@property( assign) int news_id;
@property( nonatomic, retain) NSString *subject;
@property( nonatomic, retain) NSString *category;
@property( nonatomic, retain) NSString *description;
@property( nonatomic, retain) NSString *date;
@end

