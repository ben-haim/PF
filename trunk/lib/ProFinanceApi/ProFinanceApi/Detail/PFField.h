#import "../PFTypes.h"

#import <Foundation/Foundation.h>

enum
{
   PFFieldUndefined = -1
   , PFFieldMessageType = 0
   , PFFieldXmlRequest = 1
   , PFFieldPfsMessage = 2
   , PFFieldLogin = 3
   , PFFieldPassword = 4
   , PFFieldSessionId = 5
   , PFFieldId = 6
   , PFFieldAmount = 7
   , PFFieldAmountLong = 8
   , PFFieldBalance = 9
   , PFFieldCloseOrderId = 10
   , PFFieldOpenOrderId = 11
   , PFFieldDate = 12
   , PFFieldPrice = 13
   , PFFieldNumber = 14
   , PFFieldBoundToOrderId = 15
   //16 is duplication for 75
   , PFFieldComment = 17
   , PFFieldOrderId = 18
   , PFFieldRequestId = 19
   , PFFieldLotSize = 20
   , PFFieldPointSize = 21
   , PFFieldName = 22
   , PFFieldNameExp1 = 23
   , PFFieldNameExp2 = 24
   , PFFieldInstrumentId = 25
   , PFFieldInstrumentTypeId = 26
   , PFFieldTradeMode = 27
   , PFFieldDescription = 28
   , PFFieldBarsType = 29
   , PFFieldNumberOfShares = 30
   , PFFieldBeginDayDate = 31
   , PFFieldEndDayDate = 32
   , PFFieldRouteList = 33
   , PFFieldTradeRouteList = 34
   , PFFieldMarginType = 35
   , PFFieldBaseLeverageNeg = 36
   , PFFieldBaseLeveragePos = 37
   , PFFieldCounterLeverageNeg = 38
   , PFFieldCounterLeveragePos = 39
   , PFFieldHoldMarginSize = 40
   , PFFieldHoldMarginSize10 = 41
   , PFFieldHoldMarginSize25 = 42
   , PFFieldHoldMarginSize50 = 43
   , PFFieldInitMarginSize = 44
   , PFFieldInitMarginSize10 = 45
   , PFFieldInitMarginSize25 = 46
   , PFFieldInitMarginSize50 = 47
   , PFFieldUseLeverage = 48
   , PFFieldMarginCoef = 49
   , PFFieldSwapBuy = 50
   , PFFieldSwapSell = 51
   , PFFieldSwapMeasure = 52
   , PFFieldType = 53
   , PFFieldBaseInstrumentID = 54
   , PFFieldFormulaType = 55
   , PFFieldStrikeIncrement = 56
   , PFFieldStrikeNumber = 57
   , PFFieldFirstBaseStrikePrice = 58
   , PFFieldStartTime = 59
   , PFFieldExpirationPeriodNum = 60
   , PFFieldExpirationPeriodDuration = 61
   , PFFieldExpDates = 62
   , PFFieldStrikePrices = 63
   , PFFieldMarginMode = 64
   , PFFieldSpreadMode = 65
   , PFFieldSpreadMeasure = 66
   , PFFieldSpread = 67
   , PFFieldBidShift = 68
   , PFFieldAskShift = 69
   , PFFieldIsHedgedMarginSize = 70
   , PFFieldBeginPreSesDate = 71
   , PFFieldEndPostSesDate = 72
   , PFFieldIsOptions = 73
   , PFFieldGroup = 74
   , PFFieldOrderType = 75
   , PFFieldOperationType = 76
   , PFFieldIsIrrevocable = 77
   , PFFieldIsByBroker = 78
   , PFFieldValidity = 79
   , PFFieldExpDay = 80
   , PFFieldExpMonth = 81
   , PFFieldExpYear = 82
   , PFFieldStrikePrice = 83
   , PFFieldOptionType = 84
   , PFFieldRouteId = 85
   , PFFieldSlPrice = 86
   , PFFieldTpPrice = 87
   , PFFieldTrOffset = 88
   , PFFieldAccountId = 89
   , PFFieldUserId = 90
   , PFFieldClientOrderId = 91
   , PFFieldSequenceId = 92
   , PFFieldOrderActionType = 93
   , PFFieldProtocolId = 94
   , PFFieldVerificationPassword = 95
   , PFFieldDateOfBuild = 96
   , PFFieldConnectionMode = 97
   , PFFieldClientType = 98
   , PFFieldFirstName = 99
   , PFFieldLastName = 100
   , PFFieldMiddleName = 101
   , PFFieldStreetAddress = 102
   , PFFieldCity = 103
   , PFFieldCountry = 104
   , PFFieldZip = 105
   , PFFieldState = 106
   , PFFieldAccounts = 107
   , PFFieldNeedVerificationPassword = 108
   , PFFieldPasswordExpired = 109
   , PFFieldTimeZoneOffset = 110
   , PFFieldSubscriptionType = 111
   , PFFieldSubscriptionAction = 112
   , PFFieldSenderId = 113
   , PFFieldTargetId = 114
   , PFFieldText = 115
   , PFFieldTheme = 116
   , PFFieldSource = 117
   , PFFieldLineNumber = 118
   , PFFieldNewsId = 119
   , PFFieldSymbol = 120
   , PFFieldPriority = 121
   , PFFieldIsUpperCaseSearch = 122
   , PFFieldIsContentSearch = 123
   , PFFieldIsEventSearch = 124
   , PFFieldLightSubs = 125
   , PFFieldPositionId = 126
   , PFFieldCreatedAt = 127
   , PFFieldActiveFlag = 128
   , PFFieldFilledAmount = 129
   , PFFieldAverageFilledPrice = 130
   , PFFieldOrderGroupId = 131
   , PFFieldMasterId = 132
   , PFFieldStopPrice = 133
   , PFFieldReferenceId = 134
   , PFFieldOrderStatus = 135
   , PFFieldOpenPrice = 136
   , PFFieldClosePrice = 137
   , PFFieldSwap = 138
   , PFFieldSlOrderId = 139
   , PFFieldTpOrderId = 140
   , PFFieldCloseTime = 141
   , PFFieldCommission = 142
   , PFFieldIsTrailing = 143
   , PFFieldLastOrderId = 144
   , PFFieldTradeId = 145
   , PFFieldPnl = 146
   , PFFieldExtId = 147
   , PFFieldCreatorName = 148
   , PFFieldExternalPrice = 149
   , PFFieldIsBuy = 150
   , PFFieldExchange = 151
   , PFFieldIsOpen = 152
   , PFFieldRange = 153
   , PFFieldXmlBody = 154
   , PFFieldServerIds = 155
   , PFFieldHolidays = 156
   , PFFieldAllowDay = 157
   , PFFieldAllowGtc = 158
   , PFFieldAllowGtd = 159
   , PFFieldAllowIoc = 160
   , PFFieldAllowMarket = 161
   , PFFieldAllowMoc = 162
   , PFFieldAllowStop = 163
   , PFFieldAllowLimit = 164
   , PFFieldAllowStopToLimit = 165
   , PFFieldAllowTrailingStop = 166
   , PFFieldAllowTradeStatus = 167
   , PFFieldCommissionPlanId = 168
   , PFFieldAllowMoo = 169
   , PFFieldIsMarginCall = 170
   , PFFieldIsPreMargin = 171
   , PFFieldGroupId = 172
   , PFFieldLeverage = 173
   , PFFieldCurrency = 174
   , PFFieldCrossType = 175
   , PFFieldCrossInstrumentId = 176
   , PFFieldBlockedSum = 177
   , PFFieldMinChange = 178
   , PFFieldTradingLevel = 179
   , PFFieldWarningLevel = 180
   , PFFieldMarginLevel = 181
   , PFFieldBrokerId = 182
   , PFFieldBeginBalance = 183
   , PFFieldLockedForOrders = 184
   , PFFieldCommunity = 185
   , PFFieldSubscribePlanId = 186
   , PFFieldBid = 187
   , PFFieldAsk = 188
   , PFFieldBidSize = 189
   , PFFieldAskSize = 190
   , PFFieldOpen = 191
   , PFFieldHigh = 192
   , PFFieldLow = 193
   , PFFieldPreClose = 194
   , PFFieldLastPrice = 195
   , PFFieldVolumeTotal = 196
   , PFFieldBidId = 197
   , PFFieldAskId = 198
   , PFFieldQuoteId = 199
   , PFFieldSide = 200
   , PFFieldSize = 201
   , PFFieldDayTradeVolume = 202
   , PFFieldOnBehalfUserId = 203
   , PFFieldSuperId = 204
   , PFFieldSortId = 205
   , PFFieldIsOpenPriceInMargin = 206
   , PFFieldIsMaster = 207
   , PFFieldLastSize = 208
   , PFFieldCrossPrice = 209
   , PFFieldIsClosed= 210
   , PFFieldUnderlier = 211
   , PFFieldOrderRefId = 212
   , PFFieldTimestamp = 213
   , PFFieldTextMessageType = 214
   , PFFieldBrokerIds = 215
   , PFFieldIsLock = 216
   , PFFieldNewsCategory = 217
   , PFFieldNewPassword = 218
   , PFFieldMode = 219
   , PFFieldIsMd5  = 220
   , PFFieldAccs = 221
   , PFFieldInstrumentList = 222
   , PFFieldRulesList = 223
   , PFFieldReports = 224
   , PFFieldIsPwdExpired = 225
   , PFFieldPhone = 226
   , PFFieldPhonePwd  = 227
   , PFFieldEmail  = 228
   , PFFieldIsBlocked = 229
   , PFFieldValue = 230
   , PFFieldKey = 231
   , PFFieldTemplate = 232
   , PFFieldDerivativePositionId = 233
   , PFFieldIsDeposit = 234
   , PFFieldPageNum = 235
   , PFFieldMaxRow = 236
   , PFFieldTableName = 237
   , PFFieldFingerPrint = 238
   , PFFieldSignature = 239
   , PFFieldAccountState = 240
   , PFFieldTodayFees = 241
   , PFFieldMinimalLot = 242
   , PFFieldLotStep = 243
   , PFFieldPublicKey = 244
   , PFFieldExpireAt = 245
   , PFFieldLockedForPamm = 246
   , PFFieldAllowFok = 247
   , PFFieldMaxFieldIndex = 248
   , PFFieldTypeModification = 249
   , PFFieldAmountModification = 250
   , PFFieldTifModification = 251
   , PFFieldPriceModification = 252
   , PFFieldOperationTypeModification = 253
   , PFFieldExpirationDateModification = 254
   , PFFieldTifsForOrderTypes = 255
   , PFFieldClearingSpan = 256
   , PFFieldInvestmentSpan = 257
   , PFFieldManualCofirm = 258
   , PFFieldLiquidationLevel = 259
   , PFFieldRewardAlgorithm = 260
   , PFFieldRewardFromTotal = 261
   , PFFieldGovernorAccountId = 262
   , PFFieldTradingVisible = 263
   , PFFieldGrossPnl = 264
   , PFFieldReinvestCycles = 265
   , PFFieldReinvestProfit = 266
   , PFFieldSlExpireAt = 267
   , PFFieldTpExpireAt = 268
   , PFFieldOrderLinkType = 269
   , PFFieldClientOrderIdToLink = 270
   , PFFieldSessionDescr = 271
   , PFFieldSessionBegin = 272
   , PFFieldSessionEnd = 273
   , PFFieldSessionType = 274
   , PFFieldTradeCount = 275
   , PFFieldCashBalance = 276
   , PFFieldPrecision = 277
   , PFFieldRolloverSpan = 278
   , PFFieldPositionCloserSetup = 279
   , PFFieldFundType = 280
   , PFFieldAccountIdOfUser = 281
   , PFFieldIsSigned = 282
   , PFFieldMinimalShareCount = 283
   , PFFieldMonthAvgGrossPerShare = 284
   , PFFieldOpenPrice1Month = 285
   , PFFieldOpenPrice3Month = 286
   , PFFieldOpenPrice6Month = 287
   , PFFieldOpenPrice1Year = 288
   , PFFieldAvgDayPriceChange = 289
   , PFFieldAvgMonthPriceChange = 290
   , PFFieldAnnualGain = 291
   , PFFieldAvgExposure = 292
   , PFFieldMaxDrawDown = 293
   , PFFieldMaxDrawDownDate = 294
   , PFFieldRecoveryFactor = 295
   , PFFieldPayoffRatio = 296
   , PFFieldSharpeRatio = 297
   , PFFieldValueAtRisk = 298
   , PFFieldSortingRatioR = 299
   , PFFieldSortingRatioG = 300
   , PFFieldProfitFactor = 302
   , PFFieldDays = 303
   , PFFieldRawBytes = 304
   , PFFieldEndTime = 305
   , PFFieldVersion = 306
   , PFFieldIsCompressed = 307
   , PFFieldHistoryPeriodType = 308
   , PFFieldPointer = 309
   , PFFieldTickCost = 310
   , PFFieldCounterId = 311
   , PFFieldAllowMamOrders = 312
   , PFFieldReservedBalance = 313
   , PFFieldIsAutotradeOrder = 314
   , PFFieldSlTrOffset = 315
   , PFFieldHedgedMarginCallCoefficient = 316
   , PFFieldIsOk = 317
   , PFFieldUsedMargin = 318
   , PFFieldOpenInterest = 319
   , PFFieldContractMonthDate = 320
   , PFFieldLastTradeDate = 321
   , PFFieldSettlementDate = 322
   , PFFieldNoticeDate = 323
   , PFFieldFirstTradeDate = 324
   , PFFieldAutoCloseDate = 325
   , PFFieldIndicativeAuctionPrice = 326
   , PFFieldDeliveryStatus = 327
   , PFFieldPerOrderPrice = 328
   , PFFieldFreeCommisionAmount = 329
   , PFFieldDealerCommisoin = 330
   , PFFieldMaxPerOrder = 331
   , PFFieldMinPerOrder = 332
   , PFFieldDeliveryMethod = 333
   , PFFieldQuoteRouteId = 334
   , PFFieldLastAmount = 335
   , PFFieldIsContiniousContract = 336
   , PFFieldManualConfirmExit = 337
   , PFFieldCreditValue = 338
   , PFFieldManagerShareCount = 339
   , PFFieldManagerCapital = 340
   , PFFieldInvestorCount = 341
   , PFFieldValuedDateBasis = 342
   , PFFieldOperationMode = 343
   , PFFieldBuyInit = 344
   , PFFieldBuySupp = 345
   , PFFieldSellInit = 346
   , PFFieldSellSupp = 347
   , PFFieldLogonForTrade = 348
   , PFFieldQuoteDelay = 349
   , PFFieldNodeId = 350
   , PFFieldNodeReportTable = 351
   , PFFieldAdressProtocol = 352
   , PFFieldIsHostNode = 353
   , PFFieldNodeLoad = 354
   , PFFieldLastRolloverTime = 355
   , PFFieldNextRolloverTime = 356
   , PFFieldChangePasswordStatus = 357

