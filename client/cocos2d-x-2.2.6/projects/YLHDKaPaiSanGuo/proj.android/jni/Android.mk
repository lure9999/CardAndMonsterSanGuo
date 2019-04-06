LOCAL_PATH := $(call my-dir)

$(call import-add-path,$(LOCAL_PATH)/../)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := hellolua/main.cpp \
                   ../../Classes/AppDelegate.cpp\
                   ../../Classes/MyAssetsManager/MyAssetsManager.cpp\
                   ../../Classes/MyAssetsManager/UpdateManager.cpp\
                   ../../Classes/network/NetStream.cpp\
				   ../../Classes/network/NetSocket.cpp\
				   ../../Classes/network/NetManage.cpp\
                   ../../Classes/network/networkcallback.cpp\
				   ../../Classes/TouchDispatcher/SingleDispatcher.cpp\
				   ../../Classes/Analytics.cpp\
                   ../../Classes/PluginChannel.cpp\
                   ../../Classes/Push.cpp\
                   ../../Classes/DataEye/android/source/DataEye.cpp\
                   ../../Classes/DataEye/android/source/DCJniHelper.cpp\
                   ../../Classes/DataEye/android/source/DCLuaAgent.cpp
                   
              

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes\
					$(LOCAL_PATH)/../../Classes/DataEye/android/include\
					$(LOCAL_PATH)/../protocols/android\
					$(LOCAL_PATH)/../protocols/include

LOCAL_STATIC_LIBRARIES := curl_static_prebuilt

LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocosdenshion_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static
LOCAL_WHOLE_STATIC_LIBRARIES += box2d_static
LOCAL_WHOLE_STATIC_LIBRARIES += chipmunk_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_extension_static

LOCAL_WHOLE_STATIC_LIBRARIES += PluginProtocolStatic

include $(BUILD_SHARED_LIBRARY)

$(call import-module,cocos2dx)
$(call import-module,CocosDenshion/android)
$(call import-module,scripting/lua/proj.android)
$(call import-module,cocos2dx/platform/third_party/android/prebuilt/libcurl)
$(call import-module,extensions)
$(call import-module,external/Box2D)
$(call import-module,external/chipmunk)
$(call import-module,protocols/android)