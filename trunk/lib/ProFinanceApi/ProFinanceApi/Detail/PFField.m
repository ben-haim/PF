#import "PFField.h"

#import "NSArray+PFStringField.h"
#import "NSData+PFConversion.h"
#import "NSDate+PFTimeStamp.h"
#import "PFFieldOwner.h"

@interface PFField ()

@property ( nonatomic, assign ) PFShort fieldId;

@end

@implementation PFField

@synthesize fieldId;

+(NSDictionary*)classMapping
{
   static NSDictionary* mapping_ = nil;

   if ( !mapping_ )
   {
      mapping_ = @{
      @(PFFieldMessageType): [ PFShortField class ]
      , @(PFFieldXmlRequest): [ PFStringField class ]
      , @(PFFieldPfsMessage): [ PFMessageField class ]
      , @(PFFieldLogin): [ PFStringField class ]
      , @(PFFieldPassword): [ PFStringField class ]
      , @(PFFieldSessionId): [ PFStringField class ]
      , @(PFFieldId): [ PFLongField class ]
      , @(PFFieldAmount): [ PFDoubleField class ]
      , @(PFFieldAmountLong): [ PFLongField class ]
      , @(PFFieldBalance): [ PFDoubleField class ]
      , @(PFFieldCloseOrderId): [ PFIntegerField class ]
      , @(PFFieldOpenOrderId): [ PFIntegerField class ]
      , @(PFFieldDate): [ PFDateField class ]
      , @(PFFieldPrice): [ PFDoubleField class ]
      , @(PFFieldNumber): [ PFIntegerField class ]
      , @(PFFieldBoundToOrderId): [ PFIntegerField class ]
      , @(PFFieldComment): [ PFStringField class ]
      , @(PFFieldOrderId): [ PFIntegerField class ]
      , @(PFFieldRequestId): [ PFIntegerField class ]
      , @(PFFieldLotSize): [ PFLongField class ]
      , @(PFFieldPointSize): [ PFDoubleField class ]
      , @(PFFieldName): [ PFStringField class ]
      , @(PFFieldNameExp1): [ PFStringField class ]
      , @(PFFieldNameExp2): [ PFStringField class ]
      , @(PFFieldInstrumentId): [ PFIntegerField class ]
      , @(PFFieldInstrumentTypeId): [ PFIntegerField class ]
      , @(PFFieldTradeMode): [ PFByteField class ]
      , @(PFFieldDescription): [ PFStringField class ]
      , @(PFFieldBarsType): [ PFByteField class ]
      , @(PFFieldNumberOfShares): [ PFLongField class ]
      , @(PFFieldBeginDayDate): [ PFDateField class ]
      , @(PFFieldEndDayDate): [ PFDateField class ]
      , @(PFFieldRouteList): [ PFArrayField class ]
      , @(PFFieldTradeRouteList): [ PFArrayField class ]
      , @(PFFieldMarginType): [ PFIntegerField class ]
      , @(PFFieldBaseLeverageNeg): [ PFDoubleField class ]
      , @(PFFieldBaseLeveragePos): [ PFDoubleField class ]
      , @(PFFieldCounterLeverageNeg): [ PFDoubleField class ]
      , @(PFFieldCounterLeveragePos): [ PFDoubleField class ]
      , @(PFFieldHoldMarginSize): [ PFDoubleField class ]
      , @(PFFieldHoldMarginSize10): [ PFDoubleField class ]
      , @(PFFieldHoldMarginSize25): [ PFDoubleField class ]
      , @(PFFieldHoldMarginSize50): [ PFDoubleField class ]
      , @(PFFieldInitMarginSize): [ PFDoubleField class ]
      , @(PFFieldInitMarginSize10): [ PFDoubleField class ]
      , @(PFFieldInitMarginSize25): [ PFDoubleField class ]
      , @(PFFieldInitMarginSize50): [ PFDoubleField class ]
      , @(PFFieldUseLeverage): [ PFByteField class ]
      , @(PFFieldMarginCoef): [ PFDoubleField class ]
      , @(PFFieldSwapBuy): [ PFDoubleField class ]
      , @(PFFieldSwapSell): [ PFDoubleField class ]
      , @(PFFieldSwapMeasure): [ PFIntegerField class ]
      , @(PFFieldType): [ PFByteField class ]
      , @(PFFieldBaseInstrumentID): [ PFIntegerField class ]
      , @(PFFieldFormulaType): [ PFIntegerField class ]
      , @(PFFieldStrikeIncrement): [ PFDoubleField class ]
      , @(PFFieldStrikeNumber): [ PFIntegerField class ]
      , @(PFFieldFirstBaseStrikePrice): [ PFDoubleField class ]
      , @(PFFieldStartTime): [ PFDateField class ]
      , @(PFFieldExpirationPeriodNum): [ PFIntegerField class ]
      , @(PFFieldExpirationPeriodDuration): [ PFIntegerField class ]
      , @(PFFieldExpDates): [ PFStringField class ]
      , @(PFFieldStrikePrices): [ PFStringField class ]
      , @(PFFieldMarginMode): [ PFByteField class ]
      , @(PFFieldSpreadMode): [ PFIntegerField class ]
      , @(PFFieldSpreadMeasure): [ PFIntegerField class ]
      , @(PFFieldSpread): [ PFDoubleField class ]
      , @(PFFieldBidShift): [ PFDoubleField class ]
      , @(PFFieldAskShift): [ PFDoubleField class ]
      , @(PFFieldIsHedgedMarginSize): [ PFByteField class ]
      , @(PFFieldBeginPreSesDate): [ PFDateField class ]
      , @(PFFieldEndPostSesDate): [ PFDateField class ]
      , @(PFFieldIsOptions): [ PFBoolField class ]
      , @(PFFieldGroup): [ PFGroupField class ]
      , @(PFFieldOrderType): [ PFByteField class ]
      , @(PFFieldOperationType): [ PFByteField class ]
      , @(PFFieldIsIrrevocable): [ PFBoolField class ]
      , @(PFFieldIsByBroker): [ PFBoolField class ]
      , @(PFFieldValidity): [ PFByteField class ]
      , @(PFFieldExpDay): [ PFByteField class ]
      , @(PFFieldExpMonth): [ PFByteField class ]
      , @(PFFieldExpYear): [ PFShortField class ]
      , @(PFFieldStrikePrice): [ PFDoubleField class ]
      , @(PFFieldOptionType): [ PFByteField class ]
      , @(PFFieldRouteId): [ PFIntegerField class ]
      , @(PFFieldSlPrice): [ PFDoubleField class ]
      , @(PFFieldTpPrice): [ PFDoubleField class ]
      , @(PFFieldTrOffset): [ PFDoubleField class ]
      , @(PFFieldAccountId): [ PFIntegerField class ]
      , @(PFFieldUserId): [ PFIntegerField class ]
      , @(PFFieldClientOrderId): [ PFIntegerField class ]
      , @(PFFieldSequenceId): [ PFLongField class ]
      , @(PFFieldOrderActionType): [ PFByteField class ]
      , @(PFFieldProtocolId): [ PFStringField class ]
      , @(PFFieldVerificationPassword): [ PFStringField class ]
      , @(PFFieldDateOfBuild): [ PFStringField class ]
      , @(PFFieldConnectionMode): [ PFIntegerField class ]
      , @(PFFieldClientType): [ PFIntegerField class ]
      , @(PFFieldFirstName): [ PFStringField class ]
      , @(PFFieldLastName): [ PFStringField class ]
      , @(PFFieldMiddleName): [ PFStringField class ]
      , @(PFFieldStreetAddress): [ PFStringField class ]
      , @(PFFieldCity): [ PFStringField class ]
      , @(PFFieldCountry): [ PFStringField class ]
      , @(PFFieldZip): [ PFStringField class ]
      , @(PFFieldState): [ PFStringField class ]
      , @(PFFieldAccounts): [ PFArrayField class ]
      , @(PFFieldNeedVerificationPassword): [ PFBoolField class ]
      , @(PFFieldPasswordExpired): [ PFBoolField class ]
      , @(PFFieldTimeZoneOffset): [ PFIntegerField class ]
      , @(PFFieldSubscriptionType): [ PFIntegerField class ]
      , @(PFFieldSubscriptionAction): [ PFByteField class ]
      , @(PFFieldSenderId): [ PFIntegerField class ]
      , @(PFFieldTargetId): [ PFIntegerField class ]
      , @(PFFieldText): [ PFStringField class ]
      , @(PFFieldTheme): [ PFStringField class ]
      , @(PFFieldSource): [ PFStringField class ]
      , @(PFFieldLineNumber): [ PFIntegerField class ]
      , @(PFFieldNewsId): [ PFIntegerField class ]
      , @(PFFieldSymbol): [ PFStringField class ]
      , @(PFFieldPriority): [ PFIntegerField class ]
      , @(PFFieldIsUpperCaseSearch): [ PFBoolField class ]
      , @(PFFieldIsContentSearch): [ PFBoolField class ]
      , @(PFFieldIsEventSearch): [ PFBoolField class ]
      , @(PFFieldLightSubs): [ PFBoolField class ]
      , @(PFFieldPositionId): [ PFIntegerField class ]
      , @(PFFieldCreatedAt): [ PFDateField class ]
      , @(PFFieldActiveFlag): [ PFByteField class ]
      , @(PFFieldFilledAmount): [ PFDoubleField class ]
      , @(PFFieldAverageFilledPrice): [ PFDoubleField class ]
      , @(PFFieldOrderGroupId): [ PFIntegerField class ]
      , @(PFFieldMasterId): [ PFIntegerField class ]
      , @(PFFieldStopPrice): [ PFDoubleField class ]
      , @(PFFieldReferenceId): [ PFStringField class ]
      , @(PFFieldOrderStatus): [ PFIntegerField class ]
      , @(PFFieldOpenPrice): [ PFDoubleField class ]
      , @(PFFieldClosePrice): [ PFDoubleField class ]
      , @(PFFieldSwap): [ PFDoubleField class ]
      , @(PFFieldSlOrderId): [ PFIntegerField class ]
      , @(PFFieldTpOrderId): [ PFIntegerField class ]
      , @(PFFieldCloseTime): [ PFDateField class ]
      , @(PFFieldCommission): [ PFDoubleField class ]
      , @(PFFieldIsTrailing): [ PFBoolField class ]
      , @(PFFieldLastOrderId): [ PFIntegerField class ]
      , @(PFFieldTradeId): [ PFIntegerField class ]
      , @(PFFieldPnl): [ PFDoubleField class ]
      , @(PFFieldExtId): [ PFStringField class ]
      , @(PFFieldCreatorName): [ PFStringField class ]
      , @(PFFieldExternalPrice): [ PFDoubleField class ]
      , @(PFFieldIsBuy): [ PFBoolField class ]
      , @(PFFieldExchange): [ PFStringField class ]
      , @(PFFieldIsOpen): [ PFBoolField class ]
      , @(PFFieldRange): [ PFDoubleField class ]
      , @(PFFieldXmlBody): [ PFStringField class ]
      , @(PFFieldServerIds): [ PFArrayField class ]
      , @(PFFieldHolidays): [ PFStringField class ]
      , @(PFFieldAllowDay): [ PFBoolField class ]
      , @(PFFieldAllowGtc): [ PFBoolField class ]
      , @(PFFieldAllowGtd): [ PFBoolField class ]
      , @(PFFieldAllowIoc): [ PFBoolField class ]
      , @(PFFieldAllowMarket): [ PFBoolField class ]
      , @(PFFieldAllowMoc): [ PFBoolField class ]
      , @(PFFieldAllowStop): [ PFBoolField class ]
      , @(PFFieldAllowLimit): [ PFBoolField class ]
      , @(PFFieldAllowStopToLimit): [ PFBoolField class ]
      , @(PFFieldAllowTrailingStop): [ PFBoolField class ]
      , @(PFFieldAllowTradeStatus): [ PFBoolField class ]
      , @(PFFieldCommissionPlanId): [ PFIntegerField class ]
      , @(PFFieldAllowMoo): [ PFBoolField class ]
      , @(PFFieldIsMarginCall): [ PFBoolField class ]
      , @(PFFieldIsPreMargin): [ PFBoolField class ]
      , @(PFFieldGroupId): [ PFIntegerField class ]
      , @(PFFieldLeverage): [ PFDoubleField class ]
      , @(PFFieldCurrency): [ PFStringField class ]
      , @(PFFieldCrossType): [ PFByteField class ]
      , @(PFFieldCrossInstrumentId): [ PFIntegerField class ]
      , @(PFFieldBlockedSum): [ PFDoubleField class ]
      , @(PFFieldMinChange): [ PFDoubleField class ]
      , @(PFFieldTradingLevel): [ PFDoubleField class ]
      , @(PFFieldWarningLevel): [ PFDoubleField class ]
      , @(PFFieldMarginLevel): [ PFDoubleField class ]
      , @(PFFieldBrokerId): [ PFIntegerField class ]
      , @(PFFieldBeginBalance): [ PFDoubleField class ]
      , @(PFFieldLockedForOrders): [ PFDoubleField class ]
      , @(PFFieldCommunity): [ PFStringField class ]
      , @(PFFieldSubscribePlanId): [ PFIntegerField class ]
      , @(PFFieldBid): [ PFDoubleField class ]
      , @(PFFieldAsk): [ PFDoubleField class ]
      , @(PFFieldBidSize): [ PFIntegerField class ]
      , @(PFFieldAskSize): [ PFIntegerField class ]
      , @(PFFieldOpen): [ PFDoubleField class ]
      , @(PFFieldHigh): [ PFDoubleField class ]
      , @(PFFieldLow): [ PFDoubleField class ]
      , @(PFFieldPreClose): [ PFDoubleField class ]
      , @(PFFieldLastPrice): [ PFDoubleField class ]
      , @(PFFieldVolumeTotal): [ PFDoubleField class ]
      , @(PFFieldBidId): [ PFStringField class ]
      , @(PFFieldAskId): [ PFStringField class ]
      , @(PFFieldQuoteId): [ PFStringField class ]
      , @(PFFieldSide): [ PFByteField class ]
      , @(PFFieldSize): [ PFLongField class ]
      , @(PFFieldDayTradeVolume): [ PFDoubleField class ]
      , @(PFFieldOnBehalfUserId): [ PFIntegerField class ]
      , @(PFFieldSuperId): [ PFIntegerField class ]
      , @(PFFieldSortId): [ PFIntegerField class ]
      , @(PFFieldIsOpenPriceInMargin): [ PFBoolField class ]
      , @(PFFieldIsMaster): [ PFBoolField class ]
      , @(PFFieldLastSize): [ PFDoubleField class ]
      , @(PFFieldCrossPrice): [ PFDoubleField class ]
      , @(PFFieldIsClosed): [ PFBoolField class ]
      , @(PFFieldUnderlier): [ PFStringField class ]
      , @(PFFieldOrderRefId): [ PFStringField class ]
      , @(PFFieldTimestamp): [ PFDateField class ]//?Not clear in csharp code
      , @(PFFieldTextMessageType): [ PFIntegerField class ]
      , @(PFFieldBrokerIds): [ PFStringField class ]
      , @(PFFieldIsLock): [ PFBoolField class ]
      , @(PFFieldNewsCategory): [ PFStringField class ]
      , @(PFFieldNewPassword): [ PFStringField class ]
      , @(PFFieldMode): [ PFIntegerField class ]
      , @(PFFieldIsMd5): [ PFBoolField class ]
      , @(PFFieldAccs): [ PFStringField class ]
      , @(PFFieldInstrumentList): [ PFStringField class ]
      , @(PFFieldRulesList): [ PFStringField class ]
      , @(PFFieldReports): [ PFStringField class ]
      , @(PFFieldIsPwdExpired): [ PFBoolField class ]
      , @(PFFieldPhone): [ PFStringField class ]
      , @(PFFieldPhonePwd): [ PFStringField class ]
      , @(PFFieldEmail): [ PFStringField class ]
      , @(PFFieldIsBlocked): [ PFBoolField class ]
      , @(PFFieldValue): [ PFStringField class ]
      , @(PFFieldKey): [ PFStringField class ]
      , @(PFFieldTemplate): [ PFStringField class ]
      , @(PFFieldDerivativePositionId): [ PFIntegerField class ]
      , @(PFFieldIsDeposit): [ PFBoolField class ]
      , @(PFFieldPageNum): [ PFIntegerField class ]
      , @(PFFieldMaxRow): [ PFIntegerField class ]
      , @(PFFieldTableName): [ PFStringField class ]
      , @(PFFieldFingerPrint): [ PFStringField class ]
      , @(PFFieldSignature): [ PFSignatureField class ]
      , @(PFFieldAccountState): [ PFByteField class ]
      , @(PFFieldTodayFees): [ PFDoubleField class ]
      , @(PFFieldMinimalLot): [ PFDoubleField class ]
      , @(PFFieldLotStep): [ PFDoubleField class ]
      , @(PFFieldPublicKey): [ PFPublicKeyField class ]
      , @(PFFieldExpireAt): [ PFDateField class ]
      , @(PFFieldLockedForPamm): [ PFDoubleField class ]
      , @(PFFieldAllowFok): [ PFBoolField class ]
      , @(PFFieldMaxFieldIndex): [ PFIntegerField class ]
      , @(PFFieldTypeModification): [ PFBoolField class ]
      , @(PFFieldAmountModification): [ PFBoolField class ]
      , @(PFFieldTifModification): [ PFBoolField class ]
      , @(PFFieldPriceModification): [ PFBoolField class ]
      , @(PFFieldOperationTypeModification): [ PFBoolField class ]
      , @(PFFieldExpirationDateModification): [ PFBoolField class ]
      , @(PFFieldTifsForOrderTypes): [ PFStringField class ]
      , @(PFFieldClearingSpan): [ PFStringField class ]
      , @(PFFieldInvestmentSpan): [ PFStringField class ]
      , @(PFFieldManualCofirm): [ PFBoolField class ]
      , @(PFFieldLiquidationLevel): [ PFDoubleField class ]
      , @(PFFieldRewardAlgorithm): [ PFStringField class ]
      , @(PFFieldRewardFromTotal): [ PFBoolField class ]
      , @(PFFieldGovernorAccountId): [ PFIntegerField class ]
      , @(PFFieldTradingVisible): [ PFBoolField class ]
      , @(PFFieldGrossPnl): [ PFDoubleField class ]
      , @(PFFieldReinvestCycles): [ PFIntegerField class ]
      , @(PFFieldReinvestProfit): [ PFBoolField class ]
      , @(PFFieldSlExpireAt): [ PFDateField class ]
      , @(PFFieldTpExpireAt): [ PFDateField class ]
      , @(PFFieldOrderLinkType): [ PFIntegerField class ]
      , @(PFFieldClientOrderIdToLink): [ PFIntegerField class ]
      , @(PFFieldSessionDescr): [ PFStringField class ]
      , @(PFFieldSessionBegin): [ PFDateField class ]
      , @(PFFieldSessionEnd): [ PFDateField class ]
      , @(PFFieldSessionType): [ PFIntegerField class ]
      , @(PFFieldTradeCount): [ PFIntegerField class ]
      , @(PFFieldCashBalance): [ PFDoubleField class ]
      , @(PFFieldPrecision): [ PFByteField class ]
      , @(PFFieldRolloverSpan): [ PFStringField class ]
      , @(PFFieldPositionCloserSetup): [ PFStringField class ]
      , @(PFFieldFundType): [ PFByteField class ]
      , @(PFFieldAccountIdOfUser): [ PFIntegerField class ]
      , @(PFFieldIsSigned): [ PFBoolField class ]
      , @(PFFieldMinimalShareCount): [ PFLongField class ]
      , @(PFFieldMonthAvgGrossPerShare): [ PFDoubleField class ]
      , @(PFFieldOpenPrice1Month): [ PFDoubleField class ]
      , @(PFFieldOpenPrice3Month): [ PFDoubleField class ]
      , @(PFFieldOpenPrice6Month): [ PFDoubleField class ]
      , @(PFFieldOpenPrice1Year): [ PFDoubleField class ]
      , @(PFFieldAvgDayPriceChange): [ PFDoubleField class ]
      , @(PFFieldAvgMonthPriceChange): [ PFDoubleField class ]
      , @(PFFieldAnnualGain): [ PFDoubleField class ]
      , @(PFFieldAvgExposure): [ PFDoubleField class ]
      , @(PFFieldMaxDrawDown): [ PFDoubleField class ]
      , @(PFFieldMaxDrawDownDate): [ PFDateField class ]
      , @(PFFieldRecoveryFactor): [ PFDoubleField class ]
      , @(PFFieldPayoffRatio): [ PFDoubleField class ]
      , @(PFFieldSharpeRatio): [ PFDoubleField class ]
      , @(PFFieldValueAtRisk): [ PFDoubleField class ]
      , @(PFFieldSortingRatioR): [ PFDoubleField class ]
      , @(PFFieldSortingRatioG): [ PFDoubleField class ]
      , @(PFFieldProfitFactor): [ PFDoubleField class ]
      , @(PFFieldDays): [ PFIntegerField class ]
      , @(PFFieldRawBytes): [ PFDataField class ]
      , @(PFFieldEndTime): [ PFDateField class ]
      , @(PFFieldVersion): [ PFIntegerField class ]
      , @(PFFieldIsCompressed): [ PFBoolField class ]
      , @(PFFieldHistoryPeriodType): [ PFShortField class ]
      , @(PFFieldPointer): [ PFLongField class ]
      , @(PFFieldTickCost): [ PFDoubleField class ]
      , @(PFFieldCounterId): [ PFIntegerField class ]
      , @(PFFieldAllowMamOrders): [ PFBoolField class ]
      , @(PFFieldReservedBalance): [ PFDoubleField class ]
      , @(PFFieldIsAutotradeOrder): [ PFBoolField class ]
      , @(PFFieldSlTrOffset): [ PFDoubleField class ]
      , @(PFFieldHedgedMarginCallCoefficient): [ PFDoubleField class ]
      , @(PFFieldIsOk): [ PFBoolField class ]
      , @(PFFieldUsedMargin): [ PFDoubleField class ]
      , @(PFFieldOpenInterest): [ PFLongField class ]
      , @(PFFieldContractMonthDate): [ PFDateField class ]
      , @(PFFieldLastTradeDate): [ PFDateField class ]
      , @(PFFieldSettlementDate): [ PFDateField class ]
      , @(PFFieldNoticeDate): [ PFDateField class ]
      , @(PFFieldFirstTradeDate): [ PFDateField class ]
      , @(PFFieldAutoCloseDate): [ PFDateField class ]
      , @(PFFieldIndicativeAuctionPrice): [ PFDoubleField class ]
      , @(PFFieldDeliveryStatus): [ PFIntegerField class ]
      , @(PFFieldPerOrderPrice): [ PFDoubleField class ]
      , @(PFFieldFreeCommisionAmount): [ PFDoubleField class ]
      , @(PFFieldDealerCommisoin): [ PFDoubleField class ]
      , @(PFFieldMaxPerOrder): [ PFDoubleField class ]
      , @(PFFieldMinPerOrder): [ PFDoubleField class ]
      , @(PFFieldDeliveryMethod): [ PFStringField class ]
      , @(PFFieldQuoteRouteId): [ PFIntegerField class ]
      , @(PFFieldLastAmount):[ PFDoubleField class ]
      , @(PFFieldIsContiniousContract): [ PFBoolField class ]
      , @(PFFieldManualConfirmExit): [ PFBoolField class ]
      , @(PFFieldCreditValue): [ PFDoubleField class ]
      , @(PFFieldManagerShareCount): [ PFLongField class ]
      , @(PFFieldManagerCapital): [ PFDoubleField class ]
      , @(PFFieldInvestorCount): [ PFIntegerField class ]
      , @(PFFieldValuedDateBasis): [ PFByteField class ]
      , @(PFFieldOperationMode): [ PFByteField class ]
      , @(PFFieldBuyInit): [ PFDoubleField class ]
      , @(PFFieldBuySupp): [ PFDoubleField class ]
      , @(PFFieldSellInit): [ PFDoubleField class ]
      , @(PFFieldSellSupp): [ PFDoubleField class ]
      , @(PFFieldLogonForTrade): [ PFBoolField class ]
      , @(PFFieldQuoteDelay): [ PFIntegerField class ]
      , @(PFFieldNodeId): [ PFIntegerField class ]
      , @(PFFieldNodeReportTable): [ PFBoolField class ]
      , @(PFFieldAdressProtocol): [ PFByteField class ]
      , @(PFFieldIsHostNode): [ PFBoolField class ]
      , @(PFFieldNodeLoad): [ PFIntegerField class ]
      , @(PFFieldLastRolloverTime): [ PFDateField class ]
      , @(PFFieldNextRolloverTime): [ PFDateField class ]
      , @(PFFieldChangePasswordStatus): [ PFByteField class ]

      , @(PFFieldAvailableMargin): [ PFDoubleField class ]
      , @(PFFieldMaintanceMargin): [ PFDoubleField class ]
      , @(PFFieldDeficiencyMargin): [ PFDoubleField class ]
      , @(PFFieldSurplusMargin): [ PFDoubleField class ]
      , @(PFFieldIntradayRiskManagement): [ PFBoolField class ]
      , @(PFFieldAccountTradeStatus): [ PFByteField class ]
      , @(PFFieldAllowTradingOnPrepostMarket): [ PFBoolField class ]
      , @(PFFieldMaxGrossLost): [ PFDoubleField class ]
      , @(PFFieldMaxDayVolume): [ PFDoubleField class ]
      , @(PFFieldMaxOrdersPerDay): [ PFIntegerField class ]
      , @(PFFieldMaxPositions): [ PFIntegerField class ]
      , @(PFFieldMaxPendingOrders): [ PFIntegerField class ]
      , @(PFFieldMaxOrderCapital): [ PFDoubleField class ]
      , @(PFFieldMaxLot): [ PFIntegerField class ]
      , @(PFFieldMaxPositionQtyPerSymbol): [ PFIntegerField class ]
      , @(PFFieldStopTradingReason): [ PFByteField class ]
      , @(PFFieldOpenCrossPrice): [ PFDoubleField class ]
      , @(PFFieldUseSameCrosspriceforOpenClose): [ PFBoolField class ]
      , @(PFFieldIsDelay): [ PFBoolField class ]
      , @(PFFieldDelayPeriod): [ PFIntegerField class ]
      , @(PFFieldSessionDayTemplate): [ PFByteField class ]
      , @(PFFieldSessionDayPeriod): [ PFByteField class ]
      , @(PFFieldSessionPeriodType): [ PFByteField class ]
      , @(PFFieldSessionSubPeriodType): [ PFByteField class ]
      , @(PFFieldSessiosnIsIntraday): [ PFBoolField class ]
      , @(PFFieldSessionAllowedOrderTypes): [ PFStringField class ]
      , @(PFFieldSessionAllowedOperations): [ PFStringField class ]
      , @(PFFieldDayIndex): [ PFIntegerField class ]
      , @(PFFieldTradeSessionId): [ PFIntegerField class ]
      , @(PFFieldInitMargingsizeOvernight): [ PFDoubleField class ]
      , @(PFFieldHoldMargingsizeOvernight): [ PFDoubleField class ]
      , @(PFFieldInitMargingsizeShort): [ PFDoubleField class ]
      , @(PFFieldHoldMargingsizeShort): [ PFDoubleField class ]
      , @(PFFieldInitMargingsizeOvernightShort): [ PFDoubleField class ]
      , @(PFFieldHoldMargingsizeOvernightShort): [ PFDoubleField class ]
      , @(PFFieldUseOvernightMargin): [ PFBoolField class ]
      , @(PFFieldUseLongshortMargin): [ PFBoolField class ]
      , @(PFFieldAllowOvernightTrading): [ PFBoolField class ]
      , @(PFFieldTradeSessionCurrentPeriodId): [ PFIntegerField class ]
      , @(PFFieldStopoutType): [ PFIntegerField class ]
      , @(PFFieldDerivativeExpirationTemlate): [ PFIntegerField class ]
      , @(PFFieldPriceLowLimit): [ PFDoubleField class ]
      , @(PFFieldPriceHiLimit): [ PFDoubleField class ]
      , @(PFFieldUseDst): [ PFBoolField class ]
      , @(PFFieldPriceLimitMesure): [ PFByteField class ]
      , @(PFFieldIsDecreaseOnlyPositionCount): [ PFBoolField class ]
      , @(PFFieldDayType): [ PFByteField class ]
      , @(PFFieldErrorCode): [ PFShortField class ]
      , @(PFFieldFirstClearingTime): [ PFDateField class ]
      , @(PFFieldContractSize): [ PFLongField class ]
      , @(PFFieldIsRemoved): [ PFBoolField class ]
      , @(PFFieldTimeZoneId): [ PFStringField class ]
      , @(PFFieldOpenPreMarket): [ PFDoubleField class ]
      , @(PFFieldClosePostMarket): [ PFDoubleField class ]
      , @(PFFieldHighGeneral): [ PFDoubleField class ]
      , @(PFFieldLowGeneral): [ PFDoubleField class ]
      , @(PFFieldTicks): [ PFLongField class ]
      , @(PFFieldTicksPreMarket): [ PFLongField class ]
      , @(PFFieldTicksPostMarket): [ PFLongField class ]
      , @(PFFieldVolumePreMarket): [ PFDoubleField class ]
      , @(PFFieldVolumePostMarket): [ PFDoubleField class ]
      , @(PFFieldIsInvestor): [ PFBoolField class ]
      , @(PFFieldAccountOperationId): [ PFIntegerField class ]
      , @(PFFieldOwnerType): [ PFIntegerField class ]
      , @(PFFieldVolume): [ PFDoubleField class ]
      , @(PFFieldBidVolume): [ PFDoubleField class ]
      , @(PFFieldAskVolume): [ PFDoubleField class ]
      , @(PFFieldCommissionType): [ PFByteField class ]
      , @(PFFieldCommissionPaymentType): [ PFByteField class ]
      , @(PFFieldCounterAccountId): [ PFIntegerField class ]
      , @(PFFieldCommissionActivateib): [ PFBoolField class ]
      , @(PFFieldApplyOpertiontype): [ PFStringField class ]
      , @(PFFieldFromAmount): [ PFIntegerField class ]
      , @(PFFieldToAmount): [ PFIntegerField class ]
      , @(PFFieldCommissionValue): [ PFDoubleField class ]
      , @(PFFieldCommissionForTransferValue): [ PFDoubleField class ]
      , @(PFFieldSpreadPlanId): [ PFIntegerField class ]
      , @(PFFieldSettlementPrice): [ PFDoubleField class ]
      , @(PFFieldPrevSettlementPrice): [ PFDoubleField class ]
      , @(PFFieldMainClosePrice): [ PFDoubleField class ]
      , @(PFFieldInterest): [ PFDoubleField class ]
      , @(PFFieldAssetId): [ PFIntegerField class ]
      , @(PFFieldAccountType): [ PFByteField class ]
      , @(PFFieldTurnover): [ PFDoubleField class ]
      , @(PFFieldDeliveryMethodId): [ PFByteField class ]
      , @(PFFieldIsNewsRoute): [ PFBoolField class ]
      , @(PFFieldSettlementCrossPrice): [ PFDoubleField class ]
      , @(PFFieldNodeFreeConnections): [ PFIntegerField class ]
      , @(PFFieldLongGroup): [ PFGroupLongField class ]
      };
   }

   return mapping_;
}

