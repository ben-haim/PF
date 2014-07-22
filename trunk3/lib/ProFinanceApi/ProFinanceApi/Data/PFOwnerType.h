//
//  OwnerType.h
//  ProFinanceApi
//
//  Created by Admin on 20.01.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef  enum  {
    OWNER_SETTINGS,
    
    OWNER_USER_GROUP,
    OWNER_USER,
    OWNER_BRANDING,
    OWNER_ACCOUNT,
    OWNER_INSTRUMENT_GROUP,
    OWNER_INSTRUMENT,
    OWNER_SUBSCRIBE,
    OWNER_INSTRUMENT_PART,
    OWNER_SCHEDULER_TASK,
    OWNER_COMMISSION_PLAN,
    OWNER_EXT_FIELD,
    OWNER_ACCOUNT_OPERATION,
    OWNER_BLACK_LIST,
    OWNER_POSITION,
    OWNER_ORDER,
    OWNER_SERVER,
    OWNER_REPORT,
    OWNER_TRADE,
    OWNER_ALERT,
    OWNER_DIALOG,
    OWNER_NOTIFICATION,
    OWNER_EXT_ORD,
    OWNER_MAIL_CONFIGURATION,
    OWNER_MAIL_PATTERN_TYPE,
    OWNER_MAIL_PATTERN_DATA,
    OWNER_NEWS,
    
    //PAMM
    OWNER_PAMM_MASTER,
    OWNER_PAMM_LINK,
    OWNER_PAMM_SHARE,
    
    OWNER_MIRROR_LINK,
    OWNER_DB_SETTINGS,
    OWNER_BROKER_MESSAGE,
    
    //SMS
    OWNER_SMS_CONFIGURATION,
    OWNER_SMS_PATTERN_TYPE,
    OWNER_SMS_PATTERN_DATA,
    OWNER_ACCOUNT_OPERATION_REQUEST,
    OWNER_EXTERNAL_FEED,
    OWNER_ACCOUNT_OPERATION_TYPE,
    OWNER_ORDER_STATE,
    OWNER_INVESTOR,
    OWNER_TRADING_SESSION,
    OWNER_CROSS_RATE,
    OWNER_HOLIDAY,
    OWNER_INSTRUMENT_CONTRACT,
    OWNER_SWAP_PLAN,
    OWNER_SPREAD_PLAN,
    OWNER_AUTOBROKER
    
} OwnerType;