   , PFFieldAvailableMargin = 358
   , PFFieldMaintanceMargin = 359
   , PFFieldDeficiencyMargin = 360
   , PFFieldSurplusMargin = 361
   , PFFieldIntradayRiskManagement = 362
   , PFFieldAccountTradeStatus = 363
   , PFFieldAllowTradingOnPrepostMarket = 364
   , PFFieldMaxGrossLost = 365
   , PFFieldMaxDayVolume = 366
   , PFFieldMaxOrdersPerDay = 367
   , PFFieldMaxPositions = 368
   , PFFieldMaxPendingOrders = 369
   , PFFieldMaxOrderCapital = 370
   , PFFieldMaxLot = 371
   , PFFieldMaxPositionQtyPerSymbol = 372
   , PFFieldStopTradingReason = 373
   , PFFieldOpenCrossPrice = 374
   , PFFieldUseSameCrosspriceforOpenClose = 375
   , PFFieldIsDelay = 376
   , PFFieldDelayPeriod = 377
   , PFFieldSessionDayTemplate = 378
   , PFFieldSessionDayPeriod = 379
   , PFFieldSessionPeriodType = 380
   , PFFieldSessionSubPeriodType = 381
   , PFFieldSessiosnIsIntraday = 382
   , PFFieldSessionAllowedOrderTypes = 383
   , PFFieldSessionAllowedOperations = 384
   , PFFieldDayIndex = 385
   , PFFieldTradeSessionId = 386
   , PFFieldInitMargingsizeOvernight = 387
   , PFFieldHoldMargingsizeOvernight = 388
   , PFFieldInitMargingsizeShort = 389
   , PFFieldHoldMargingsizeShort = 390
   , PFFieldInitMargingsizeOvernightShort = 391
   , PFFieldHoldMargingsizeOvernightShort = 392
   , PFFieldUseOvernightMargin = 393
   , PFFieldUseLongshortMargin = 394
   , PFFieldAllowOvernightTrading = 395
   , PFFieldTradeSessionCurrentPeriodId = 396
   , PFFieldStopoutType = 397
   , PFFieldDerivativeExpirationTemlate = 398
   , PFFieldPriceLowLimit = 399
   , PFFieldPriceHiLimit = 400
   , PFFieldUseDst = 401
   , PFFieldPriceLimitMesure = 402
   , PFFieldIsDecreaseOnlyPositionCount = 403
   , PFFieldDayType = 404
   , PFFieldErrorCode = 405
   , PFFieldFirstClearingTime = 406
   , PFFieldContractSize = 407
   , PFFieldIsRemoved = 408
   , PFFieldTimeZoneId = 409
   , PFFieldOpenPreMarket = 410
   , PFFieldClosePostMarket = 411
   , PFFieldHighGeneral = 412
   , PFFieldLowGeneral = 413
   , PFFieldTicks = 414
   , PFFieldTicksPreMarket = 415
   , PFFieldTicksPostMarket = 416
   , PFFieldVolumePreMarket = 417
   , PFFieldVolumePostMarket = 418
   , PFFieldIsInvestor = 419
   , PFFieldAccountOperationId = 420
   , PFFieldOwnerType = 421
   , PFFieldVolume = 422
   , PFFieldBidVolume = 423
   , PFFieldAskVolume = 424
   , PFFieldCommissionType = 425
   , PFFieldCommissionPaymentType = 426
   , PFFieldCounterAccountId = 427
   , PFFieldCommissionActivateib = 428
   , PFFieldApplyOpertiontype = 429
   , PFFieldFromAmount = 430
   , PFFieldToAmount = 431
   , PFFieldCommissionValue = 432
   , PFFieldCommissionForTransferValue = 433
   , PFFieldSpreadPlanId = 434
   , PFFieldSettlementPrice = 435
   , PFFieldPrevSettlementPrice = 436
   , PFFieldMainClosePrice = 437
   , PFFieldInterest = 438
   , PFFieldAssetId = 439
   , PFFieldAccountType = 440
   , PFFieldTurnover = 441
   , PFFieldDeliveryMethodId = 442
   , PFFieldIsNewsRoute = 443
   , PFFieldSettlementCrossPrice = 444
   , PFFieldNodeFreeConnections = 445