+(NSString*)fieldNameWithId:( PFShort )field_id_
{
   static NSDictionary* names_mapping_ = nil;
   
   if ( !names_mapping_ )
   {
      names_mapping_ = @{
                         @(PFFieldMessageType): @"MessageType"
                         , @(PFFieldXmlRequest): @"XmlRequest"
                         , @(PFFieldPfsMessage): @"PfsMessage"
                         , @(PFFieldLogin): @"Login"
                         , @(PFFieldPassword): @"Password"
                         , @(PFFieldSessionId): @"SessionId"
                         , @(PFFieldId): @"Id"
                         , @(PFFieldAmount): @"Amount"
                         , @(PFFieldAmountLong): @"AmountLong"
                         , @(PFFieldBalance): @"Balance"
                         , @(PFFieldCloseOrderId): @"CloseOrderId"
                         , @(PFFieldOpenOrderId): @"OpenOrderId"
                         , @(PFFieldDate): @"Date"
                         , @(PFFieldPrice): @"Price"
                         , @(PFFieldNumber): @"Number"
                         , @(PFFieldBoundToOrderId): @"BoundToOrderId"
                         , @(PFFieldComment): @"Comment"
                         , @(PFFieldOrderId): @"OrderId"
                         , @(PFFieldRequestId): @"RequestId"
                         , @(PFFieldLotSize): @"LotSize"
                         , @(PFFieldPointSize): @"PointSize"
                         , @(PFFieldName): @"Name"
                         , @(PFFieldNameExp1): @"NameExp1"
                         , @(PFFieldNameExp2): @"NameExp2"
                         , @(PFFieldInstrumentId): @"InstrumentId"
                         , @(PFFieldInstrumentTypeId): @"InstrumentTypeId"
                         , @(PFFieldTradeMode): @"TradeMode"
                         , @(PFFieldDescription): @"Description"
                         , @(PFFieldBarsType): @"BarsType"
                         , @(PFFieldNumberOfShares): @"NumberOfShares"
                         , @(PFFieldBeginDayDate): @"BeginDayDate"
                         , @(PFFieldEndDayDate): @"EndDayDate"
                         , @(PFFieldRouteList): @"RouteList"
                         , @(PFFieldTradeRouteList): @"TradeRouteList"
                         , @(PFFieldMarginType): @"MarginType"
                         , @(PFFieldBaseLeverageNeg): @"BaseLeverageNeg"
                         , @(PFFieldBaseLeveragePos): @"BaseLeveragePos"
                         , @(PFFieldCounterLeverageNeg): @"CounterLeverageNeg"
                         , @(PFFieldCounterLeveragePos): @"CounterLeveragePos"
                         , @(PFFieldHoldMarginSize): @"HoldMarginSize"
                         , @(PFFieldHoldMarginSize10): @"HoldMarginSize10"
                         , @(PFFieldHoldMarginSize25): @"HoldMarginSize25"
                         , @(PFFieldHoldMarginSize50): @"HoldMarginSize50"
                         , @(PFFieldInitMarginSize): @"InitMarginSize"
                         , @(PFFieldInitMarginSize10): @"InitMarginSize10"
                         , @(PFFieldInitMarginSize25): @"InitMarginSize25"
                         , @(PFFieldInitMarginSize50): @"InitMarginSize50"
                         , @(PFFieldUseLeverage): @"UseLeverage"
                         , @(PFFieldMarginCoef): @"MarginCoef"
                         , @(PFFieldSwapBuy): @"SwapBuy"
                         , @(PFFieldSwapSell): @"SwapSell"
                         , @(PFFieldSwapMeasure): @"SwapMeasure"
                         , @(PFFieldType): @"Type"
                         , @(PFFieldBaseInstrumentID): @"BaseInstrumentID"
                         , @(PFFieldFormulaType): @"FormulaType"
                         , @(PFFieldStrikeIncrement): @"StrikeIncrement"
                         , @(PFFieldStrikeNumber): @"StrikeNumber"
                         , @(PFFieldFirstBaseStrikePrice): @"FirstBaseStrikePrice"
                         , @(PFFieldStartTime): @"StartTime"
                         , @(PFFieldExpirationPeriodNum): @"ExpirationPeriodNum"
                         , @(PFFieldExpirationPeriodDuration): @"ExpirationPeriodDuration"
                         , @(PFFieldExpDates): @"ExpDates"
                         , @(PFFieldStrikePrices): @"StrikePrices"
                         , @(PFFieldMarginMode): @"MarginMode"
                         , @(PFFieldSpreadMode): @"SpreadMode"
                         , @(PFFieldSpreadMeasure): @"SpreadMeasure"
                         , @(PFFieldSpread): @"Spread"
                         , @(PFFieldBidShift): @"BidShift"
                         , @(PFFieldAskShift): @"AskShift"
                         , @(PFFieldIsHedgedMarginSize): @"IsHedgedMarginSize"
                         , @(PFFieldBeginPreSesDate): @"BeginPreSesDate"
                         , @(PFFieldEndPostSesDate): @"EndPostSesDate"
                         , @(PFFieldIsOptions): @"IsOptions"
                         , @(PFFieldGroup): @"Group"
                         , @(PFFieldOrderType): @"OrderType"
                         , @(PFFieldOperationType): @"OperationType"
                         , @(PFFieldIsIrrevocable): @"IsIrrevocable"
                         , @(PFFieldIsByBroker): @"IsByBroker"
                         , @(PFFieldValidity): @"Validity"
                         , @(PFFieldExpDay): @"ExpDay"
                         , @(PFFieldExpMonth): @"ExpMonth"
                         , @(PFFieldExpYear): @"ExpYear"
                         , @(PFFieldStrikePrice): @"StrikePrice"
                         , @(PFFieldOptionType): @"OptionType"
                         , @(PFFieldRouteId): @"RouteId"
                         , @(PFFieldSlPrice): @"SlPrice"
                         , @(PFFieldTpPrice): @"TpPrice"
                         , @(PFFieldTrOffset): @"TrOffset"
                         , @(PFFieldAccountId): @"AccountId"
                         , @(PFFieldUserId): @"UserId"
                         , @(PFFieldClientOrderId): @"ClientOrderId"
                         , @(PFFieldSequenceId): @"SequenceId"
                         , @(PFFieldOrderActionType): @"OrderActionType"
                         , @(PFFieldProtocolId): @"ProtocolId"
                         , @(PFFieldVerificationPassword): @"VerificationPassword"
                         , @(PFFieldDateOfBuild): @"DateOfBuild"
                         , @(PFFieldConnectionMode): @"ConnectionMode"
                         , @(PFFieldClientType): @"ClientType"
                         , @(PFFieldFirstName): @"FirstName"
                         , @(PFFieldLastName): @"LastName"
                         , @(PFFieldMiddleName): @"MiddleName"
                         , @(PFFieldStreetAddress): @"StreetAddress"
                         , @(PFFieldCity): @"City"
                         , @(PFFieldCountry): @"Country"
                         , @(PFFieldZip): @"Zip"
                         , @(PFFieldState): @"State"
                         , @(PFFieldAccounts): @"Accounts"
                         , @(PFFieldNeedVerificationPassword): @"NeedVerificationPassword"
                         , @(PFFieldPasswordExpired): @"PasswordExpired"
                         , @(PFFieldTimeZoneOffset): @"TimeZoneOffset"
                         , @(PFFieldSubscriptionType): @"SubscriptionType"
                         , @(PFFieldSubscriptionAction): @"SubscriptionAction"
                         , @(PFFieldSenderId): @"SenderId"
                         , @(PFFieldTargetId): @"TargetId"
                         , @(PFFieldText): @"Text"
                         , @(PFFieldTheme): @"Theme"
                         , @(PFFieldSource): @"Source"
                         , @(PFFieldLineNumber): @"LineNumber"
                         , @(PFFieldNewsId): @"NewsId"
                         , @(PFFieldSymbol): @"Symbol"
                         , @(PFFieldPriority): @"Priority"
                         , @(PFFieldIsUpperCaseSearch): @"IsUpperCaseSearch"
                         , @(PFFieldIsContentSearch): @"IsContentSearch"
                         , @(PFFieldIsEventSearch): @"IsEventSearch"
                         , @(PFFieldLightSubs): @"LightSubs"
                         , @(PFFieldPositionId): @"PositionId"
                         , @(PFFieldCreatedAt): @"CreatedAt"
                         , @(PFFieldActiveFlag): @"ActiveFlag"
                         , @(PFFieldFilledAmount): @"FilledAmount"
                         , @(PFFieldAverageFilledPrice): @"AverageFilledPrice"
                         , @(PFFieldOrderGroupId): @"OrderGroupId"
                         , @(PFFieldMasterId): @"MasterId"
                         , @(PFFieldStopPrice): @"StopPrice"
                         , @(PFFieldReferenceId): @"ReferenceId"
                         , @(PFFieldOrderStatus): @"OrderStatus"
                         , @(PFFieldOpenPrice): @"OpenPrice"
                         , @(PFFieldClosePrice): @"ClosePrice"
                         , @(PFFieldSwap): @"Swap"
                         , @(PFFieldSlOrderId): @"SlOrderId"
                         , @(PFFieldTpOrderId): @"TpOrderId"
                         , @(PFFieldCloseTime): @"CloseTime"
                         , @(PFFieldCommission): @"Commission"
                         , @(PFFieldIsTrailing): @"IsTrailing"
                         , @(PFFieldLastOrderId): @"LastOrderId"
                         , @(PFFieldTradeId): @"TradeId"
                         , @(PFFieldPnl): @"Pnl"
                         , @(PFFieldExtId): @"ExtId"
                         , @(PFFieldCreatorName): @"CreatorName"
                         , @(PFFieldExternalPrice): @"ExternalPrice"
                         , @(PFFieldIsBuy): @"IsBuy"
                         , @(PFFieldExchange): @"Exchange"
                         , @(PFFieldIsOpen): @"IsOpen"
                         , @(PFFieldRange): @"Range"
                         , @(PFFieldXmlBody): @"XmlBody"
                         , @(PFFieldServerIds): @"ServerIds"
                         , @(PFFieldHolidays): @"Holidays"
                         , @(PFFieldAllowDay): @"AllowDay"
                         , @(PFFieldAllowGtc): @"AllowGtc"
                         , @(PFFieldAllowGtd): @"AllowGtd"
                         , @(PFFieldAllowIoc): @"AllowIoc"
                         , @(PFFieldAllowMarket): @"AllowMarket"
                         , @(PFFieldAllowMoc): @"AllowMoc"
                         , @(PFFieldAllowStop): @"AllowStop"
                         , @(PFFieldAllowLimit): @"AllowLimit"
                         , @(PFFieldAllowStopToLimit): @"AllowStopToLimit"
                         , @(PFFieldAllowTrailingStop): @"AllowTrailingStop"
                         , @(PFFieldAllowTradeStatus): @"AllowTradeStatus"
                         , @(PFFieldCommissionPlanId): @"CommissionPlanId"
                         , @(PFFieldAllowMoo): @"AllowMoo"
                         , @(PFFieldIsMarginCall): @"IsMarginCall"
                         , @(PFFieldIsPreMargin): @"IsPreMargin"
                         , @(PFFieldGroupId): @"GroupId"
                         , @(PFFieldLeverage): @"Leverage"
                         , @(PFFieldCurrency): @"Currency"
                         , @(PFFieldCrossType): @"CrossType"
                         , @(PFFieldCrossInstrumentId): @"CrossInstrumentId"
                         , @(PFFieldBlockedSum): @"BlockedSum"
                         , @(PFFieldMinChange): @"MinChange"
                         , @(PFFieldTradingLevel): @"TradingLevel"
                         , @(PFFieldWarningLevel): @"WarningLevel"
                         , @(PFFieldMarginLevel): @"MarginLevel"
                         , @(PFFieldBrokerId): @"BrokerId"
                         , @(PFFieldBeginBalance): @"BeginBalance"
                         , @(PFFieldLockedForOrders): @"LockedForOrders"
                         , @(PFFieldCommunity): @"Community"
                         , @(PFFieldSubscribePlanId): @"SubscribePlanId"
                         , @(PFFieldBid): @"Bid"
                         , @(PFFieldAsk): @"Ask"
                         , @(PFFieldBidSize): @"BidSize"
                         , @(PFFieldAskSize): @"AskSize"
                         , @(PFFieldOpen): @"Open"
                         , @(PFFieldHigh): @"High"
                         , @(PFFieldLow): @"Low"
                         , @(PFFieldPreClose): @"PreClose"
                         , @(PFFieldLastPrice): @"LastPrice"
                         , @(PFFieldVolumeTotal): @"VolumeTotal"
                         , @(PFFieldBidId): @"BidId"
                         , @(PFFieldAskId): @"AskId"
                         , @(PFFieldQuoteId): @"QuoteId"
                         , @(PFFieldSide): @"Side"
                         , @(PFFieldSize): @"Size"
                         , @(PFFieldDayTradeVolume): @"DayTradeVolume"
                         , @(PFFieldOnBehalfUserId): @"OnBehalfUserId"
                         , @(PFFieldSuperId): @"SuperId"
                         , @(PFFieldSortId): @"SortId"
                         , @(PFFieldIsOpenPriceInMargin): @"IsOpenPriceInMargin"
                         , @(PFFieldIsMaster): @"IsMaster"
                         , @(PFFieldLastSize): @"LastSize"
                         , @(PFFieldCrossPrice): @"CrossPrice"
                         , @(PFFieldIsClosed): @"IsClosed"
                         , @(PFFieldUnderlier): @"Underlier"
                         , @(PFFieldOrderRefId): @"OrderRefId"
                         , @(PFFieldTimestamp): @"Timestamp"
                         , @(PFFieldTextMessageType): @"TextMessageType"
                         , @(PFFieldBrokerIds): @"BrokerIds"
                         , @(PFFieldIsLock): @"IsLock"
                         , @(PFFieldNewsCategory): @"NewsCategory"
                         , @(PFFieldNewPassword): @"NewPassword"
                         , @(PFFieldMode): @"Mode"
                         , @(PFFieldIsMd5): @"IsMd5"
                         , @(PFFieldAccs): @"Accs"
                         , @(PFFieldInstrumentList): @"InstrumentList"
                         , @(PFFieldRulesList): @"RulesList"
                         , @(PFFieldReports): @"Reports"
                         , @(PFFieldIsPwdExpired): @"IsPwdExpired"
                         , @(PFFieldPhone): @"Phone"
                         , @(PFFieldPhonePwd): @"PhonePwd"
                         , @(PFFieldEmail): @"Email"
                         , @(PFFieldIsBlocked): @"IsBlocked"
                         , @(PFFieldValue): @"Value"
                         , @(PFFieldKey): @"Key"
                         , @(PFFieldTemplate): @"Template"
                         , @(PFFieldDerivativePositionId): @"DerivativePositionId"
                         , @(PFFieldIsDeposit): @"IsDeposit"
                         , @(PFFieldPageNum): @"PageNum"
                         , @(PFFieldMaxRow): @"MaxRow"
                         , @(PFFieldTableName): @"TableName"
                         , @(PFFieldFingerPrint): @"FingerPrint"
                         , @(PFFieldSignature): @"Signature"
                         , @(PFFieldAccountState): @"AccountState"
                         , @(PFFieldTodayFees): @"TodayFees"
                         , @(PFFieldMinimalLot): @"MinimalLot"
                         , @(PFFieldLotStep): @"LotStep"
                         , @(PFFieldPublicKey): @"PublicKey"
                         , @(PFFieldExpireAt): @"ExpireAt"
                         , @(PFFieldLockedForPamm): @"LockedForPamm"
                         , @(PFFieldAllowFok): @"AllowFok"
                         , @(PFFieldMaxFieldIndex): @"MaxFieldIndex"
                         , @(PFFieldTypeModification): @"TypeModification"
                         , @(PFFieldAmountModification): @"AmountModification"
                         , @(PFFieldTifModification): @"TifModification"
                         , @(PFFieldPriceModification): @"PriceModification"
                         , @(PFFieldOperationTypeModification): @"OperationTypeModification"
                         , @(PFFieldExpirationDateModification): @"ExpirationDateModification"
                         , @(PFFieldTifsForOrderTypes): @"TifsForOrderTypes"
                         , @(PFFieldClearingSpan): @"ClearingSpan"
                         , @(PFFieldInvestmentSpan): @"InvestmentSpan"
                         , @(PFFieldManualCofirm): @"ManualCofirm"
                         , @(PFFieldLiquidationLevel): @"LiquidationLevel"
                         , @(PFFieldRewardAlgorithm): @"RewardAlgorithm"
                         , @(PFFieldRewardFromTotal): @"RewardFromTotal"
                         , @(PFFieldGovernorAccountId): @"GovernorAccountId"
                         , @(PFFieldTradingVisible): @"TradingVisible"
                         , @(PFFieldGrossPnl): @"GrossPnl"
                         , @(PFFieldReinvestCycles): @"ReinvestCycles"
                         , @(PFFieldReinvestProfit): @"ReinvestProfit"
                         , @(PFFieldSlExpireAt): @"SlExpireAt"
                         , @(PFFieldTpExpireAt): @"TpExpireAt"
                         , @(PFFieldOrderLinkType): @"OrderLinkType"
                         , @(PFFieldClientOrderIdToLink): @"ClientOrderIdToLink"
                         , @(PFFieldSessionDescr): @"SessionDescr"
                         , @(PFFieldSessionBegin): @"SessionBegin"
                         , @(PFFieldSessionEnd): @"SessionEnd"
                         , @(PFFieldSessionType): @"SessionType"
                         , @(PFFieldTradeCount): @"TradeCount"
                         , @(PFFieldCashBalance): @"CashBalance"
                         , @(PFFieldPrecision): @"Precision"
                         , @(PFFieldRolloverSpan): @"RolloverSpan"
                         , @(PFFieldPositionCloserSetup): @"PositionCloserSetup"
                         , @(PFFieldFundType): @"FundType"
                         , @(PFFieldAccountIdOfUser): @"AccountIdOfUser"
                         , @(PFFieldIsSigned): @"IsSigned"
                         , @(PFFieldMinimalShareCount): @"MinimalShareCount"
                         , @(PFFieldMonthAvgGrossPerShare): @"MonthAvgGrossPerShare"
                         , @(PFFieldOpenPrice1Month): @"OpenPrice1Month"
                         , @(PFFieldOpenPrice3Month): @"OpenPrice3Month"
                         , @(PFFieldOpenPrice6Month): @"OpenPrice6Month"
                         , @(PFFieldOpenPrice1Year): @"OpenPrice1Year"
                         , @(PFFieldAvgDayPriceChange): @"AvgDayPriceChange"
                         , @(PFFieldAvgMonthPriceChange): @"AvgMonthPriceChange"
                         , @(PFFieldAnnualGain): @"AnnualGain"
                         , @(PFFieldAvgExposure): @"AvgExposure"
                         , @(PFFieldMaxDrawDown): @"MaxDrawDown"
                         , @(PFFieldMaxDrawDownDate): @"MaxDrawDownDate"
                         , @(PFFieldRecoveryFactor): @"RecoveryFactor"
                         , @(PFFieldPayoffRatio): @"PayoffRatio"
                         , @(PFFieldSharpeRatio): @"SharpeRatio"
                         , @(PFFieldValueAtRisk): @"ValueAtRisk"
                         , @(PFFieldSortingRatioR): @"SortingRatioR"
                         , @(PFFieldSortingRatioG): @"SortingRatioG"
                         , @(PFFieldProfitFactor): @"ProfitFactor"
                         , @(PFFieldDays): @"Days"
                         , @(PFFieldRawBytes): @"RawBytes"
                         , @(PFFieldEndTime): @"EndTime"
                         , @(PFFieldVersion): @"Version"
                         , @(PFFieldIsCompressed): @"IsCompressed"
                         , @(PFFieldHistoryPeriodType): @"HistoryPeriodType"
                         , @(PFFieldPointer): @"Pointer"
                         , @(PFFieldTickCost): @"TickCost"
                         , @(PFFieldCounterId): @"CounterId"
                         , @(PFFieldAllowMamOrders): @"AllowMamOrders"
                         , @(PFFieldReservedBalance): @"ReservedBalance"
                         , @(PFFieldIsAutotradeOrder): @"IsAutotradeOrder"
                         , @(PFFieldSlTrOffset): @"SlTrOffset"
                         , @(PFFieldHedgedMarginCallCoefficient): @"HedgedMarginCallCoefficient"
                         , @(PFFieldIsOk): @"IsOk"
                         , @(PFFieldUsedMargin): @"UsedMargin"
                         , @(PFFieldOpenInterest): @"OpenInterest"
                         , @(PFFieldContractMonthDate): @"ContractMonthDate"
                         , @(PFFieldLastTradeDate): @"LastTradeDate"
                         , @(PFFieldSettlementDate): @"SettlementDate"
                         , @(PFFieldNoticeDate): @"NoticeDate"
                         , @(PFFieldFirstTradeDate): @"FirstTradeDate"
                         , @(PFFieldAutoCloseDate): @"AutoCloseDate"
                         , @(PFFieldIndicativeAuctionPrice): @"IndicativeAuctionPrice"
                         , @(PFFieldDeliveryStatus): @"DeliveryStatus"
                         , @(PFFieldPerOrderPrice): @"PerOrderPrice"
                         , @(PFFieldFreeCommisionAmount): @"FreeCommisionAmount"
                         , @(PFFieldDealerCommisoin): @"DealerCommisoin"
                         , @(PFFieldMaxPerOrder): @"MaxPerOrder"
                         , @(PFFieldMinPerOrder): @"MinPerOrder"
                         , @(PFFieldDeliveryMethod): @"DeliveryMethod"
                         , @(PFFieldQuoteRouteId): @"QuoteRouteId"
                         , @(PFFieldLastAmount):@"LastAmount"
                         , @(PFFieldIsContiniousContract): @"IsContiniousContract"
                         , @(PFFieldManualConfirmExit): @"ManualConfirmExit"
                         , @(PFFieldCreditValue): @"CreditValue"
                         , @(PFFieldManagerShareCount): @"ManagerShareCount"
                         , @(PFFieldManagerCapital): @"ManagerCapital"
                         , @(PFFieldInvestorCount): @"InvestorCount"
                         , @(PFFieldValuedDateBasis): @"ValuedDateBasis"
                         , @(PFFieldOperationMode): @"OperationMode"
                         , @(PFFieldBuyInit): @"BuyInit"
                         , @(PFFieldBuySupp): @"BuySupp"
                         , @(PFFieldSellInit): @"SellInit"
                         , @(PFFieldSellSupp): @"SellSupp"
                         , @(PFFieldLogonForTrade): @"LogonForTrade"
                         , @(PFFieldQuoteDelay): @"QuoteDelay"
                         , @(PFFieldNodeId): @"NodeId"
                         , @(PFFieldNodeReportTable): @"NodeReportTable"
                         , @(PFFieldAdressProtocol): @"AdressProtocol"
                         , @(PFFieldIsHostNode): @"IsHostNode"
                         , @(PFFieldNodeLoad): @"NodeLoad"
                         , @(PFFieldLastRolloverTime): @"LastRolloverTime"
                         , @(PFFieldNextRolloverTime): @"NextRolloverTime"
                         , @(PFFieldChangePasswordStatus): @"ChangePasswordStatus"

                         , @(PFFieldAvailableMargin): @"AvailableMargin"
                         , @(PFFieldMaintanceMargin): @"MaintanceMargin"
                         , @(PFFieldDeficiencyMargin): @"DeficiencyMargin"
                         , @(PFFieldSurplusMargin): @"SurplusMargin"
                         , @(PFFieldIntradayRiskManagement): @"IntradayRiskManagement"
                         , @(PFFieldAccountTradeStatus): @"AccountTradeStatus"
                         , @(PFFieldAllowTradingOnPrepostMarket): @"AllowTradingOnPrepostMarket"
                         , @(PFFieldMaxGrossLost): @"MaxGrossLost"
                         , @(PFFieldMaxDayVolume): @"MaxDayVolume"
                         , @(PFFieldMaxOrdersPerDay): @"MaxOrdersPerDay"
                         , @(PFFieldMaxPositions): @"MaxPositions"
                         , @(PFFieldMaxPendingOrders): @"MaxPendingOrders"
                         , @(PFFieldMaxOrderCapital): @"MaxOrderCapital"
                         , @(PFFieldMaxLot): @"MaxLot"
                         , @(PFFieldMaxPositionQtyPerSymbol): @"MaxPositionQtyPerSymbol"
                         , @(PFFieldStopTradingReason): @"StopTradingReason"
                         , @(PFFieldOpenCrossPrice): @"OpenCrossPrice"
                         , @(PFFieldUseSameCrosspriceforOpenClose): @"UseSameCrosspriceforOpenClose"
                         , @(PFFieldIsDelay): @"IsDelay"
                         , @(PFFieldDelayPeriod): @"DelayPeriod"
                         , @(PFFieldSessionDayTemplate): @"SessionDayTemplate"
                         , @(PFFieldSessionDayPeriod): @"SessionDayPeriod"
                         , @(PFFieldSessionPeriodType): @"SessionPeriodType"
                         , @(PFFieldSessionSubPeriodType): @"SessionSubPeriodType"
                         , @(PFFieldSessiosnIsIntraday): @"PFBoPFFieldSessiosnIsIntradayolField"
                         , @(PFFieldSessionAllowedOrderTypes): @"SessionAllowedOrderTypes"
                         , @(PFFieldSessionAllowedOperations): @"SessionAllowedOperations"
                         , @(PFFieldDayIndex): @"DayIndex"
                         , @(PFFieldTradeSessionId): @"TradeSessionId"
                         , @(PFFieldInitMargingsizeOvernight): @"InitMargingsizeOvernight"
                         , @(PFFieldHoldMargingsizeOvernight): @"HoldMargingsizeOvernight"
                         , @(PFFieldInitMargingsizeShort): @"InitMargingsizeShort"
                         , @(PFFieldHoldMargingsizeShort): @"HoldMargingsizeShort"
                         , @(PFFieldInitMargingsizeOvernightShort): @"InitMargingsizeOvernightShort"
                         , @(PFFieldHoldMargingsizeOvernightShort): @"HoldMargingsizeOvernightShort"
                         , @(PFFieldUseOvernightMargin): @"UseOvernightMargin"
                         , @(PFFieldUseLongshortMargin): @"UseLongshortMargin"
                         , @(PFFieldAllowOvernightTrading): @"AllowOvernightTrading"
                         , @(PFFieldTradeSessionCurrentPeriodId): @"TradeSessionCurrentPeriodId"
                         , @(PFFieldStopoutType): @"StopoutType"
                         , @(PFFieldDerivativeExpirationTemlate): @"DerivativeExpirationTemlate"
                         , @(PFFieldPriceLowLimit): @"PriceLowLimit"
                         , @(PFFieldPriceHiLimit): @"PriceHiLimit"
                         , @(PFFieldUseDst): @"UseDst"
                         , @(PFFieldPriceLimitMesure): @"PriceLimitMesure"
                         , @(PFFieldIsDecreaseOnlyPositionCount): @"IsDecreaseOnlyPositionCount"
                         , @(PFFieldDayType): @"DayType"
                         , @(PFFieldErrorCode): @"PFSPFFieldErrorCodehortField"
                         , @(PFFieldFirstClearingTime): @"FirstClearingTime"
                         , @(PFFieldContractSize): @"ContractSize"
                         , @(PFFieldIsRemoved): @"IsRemoved"
                         , @(PFFieldTimeZoneId): @"TimeZoneId"
                         , @(PFFieldOpenPreMarket): @"OpenPreMarket"
                         , @(PFFieldClosePostMarket): @"ClosePostMarket"
                         , @(PFFieldHighGeneral): @"HighGeneral"
                         , @(PFFieldLowGeneral): @"LowGeneral"
                         , @(PFFieldTicks): @"Ticks"
                         , @(PFFieldTicksPreMarket): @"TicksPreMarket"
                         , @(PFFieldTicksPostMarket): @"TicksPostMarket"
                         , @(PFFieldVolumePreMarket): @"VolumePreMarket"
                         , @(PFFieldVolumePostMarket): @"VolumePostMarket"
                         , @(PFFieldIsInvestor): @"IsInvestor"
                         , @(PFFieldAccountOperationId): @"AccountOperationId"
                         , @(PFFieldOwnerType): @"OwnerType"
                         , @(PFFieldVolume): @"Volume"
                         , @(PFFieldBidVolume): @"BidVolume"
                         , @(PFFieldAskVolume): @"AskVolume"
                         , @(PFFieldCommissionType): @"CommissionType"
                         , @(PFFieldCommissionPaymentType): @"CommissionPaymentType"
                         , @(PFFieldCounterAccountId): @"CounterAccountId"
                         , @(PFFieldCommissionActivateib): @"CommissionActivateib"
                         , @(PFFieldApplyOpertiontype): @"ApplyOpertiontype"
                         , @(PFFieldFromAmount): @"FromAmount"
                         , @(PFFieldToAmount): @"ToAmount"
                         , @(PFFieldCommissionValue): @"CommissionValue"
                         , @(PFFieldCommissionForTransferValue): @"CommissionForTransferValue"
                         , @(PFFieldSpreadPlanId): @"SpreadPlanId"
                         , @(PFFieldSettlementPrice): @"SettlementPrice"
                         , @(PFFieldPrevSettlementPrice): @"PrevSettlementPrice"
                         , @(PFFieldMainClosePrice): @"MainClosePrice"
                         , @(PFFieldInterest): @"Interest"
                         , @(PFFieldAssetId): @"AssetId"
                         , @(PFFieldAccountType): @"AccountType"
                         , @(PFFieldTurnover): @"Turnover"
                         , @(PFFieldDeliveryMethodId): @"DeliveryMethodId"
                         , @(PFFieldIsNewsRoute): @"IsNewsRoute"
                         , @(PFFieldSettlementCrossPrice): @"SettlementCrossPrice"
                         , @(PFFieldNodeFreeConnections): @"NodeFreeConnections"

                         , @(PFFieldLongGroup): @"LongGroup"
                         };
   }
   
   return [ names_mapping_ objectForKey: @( field_id_ ) ];
}

