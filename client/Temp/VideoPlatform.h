#ifndef __Platform_H_H__  
#define __Platform_H_H__  
#include "cocos2d.h"  
using namespace cocos2d;  
class VideoPlatform   
{  
 public:  
    //�ڵ�ǰ��layer�ϲ�����Ƶ����Ƶ��ϻ��ߵ��������Ƶ����ת��ָ����layer��(Ĭ��Ϊ�գ�Ҳ����ͣ���ڵ�ǰlayer��)  
    static void playVideo(const char * filename,CCLayer *layer =NULL);  
};  
  
#endif // __Platform_H_H__ 