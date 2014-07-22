

#import "ClientSettings.h"


@implementation ClientSettings
@synthesize demoRegistrationMode;
@synthesize regFields, demoUrl;

- (void) dealloc
{
	[regFields release];
	[super dealloc];
}

-(id) init
{	
	self = [super init];
    // the demoUrl is used only if you specify: demoRegistrationMode = DEMO_WEB
	demoUrl = @"http://www.cocacola.com";
    //TODO: specify which demo registration mode you would like to use
	demoRegistrationMode = DEMO_FORM;
	
    //comment out field you do not want to appear in the form
	regFields = [[NSArray alloc] initWithObjects:
				 [RegField initWithId:REG_FIELD_NAME withName:NSLocalizedString(@"DEMO_NAME", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY 
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_TEXT],
				 [RegField initWithId:REG_FIELD_COUNTRY withName:NSLocalizedString(@"DEMO_COUNTRY", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY 
							 withType:FIELD_TYPE_SELECT withValues:[self countries]],
				 [RegField initWithId:REG_FIELD_PHONE withName:NSLocalizedString(@"DEMO_PHONE", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_PHONE],
				 [RegField initWithId:REG_FIELD_EMAIL withName:NSLocalizedString(@"DEMO_EMAIL", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY 
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_EMAIL],
				 [RegField initWithId:REG_FIELD_LEVERAGE withName:NSLocalizedString(@"DEMO_LEVERAGE", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY 
							 withType:FIELD_TYPE_SELECT withValues:[self leverage]],
				 
				/* [RegField initWithId:REG_FIELD_STATE withName:NSLocalizedString(@"DEMO_STATE", nil) withStatus:FIELD_STATUS_VISIBLE 
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_TEXT],
				 [RegField initWithId:REG_FIELD_CITY withName:NSLocalizedString(@"DEMO_CITY", nil) withStatus:FIELD_STATUS_VISIBLE 
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_TEXT],
				 [RegField initWithId:REG_FIELD_ADDRESS withName:NSLocalizedString(@"DEMO_ADDRESS", nil) withStatus:FIELD_STATUS_VISIBLE 
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_TEXT],
				 [RegField initWithId:REG_FIELD_ZIPCODE withName:NSLocalizedString(@"DEMO_ZIPCODE", nil) withStatus:FIELD_STATUS_VISIBLE 
							 withType:FIELD_TYPE_TEXT withInputType:INPUT_TEXT],*/
				 
				 
				 [RegField initWithId:REG_FIELD_GROUP withName:NSLocalizedString(@"DEMO_GROUP", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY 
							 withType:FIELD_TYPE_SELECT withValues:[self groups]],
				 
				 [RegField initWithId:REG_FIELD_DEPOSIT withName:NSLocalizedString(@"DEMO_DEPOSIT", nil) withStatus:FIELD_STATUS_VISIBLE_MANDADORY 
							 withType:FIELD_TYPE_SELECT withValues:[self deposit]], 
				 nil];
	
	return self;
}

- (NSArray *)groups
{
	NSArray *groups = [[NSArray alloc] initWithObjects:
					   [ListEntry initWithAlias:@"USD" withValue:@"demoforex-USD"],
					   [ListEntry initWithAlias:@"EUR" withValue:@"demoforex-EUR"],
					   [ListEntry initWithAlias:@"GBP" withValue:@"demoforex-GBP"],
					   nil];
	return groups;
}

- (NSArray *)leverage
{
	NSArray *leverage = [[NSArray alloc] initWithObjects:
						 [ListEntry initWithAlias:@"1:1" withValue:@"1"],
						 [ListEntry initWithAlias:@"1:25" withValue:@"25"],
						 [ListEntry initWithAlias:@"1:50" withValue:@"50"],
 						 [ListEntry initWithAlias:@"1:100" withValue:@"100"],
 						 [ListEntry initWithAlias:@"1:200" withValue:@"200"],
						 [ListEntry initWithAlias:@"1:500" withValue:@"500"],
						 nil];
	return leverage;
}

- (NSArray *)deposit
{
	NSArray *deposit = [[NSArray alloc] initWithObjects:
						 @"10000",
						 @"25000",
						 @"50000",
						@"100000",
						@"500000",
						@"1000000",
						@"5000000",
						 nil];
	return deposit;
}

- (NSArray *)countries
{
	NSArray *array = [[NSArray alloc] initWithObjects: 
			@"Afghanistan",
			@"Albania",
			@"Algeria",
			@"American Samoa",
			@"Andorra",
			@"Angola",
			@"Anguilla",
			@"Antarctica",
			@"Antigua and Barbuda",
			@"Argentina",
			@"Armenia",
			@"Aruba",
			@"Australia",
			@"Austria",
			@"Azerbaidjan",
			@"Bahamas",
			@"Bahrain",
			@"Bangladesh",
			@"Barbados",
			@"Belarus",
			@"Belgium",
			@"Belize",
			@"Benin",
			@"Bermuda",
			@"Bhutan",
			@"Bolivia",
			@"Bosnia-Herzegovina",
			@"Botswana",
			@"Bouvet Island",
			@"Brazil",
			@"British Indian Ocean Territory",
			@"Brunei Darussalam",
			@"Bulgaria",
			@"Burkina Faso",
			@"Burundi",
			@"Cambodia, Kingdom of",
			@"Cameroon",
			@"Canada",
			@"Cape Verde",
			@"Cayman Islands",
			@"Central African Republic",
			@"Chad",
			@"Chile",
			@"China",
			@"Christmas Island",
			@"Cocos (Keeling) Islands",
			@"Colombia",
			@"Comoros",
			@"Congo",
			@"Congo, The Democratic Republic of the",
			@"Cook Islands",
			@"Costa Rica",
			@"Croatia",
			@"Cuba",
			@"Cyprus",
			@"Czech Republic",
			@"Denmark",
			@"Djibouti",
			@"Dominica",
			@"Dominican Republic",
			@"East Timor",
			@"Ecuador",
			@"Egypt",
			@"El Salvador",
			@"Equatorial Guinea",
			@"Eritrea",
			@"Estonia",
			@"Ethiopia",
			@"Falkland Islands",
			@"Faroe Islands",
			@"Fiji",
			@"Finland",
			@"Former Czechoslovakia",
			@"Former USSR",
			@"France",
			@"France (European Territory)",
			@"French Guyana",
			@"French Southern Territories",
			@"Gabon",
			@"Gambia",
			@"Georgia",
			@"Germany",
			@"Ghana",
			@"Gibraltar",
			@"Great Britain",
			@"Greece",
			@"Greenland",
			@"Grenada",
			@"Guadeloupe (French)",
			@"Guam (USA)",
			@"Guatemala",
			@"Guinea",
			@"Guinea Bissau",
			@"Guyana",
			@"Haiti",
			@"Heard and McDonald Islands",
			@"Holy See (Vatican City State)",
			@"Honduras",
			@"Hong Kong",
			@"Hungary",
			@"Iceland",
			@"India",
			@"Indonesia",
			@"Iran",
			@"Iraq",
			@"Ireland",
			@"Israel",
			@"Italy",
			@"Ivory Coast (Cote D\'Ivoire)",
			@"Jamaica",
			@"Japan",
			@"Jordan",
			@"Kazakhstan",
			@"Kenya",
			@"Kiribati",
			@"Kuwait",
			@"Kyrgyz Republic (Kyrgyzstan)",
			@"Laos",
			@"Latvia",
			@"Lebanon",
			@"Lesotho",
			@"Liberia",
			@"Libya",
			@"Liechtenstein",
			@"Lithuania",
			@"Luxembourg",
			@"Macau",
			@"Macedonia",
			@"Madagascar",
			@"Malawi",
			@"Malaysia",
			@"Maldives",
			@"Mali",
			@"Malta",
			@"Marshall Islands",
			@"Martinique (French)",
			@"Mauritania",
			@"Mauritius",
			@"Mayotte",
			@"Mexico",
			@"Micronesia",
			@"Moldavia",
			@"Monaco",
			@"Mongolia",
			@"Montserrat",
			@"Morocco",
			@"Mozambique",
			@"Myanmar",
			@"Namibia",
			@"Nauru",
			@"Nepal",
			@"Netherlands",
			@"Netherlands Antilles",
			@"Neutral Zone",
			@"New Caledonia (French)",
			@"New Zealand",
			@"Nicaragua",
			@"Niger",
			@"Nigeria",
			@"Niue",
			@"Norfolk Island",
			@"North Korea",
			@"Northern Mariana Islands",
			@"Norway",
			@"Oman",
			@"Pakistan",
			@"Palau",
			@"Panama",
			@"Papua New Guinea",
			@"Paraguay",
			@"Peru",
			@"Philippines",
			@"Pitcairn Island",
			@"Poland",
			@"Polynesia (French)",
			@"Portugal",
			@"Puerto Rico",
			@"Qatar",
			@"Reunion (French)",
			@"Romania",
			@"Russian Federation",
			@"Rwanda",
			@"S. Georgia & S. Sandwich Isls.",
			@"Saint Helena",
			@"Saint Kitts & Nevis Anguilla",
			@"Saint Lucia",
			@"Saint Pierre and Miquelon",
			@"Saint Tome (Sao Tome) and Principe",
			@"Saint Vincent & Grenadines",
			@"Samoa",
			@"San Marino",
			@"Saudi Arabia",
			@"Senegal",
			@"Seychelles",
			@"Sierra Leone",
			@"Singapore",
			@"Slovak Republic",
			@"Slovenia",
			@"Solomon Islands",
			@"Somalia",
			@"South Africa",
			@"South Korea",
			@"Spain",
			@"Sri Lanka",
			@"Sudan",
			@"Suriitem",
			@"Svalbard and Jan Mayen Islands",
			@"Swaziland",
			@"Sweden",
			@"Switzerland",
			@"Syria",
			@"Tadjikistan",
			@"Taiwan",
			@"Tanzania",
			@"Thailand",
			@"Togo",
			@"Tokelau",
			@"Tonga",
			@"Trinidad and Tobago",
			@"Tunisia",
			@"Turkey",
			@"Turkmenistan",
			@"Turks and Caicos Islands",
			@"Tuvalu",
			@"Uganda",
			@"Ukraine",
			@"United Arab Emirates",
			@"United Kingdom",
			@"United States",
			@"Uruguay",
			@"USA Minor Outlying Islands",
			@"Uzbekistan",
			@"Vanuatu",
			@"Venezuela",
			@"Vietnam",
			@"Virgin Islands (British)",
			@"Virgin Islands (USA)",
			@"Wallis and Futuna Islands",
			@"Western Sahara",
			@"Yemen",
			@"Yugoslavia",
			@"Zaire",
			@"Zambia",
			@"Zimbabwe",
			nil ];
	
	return array;
}

@end
