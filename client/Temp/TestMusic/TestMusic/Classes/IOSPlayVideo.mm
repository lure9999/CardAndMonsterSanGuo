//
//  IOSPlayVideo.mm
//  TestMusic
//
//  Created by 敏 刘 on 13-12-5.
//
//

#include "IOSPlayVideo.h"
#include "AppController.h"


void IOSPlayVideo::playVideoForIOS()
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app playVideo];
}
