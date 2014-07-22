#ifndef PRO_FINANCE_API_PF_EXPORT_H_INCLUDED
#define PRO_FINANCE_API_PF_EXPORT_H_INCLUDED

#if !defined(PF_EXPORT)
#  if defined(__cplusplus)
#    define PF_EXPORT extern "C"
#  else
#    define PF_EXPORT extern
#  endif
#endif

#endif
