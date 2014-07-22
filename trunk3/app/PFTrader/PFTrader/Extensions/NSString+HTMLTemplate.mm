#import "NSString+HTMLTemplate.h"

#include <CDT.hpp>
#include <CTPP2StringOutputCollector.hpp>
#include <CTPP2SyscallFactory.hpp>
#include <CTPP2VMSTDLib.hpp>
#include <CTPP2VMFileLoader.hpp>
#include <CTPP2VMMemoryCore.hpp>
#include <CTPP2VM.hpp>

static std::string HTMLTemplateApply( CTPP::CDT& template_, NSString* template_path_ )
{
   CTPP::SyscallFactory syscall_factory_( 100 );
   CTPP::STDLibInitializer::InitLibrary( syscall_factory_ );
   
   NSUInteger max_arg_stack_size_ = 4096;
   NSUInteger max_code_stack_size_ = 4096;
   NSUInteger max_steps_ = 20480;
   
   CTPP::VM vm_( &syscall_factory_
                , (uint)max_arg_stack_size_
                , (uint)max_code_stack_size_
                , (uint)max_steps_ );
   
   std::string html_result_;
   CTPP::StringOutputCollector html_collector_( html_result_ );
   
   CTPP::VMFileLoader loader_( [ template_path_ cStringUsingEncoding: NSUTF8StringEncoding ] );
   const CTPP::VMMemoryCore* memory_core_ = loader_.GetCore();
   
   vm_.Init( memory_core_, &html_collector_, 0 );
   
   UINT_32 iIP = 0;
   vm_.Run( memory_core_, &html_collector_, iIP, template_, 0 );
   
   return html_result_;
}

@implementation NSString (HTMLTemplate)

+(NSString*)stringWithHTMLTemplate:( CTPP::CDT& )template_
                    templateAtPath:( NSString* )path_
{
   std::string html_result_ = HTMLTemplateApply( template_, path_ );
   
   return [ self stringWithCString: html_result_.c_str() encoding: NSUTF8StringEncoding ];
}

@end

const char* HTMLTemplatePath( NSString* file_name_, NSString* extension_ )
{
   NSString* path_ = [ [ NSBundle mainBundle ] pathForResource: file_name_ ofType: extension_ ];
   NSURL* url_ = [ NSURL fileURLWithPath: path_ ];
   return [ [ url_ description ] cStringUsingEncoding: NSUTF8StringEncoding ];
}

void HTMLTemplateAssign( CTPP::CDT& template_, NSString* string_ )
{
   if ( string_ )
   {
      template_ = [ string_ cStringUsingEncoding: NSUTF8StringEncoding ];
   }
}