   , PFFieldLongGroup = 446
   , PFFieldNotSupportedIndex
};

enum
{
   PFOrderLinkNone = -1
   , PFOrderLinkCancel = 0
   , PFOrderLinkExecuteAfter = 1
};

@interface PFField : NSObject

@property ( nonatomic, assign, readonly ) PFShort fieldId;
@property ( nonatomic, strong, readonly ) NSData* data;
@property ( nonatomic, assign, readonly ) PFInteger length;
@property ( nonatomic, strong ) NSObject* objectValue;

+(id)fieldWithId:( PFShort )field_id_;
+(NSString*)fieldNameWithId:( PFShort )field_id_;

@end

@interface PFBoolField : PFField

@property ( nonatomic, assign ) PFBool boolValue;

@end

@interface PFByteField : PFField

@property ( nonatomic, assign ) PFByte byteValue;

@end

@interface PFShortField : PFField

@property ( nonatomic, assign ) PFShort shortValue;

@end

@interface PFIntegerField : PFField

@property ( nonatomic, assign ) PFInteger integerValue;

@end

@interface PFLongField : PFField

@property ( nonatomic, assign ) PFLong longValue;

@end

@interface PFStringField : PFField

@property ( nonatomic, strong ) NSString* stringValue;

@end

@interface PFArrayField : PFStringField

