#include "IOSPlayVideo.h"  
#include "IOSVideoController.h"  
  
 void IOSPlayVideo::playVideoForIOS(const char * filename,CCLayer *layer)  
{  
//   char * ת��Ϊ NSString  
	NSString *audioname=[NSString stringWithUTF8String:filename];  
	IOSVideoController *app = [[IOSVideoController alloc] init];  
	[app playVideo:audioname :layer];  
	  
}  