#import "PFOrderStatusConversion.h"

NSString* NSStringFromPFOrderStatusType( PFOrderStatusType staus_ )
{
   switch ( staus_ )
   {
      case PFOrderStatusNone:
         return NSLocalizedString(@"ORDER_STAUS_NONE", nil);
         
      case PFOrderStatusPendingNew:
         return NSLocalizedString(@"ORDER_STAUS_PENDING_NEW", nil);
         
      case PFOrderStatusPendingExecution:
         return NSLocalizedString(@"ORDER_STAUS_PENDING_EXECUTION", nil);
         
      case PFOrderStatusPendingCancel:
         return NSLocalizedString(@"ORDER_STAUS_PENDING_CANCEL", nil);
         
      case PFOrderStatusPendingReplace:
         return NSLocalizedString(@"ORDER_STAUS_PENDING_REPLACE", nil);
         
      case PFOrderStatusPendingStp:
         return NSLocalizedString(@"ORDER_STAUS_PENDING_STP", nil);
         
      case PFOrderStatusNew:
         return NSLocalizedString(@"ORDER_STAUS_NEW", nil);
         
      case PFOrderStatusReplaced:
         return NSLocalizedString(@"ORDER_STAUS_REPLACED", nil);
         
      case PFOrderStatusCancelled:
         return NSLocalizedString(@"ORDER_STAUS_CANCELLED", nil);
         
      case PFOrderStatusPartFilled:
         return NSLocalizedString(@"ORDER_STAUS_PART_FILLED", nil);
         
      case PFOrderStatusFilled:
         return NSLocalizedString(@"ORDER_STAUS_FILLED", nil);
         
      default:
         return nil;
   }
}