@property ( nonatomic, strong ) NSArray* arrayValue;

@end

@interface PFFloatField : PFField

@property ( nonatomic, assign ) PFFloat floatValue;

@end

@interface PFDoubleField : PFField

@property ( nonatomic, assign ) PFDouble doubleValue;

@end

@interface PFDateField : PFField

@property ( nonatomic, strong ) NSDate* dateValue;

@end

@interface PFSignatureField : PFField

@end

@interface PFPublicKeyField : PFField

@end

@interface PFMessageField : PFField

@end

@interface PFDataField : PFField

@property ( nonatomic, strong ) NSData* dataValue;

@end

enum
{
     PFGroupOrder = 1
   , PFGroupFieldSubscribe = 2
   , PFGroupLine = 3
   , PFNewsrequestIds = 4
   , PFNewsrequestKeywords = 5
   , PFGroupOrderId = 6
   , PFGroupPrice = 7
   , PFGroupAccountBrokerIds = 8
   , PFGroupInstrumentBrokerIds = 9
   , PFGroupNews = 10
   , PFGroupKeyValueBean = 11
   , PFGroupTradeServerInfo = 12
   , PFGroupInstrument = 13
   , PFGroupRouteId = 14
   , PFGroupPammFuture = 15
   , PFGroupPammInvestor = 16
   , PFGroupPammInvestorHistory = 17
   , PFGroupPammRequest = 18
   , PFGroupPammGain = 19
   , PFGroupSession = 20
   , PFGroupPammStatistics = 21
   , PFGroupHistoryFileInfo = 22
   , PFGroupQuoteBar = 23
   , PFGroupBeanKeyValueAggregate = 25
   , PFGroupExpiration = 26
   , PFGroupSpreadLevel = 27
   , PFGroupCommissionLevel = 28
   , PFGroupMargin = 29
   , PFGroupClusterNode = 30
};

@class PFFieldOwner;

@interface PFGroupField : PFField

@property ( nonatomic, assign ) PFInteger groupId;
@property ( nonatomic, strong, readonly ) NSArray* fields;
@property ( nonatomic, strong, readonly ) PFFieldOwner* fieldOwner;

+(id)groupWithId:( PFInteger )group_id_;

-(void)addField:( PFField* )field_;

-(id)fieldWithId:( PFShort )id_;
-(id)writeFieldWithId:( PFShort )id_;

-(NSArray*)groupFieldsWithId:( PFInteger )group_id_;
-(PFGroupField*)writeGroupFieldWithId:( PFInteger )group_id_;

@end

@interface PFGroupLongField : PFGroupField

//Для новостей

@end