+(Class)classForFieldWithId:( PFShort )field_id_
{
   Class field_class_ = [ [ self classMapping ] objectForKey: @(field_id_) ];
   NSAssert1( field_class_ != Nil, @"undefined field id: %d", field_id_ );
   return field_class_;
}

-(id)initWithId:( PFShort )field_id_
{
   self = [ super init ];
   if ( self )
   {
      self.fieldId = field_id_;
   }
   return self;
}

+(id)fieldWithId:( PFShort )field_id_
{
   Class field_class_ = [ self classForFieldWithId: field_id_ ];

   return [ [ field_class_ alloc ] initWithId: field_id_ ];
}

-(NSData*)data
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(PFInteger)length
{
   return ( PFInteger )[ self.data length ];
}

-(NSString*)valueKey
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(NSObject*)objectValue
{
   return [ self valueForKey: [ self valueKey ] ];
}

-(void)setObjectValue:( NSObject* )value_
{
   return [ self setValue: value_ forKey: [ self valueKey ] ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%@", [ PFField fieldNameWithId: self.fieldId ], self.objectValue ];
   //return [ NSString stringWithFormat: @"%d=%@", self.fieldId, self.objectValue ];
}

@end

@implementation PFBoolField

@synthesize boolValue;

-(NSData*)data
{
   return [ NSData dataWithPFBool: self.boolValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%d", [ PFField fieldNameWithId: self.fieldId ], self.boolValue ];
   //return [ NSString stringWithFormat: @"%d=%d", self.fieldId, self.boolValue ];
}

-(NSString*)valueKey
{
   return @"boolValue";
}

@end

@implementation PFByteField

@synthesize byteValue;

-(NSData*)data
{
   return [ NSData dataWithPFByte: self.byteValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%d", [ PFField fieldNameWithId: self.fieldId ], self.byteValue ];
   //return [ NSString stringWithFormat: @"%d=%d", self.fieldId, self.byteValue ];
}

-(NSString*)valueKey
{
   return @"byteValue";
}

@end

@implementation PFShortField

@synthesize shortValue;

-(NSData*)data
{
   return [ NSData dataWithPFShort: self.shortValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%d", [ PFField fieldNameWithId: self.fieldId ], self.shortValue ];
   //return [ NSString stringWithFormat: @"%d=%d", self.fieldId, self.shortValue ];
}

-(NSString*)valueKey
{
   return @"shortValue";
}

@end

@implementation PFIntegerField

@synthesize integerValue;

-(NSData*)data
{
   return [ NSData dataWithPFInteger: self.integerValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%d", [ PFField fieldNameWithId: self.fieldId ], self.integerValue ];
   //return [ NSString stringWithFormat: @"%d=%d", self.fieldId, self.integerValue ];
}

-(NSString*)valueKey
{
   return @"integerValue";
}

@end

@implementation PFLongField

@synthesize longValue;

-(NSData*)data
{
   return [ NSData dataWithPFLong: self.longValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%llu", [ PFField fieldNameWithId: self.fieldId ], self.longValue ];
   //return [ NSString stringWithFormat: @"%d=%llu", self.fieldId, self.longValue ];
}

-(NSString*)valueKey
{
   return @"longValue";
}

@end

@implementation PFStringField

@synthesize stringValue = _stringValue;

-(NSData*)data
{
   return [ NSData dataWithPFString: self.stringValue ];
}

-(NSString*)description
{
   if ( self.fieldId == PFFieldPassword )
   {
      return [ NSString stringWithFormat: @"%@=***password***", [ PFField fieldNameWithId: self.fieldId ] ];
   }
   else
   {
      return [ NSString stringWithFormat: @"%@=%@", [ PFField fieldNameWithId: self.fieldId ], self.stringValue ];
   }
   //return [ NSString stringWithFormat: @"%d=%@", self.fieldId, self.stringValue ];
}

-(NSString*)valueKey
{
   return @"stringValue";
}

@end

@implementation PFArrayField

@dynamic arrayValue;

-(NSArray*)arrayValue
{
   return [ NSArray arrayWithPFString: self.stringValue ];
}

-(void)setArrayValue:( NSArray* )array_
{
   self.stringValue = [ array_ PFString ];
}

-(NSString*)valueKey
{
   return @"arrayValue";
}

@end

@implementation PFFloatField

@synthesize floatValue;

-(NSData*)data
{
   return [ NSData dataWithPFFloat: self.floatValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%f", [ PFField fieldNameWithId: self.fieldId ], self.floatValue ];
   //return [ NSString stringWithFormat: @"%d=%f", self.fieldId, self.floatValue ];
}

-(NSString*)valueKey
{
   return @"floatValue";
}

@end

@implementation PFDoubleField

@synthesize doubleValue;

-(NSData*)data
{
   return [ NSData dataWithPFDouble: self.doubleValue ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%f", [ PFField fieldNameWithId: self.fieldId ], self.doubleValue ];
   //return [ NSString stringWithFormat: @"%d=%f", self.fieldId, self.doubleValue ];
}

-(NSString*)valueKey
{
   return @"doubleValue";
}

@end

@implementation PFDateField

@synthesize dateValue = _dateValue;

-(NSData*)data
{
   PFLong mseconds_ = [ self.dateValue msecondsTimeStamp ];

   return [ NSData dataWithPFLong: mseconds_ ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%@", [ PFField fieldNameWithId: self.fieldId ], self.dateValue ];
   //return [ NSString stringWithFormat: @"%d=%@", self.fieldId, self.dateValue ];
}

-(NSString*)valueKey
{
   return @"dateValue";
}

@end

@implementation PFSignatureField

-(NSData*)data
{
   //!TODO
   return nil;
}

-(NSString*)description
{
   //!TODO
   return nil;
}

@end

@implementation PFPublicKeyField

-(NSData*)data
{
   //!TODO
   return nil;
}

-(NSString*)description
{
   //!TODO
   return nil;
}

@end

@implementation PFMessageField

-(NSData*)data
{
   //!TODO
   return nil;
}

-(NSString*)description
{
   //!TODO
   return nil;
}

@end

@implementation PFDataField

@synthesize dataValue;

-(NSData*)data
{
   return [ NSData dataWithPFData: self.dataValue ];
}

-(NSString*)valueKey
{
   return @"dataValue";
}

@end

@implementation PFGroupField

@synthesize groupId;
@synthesize fieldOwner = _fieldOwner;

+(id)groupWithId:( PFInteger )group_id_
{
   PFGroupField* group_ = [ self fieldWithId: PFFieldGroup ];
   group_.groupId = group_id_;
   return group_;
}

-(PFFieldOwner*)fieldOwner
{
   if ( !_fieldOwner )
   {
      _fieldOwner = [ PFFieldOwner new ];
   }
   return _fieldOwner;
}

-(NSArray*)fields
{
   return self.fieldOwner.fields;
}

-(id)fieldWithId:( PFShort )id_
{
   return [ self.fieldOwner fieldWithId: id_ ];
}

-(id)writeFieldWithId:( PFShort )id_
{
   return [ self.fieldOwner writeFieldWithId: id_ ];
}

-(NSArray*)groupFieldsWithId:( PFInteger )group_id_
{
   return [ self.fieldOwner groupFieldsWithId: group_id_ ];
}

-(PFGroupField*)writeGroupFieldWithId:( PFInteger )group_id_
{
   return [ self.fieldOwner writeGroupFieldWithId: group_id_ ];
}

-(void)addField:( PFField* )field_
{
   [ self.fieldOwner addField: field_ ];
}

-(PFShort)fieldsLength
{
   PFShort length_ = 0;
   for ( PFField* field_ in self.fields )
   {
      length_ += ( PFShortSize /*field id size*/ + field_.length );
   }
   return length_;
}

-(NSData*)data
{
   PFShort length_ = [ self fieldsLength ];

   NSMutableData* fields_data_ = [ NSMutableData dataWithCapacity: PFIntegerSize/*group id*/ + PFShortSize/*message length*/ + length_ ];

   [ fields_data_ appendPFInteger: self.groupId ];
   [ fields_data_ appendPFShort: length_ ];
   [ fields_data_ appendPFFields: self.fields ];

   return fields_data_;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@=%d=%@", [ PFField fieldNameWithId: self.fieldId ], self.groupId, self.fieldOwner ];
   //return [ NSString stringWithFormat: @"%d=%d=%@", self.fieldId, self.groupId, self.fieldOwner ];
}

@end

@implementation PFGroupLongField

// Если будут проблемы с новостями, то искать здесь

@end