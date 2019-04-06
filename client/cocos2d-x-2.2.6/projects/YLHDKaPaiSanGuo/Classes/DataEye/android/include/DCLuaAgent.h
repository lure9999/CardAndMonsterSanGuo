/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:SDK��ʼ���ӿڣ�androidƽ̨������C++��ֻ����
�ṩһ���ӿڣ������ӿ���Ҫ��������java�����    
**************************************************/  

#ifndef __DATAEYE_DCAGENT_H__
#define __DATAEYE_DCAGENT_H__
#include "DCAccountType.h"
#include "DCTaskType.h"
#include "DCGender.h"
#include <map>
#include <string>
#include "cocos2d.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#endif

using namespace std;

class DCLuaAgent
{
public: 
	/************************************************* 
	* Description: �Զ���汾��
	* version    : �汾��	
	*************************************************/ 
	static void setVersion(const char* version);
	
	/************************************************* 
	* Description: �Զ������ӿ�
	* title      : ������
    * error      : �������ݣ����鴫������ջ��Ϣ	
	*************************************************/ 
	static void reportError(const char* title, const char* error);
	
	/*************************************************
     * Description: �����ϱ����ݣ����û��ǳ�����һЩ���ݣ�ϣ��
                    �������ϱ�ʱ�����Ե��øýӿ�
     *************************************************/
    static void uploadNow();
    
    /*************************************************
     * Description: ��ȡ��ǰ�豸UID
     * return     : UID
     *************************************************/
    static const char* getUID();
	
	/*************************************************
     * Description: �򿪹��Ч��׷�ٹ���
     *************************************************/
	static void openAdTracking();
};

class DCLuaTracking
{
public:
	/************************************************* 
	* Description: �Զ������ӿ�
	* title      : ������
    * error      : �������ݣ����鴫������ջ��Ϣ	
	*************************************************/ 
	static void setEffectPoint(const char* pointId, map<string, string>* map);
};

//�����Ϣ�ӿ�
class DCLuaAccount
{
public:
	/************************************************* 
	* Description: ��ҵ�½����DC_AFTER_LOGINģʽ��ʹ��
	* accountId  : ����˺�ID���ò����뱣֤ȫ��Ψһ   
	*************************************************/ 
    static void login(const char* accountId);
	
	/************************************************* 
	* Description: ��ҵ�½����DC_AFTER_LOGINģʽ��ʹ��
	* accountId  : ����˺�ID���ò����뱣֤ȫ��Ψһ
	* gameServer : ����˺���������	
	*************************************************/ 
    static void login(const char* accountId, const char* gameServer);
    
	/************************************************* 
	* Description: ��ҵǳ�����DC_AFTER_LOGINģʽ��ʹ��
	*************************************************/ 
    static void logout();
    
    /*************************************************
     * Description: ��ȡ��ǰ�û�ID
     * return     : �û�ID
     *************************************************/
    static const char* getAccountId();

	/************************************************* 
	* Description: ��������˺�����
	* accountType: ����˺����ͣ�ֵΪDCAccountType�е�ö��   
	*************************************************/ 
    static void setAccountType(DCAccountType accountType);

	/************************************************* 
	* Description: ������ҵȼ�
	* level      : ����˺ŵȼ�   
	*************************************************/
    static void setLevel(int level);

	/************************************************* 
	* Description: ��������Ա�
	* gender     : ����Ա�   
	*************************************************/ 
    static void setGender(DCGender gender);

	/************************************************* 
	* Description: �����������
	* age        : �������   
	*************************************************/
    static void setAge(int age);

	/************************************************* 
	* Description: ���������������
	* gameServer : ����˺���������   
	*************************************************/
    static void setGameServer(const char* gameServer);
	
	/*************************************************
     * Description: ����Ҵ��ǩ���û�SDK�ĺ������͹���
     * tag        : һ����ǩ
     * subTag     : ������ǩ
     *************************************************/
    static void addTag(const char* tag, const char* subTag);
    
    /*************************************************
     * Description: ȡ����ұ�ǩ���û�SDK�ĺ������͹���
     * tag        : һ����ǩ
     * subTag     : ������ǩ
     *************************************************/
    static void removeTag(const char* tag, const char* subTag);
};

//���ѽӿ�
class DCLuaVirtualCurrency
{
public:
	
	/************************************************* 
	* Description: ���ѽӿڣ�֧��SDK���ѳɹ��ص�ʱ����
	* orderId       : ����ID
	* iapId         : ���ID
    * currencyAmount: ���ѽ��
	* currencyType  : ���ѱ���
	* paymentType   : ����;��
	*************************************************/
	static void paymentSuccess(const char* orderId, const char* iapId, double currencyAmount, const char* currencyType, const char* paymentType);
	
	/*************************************************
     * Description: ���ѽӿڣ����ڵ�ǰ�ϱ��ؿ��ڸ������ݣ�֧��SDK���ѳɹ��ص�ʱ����
     * orderId       : ����ID
	 * iapId         : ���ID
     * currencyAmount: ���ѽ��
     * currencyType  : ���ѱ���
     * paymentType   : ����;��
     * levelId       : �ؿ�ID
     *************************************************/
    static void paymentSuccessInLevel(const char* orderId, const char* iapId, double currencyAmount, const char* currencyType, const char* paymentSuccess, const char* levelId);
};

//���߽ӿ�
class DCLuaItem
{
public:
	/************************************************* 
	* Description: �������
	* itemId    : ����ID
    * itemType  : ��������
	* itemCount : ����ĵ�������
	* virtualCurrency:����ĵ��ߵ������ֵ
	* currencyType:֧����ʽ
	* consumePoint:���ѵ㣬��ؿ������ѣ�����Ϊ��
	*************************************************/
    static void buy(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint);
	
	/*************************************************
     * Description: ������ߣ����ڹؿ��ڹ�������¼�
     * itemId    : ����ID
     * itemType  : ��������
     * itemCount : ����ĵ�������
     * virtualCurrency:����ĵ��ߵ������ֵ
     * currencyType:֧����ʽ
     * consumePoint:���ѵ㣬��ؿ������ѣ�����Ϊ��
     * levelId:����ʱ���ڵĹؿ�Id������Ϊ��
     *************************************************/
    static void buyInLevel(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint, const char* levelId);
    
	/************************************************* 
	* Description: ��õ���
	* itemId    : ����ID
    * itemType  : ��������
	* itemCount : ��������
	* reason    : ��õ��ߵ�ԭ��
	*************************************************/
	static void get(const char* itemId, const char* itemType, int itemCount, const char* reason);
	
	/*************************************************
     * Description: ��õ��ߣ����ڹؿ��ڻ�õ����¼�
     * itemId    : ����ID
     * itemType  : ��������
     * itemCount : ��������
     * reason    : ��õ��ߵ�ԭ��
     * levelId   : ��õ���ʱ���ڵĹؿ�Id
     *************************************************/
    static void getInLevel(const char* itemId, const char* itemType, int itemCount, const char* reason, const char* levelId);
    
	/************************************************* 
	* Description: ���ĵ���
	* itemId    : ����ID
    * itemType  : ��������
	* itemCount : ��������
	* reason    : ���ĵ��ߵ�ԭ��
	*************************************************/
	static void consume(const char* itemId, const char* itemType, int itemCount, const char* reason);
	
	/*************************************************
     * Description: ���ĵ��ߣ����ڹؿ������ĵ����¼�
     * itemId    : ����ID
     * itemType  : ��������
     * itemCount : ��������
     * reason    : ���ĵ��ߵ�ԭ��
     * levelId   : �ؿ������ĵ��ߵ�ԭ��
     *************************************************/
    static void consumeInLevel(const char* itemId, const char* itemType, int itemCount, const char* reason, const char* levelId);
};

//����ӿ�
class DCLuaTask
{
public:
	/************************************************* 
	* Description: ��ʼ����
	* taskId     : ����ID
    * taskType   : ��������
	*************************************************/
    static void begin(const char* taskId, DCTaskType type);
	
	/************************************************* 
	* Description: �������
	* taskId     : ����ID
	*************************************************/
    static void complete(const char* taskId);
	
	/************************************************* 
	* Description: ����ʧ��
	* taskId     : ����ID
    * reason     : ����ʧ��ԭ��
	*************************************************/
    static void fail(const char* taskId, const char* reason);
};

//�Զ����¼�
class DCLuaEvent
{
public:
	/************************************************* 
	* Description: ��½ǰ�Զ����¼����û���½֮��ýӿ���Ч
	* eventId    : �¼�ID
    * map        : �¼�����ʱ��ע������map
	* duration   : �¼�����ʱ��
	*************************************************/
	static void onEventBeforeLogin(const char* eventId, map<string, string>* map, long long duration);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
    * count      : �¼���������
	*************************************************/
    static void onEventCount(const char* eventId, int count);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
	*************************************************/
    static void onEvent(const char* eventId);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
    * label      : �¼�����ʱ��ע��һ������
	*************************************************/
    static void onEvent(const char* eventId, const char* label);
	
	/************************************************* 
	* Description: �¼�����
	* eventId    : �¼�ID
    * label      : �¼�����ʱ��ע�Ķ������map
	*************************************************/
    static void onEvent(const char* eventId, map<string, string>* map);
    
	/************************************************* 
	* Description: ʱ���¼�����
	* eventId    : �¼�ID
    * duration   : �¼�����ʱ��
	*************************************************/
    static void onEventDuration(const char* eventId, long long duration);
	
	/************************************************* 
	* Description: ʱ���¼�����
	* eventId    : �¼�ID
	* label      : �¼�����ʱ��ע�ĵ�������
    * duration   : �¼�����ʱ��
	*************************************************/
    static void onEventDuration(const char* eventId, const char* label, long long duration);
	
	/************************************************* 
	* Description: ʱ���¼�����
	* eventId    : �¼�ID
	* map        : �¼�����ʱ��ע�Ķ������
    * duration   : �¼�����ʱ��
	*************************************************/
    static void onEventDuration(const char* eventId, map<string, string>* map, long long duration);
    
	/************************************************* 
	* Description: �������¼���ʼ����onEventEnd(eventId)���ʹ��
	* eventId    : �¼�ID
	*************************************************/
    static void onEventBegin(const char* eventId);
	
	/************************************************* 
	* Description: �������¼���ʼ����onEventEnd(eventId)���ʹ��
	* eventId    : �¼�ID
	* map        : �¼�����ʱ��ע�Ķ������
	*************************************************/
    static void onEventBegin(const char* eventId, map<string, string>* map);
	
	/************************************************* 
	* Description: �������¼���������onEventBegin(eventId)��onEventBegin(eventId, map)���ʹ��
	* eventId    : �¼�ID
	*************************************************/
    static void onEventEnd(const char* eventId);
    
	/************************************************* 
	* Description: �������¼���ʼ����onEventEnd(eventId, flag)���ʹ��
	* eventId    : �¼�ID
	* map        : �¼�����ʱ��ע�Ķ������
	* flag       : eventId��һ����ʶ����eventId��ͬ����һ���¼���������������¼���
	               eventId����Ϊ���������flag��Ϊ��Ҿ���ĵȼ�
	*************************************************/
    static void onEventBegin(const char* eventId, map<string, string>* map, const char* flag);
	
	/************************************************* 
	* Description: �������¼���������onEventBegin(eventId, map, flag)���ʹ��
	* eventId    : �¼�ID
	* flag       : eventId��һ����ʶ����eventId��ͬ����һ���¼���������������¼���
	               eventId����Ϊ���������flag��Ϊ��Ҿ���ĵȼ�
	*************************************************/
    static void onEventEnd(const char* eventId, const char* flag);
};

//����ҽӿ�
class DCLuaCoin
{
public:
	/************************************************* 
	* Description: �������������
	* coinNum    : ���������
    * coinType   : ���������
	*************************************************/
    static void setCoinNum(long long total, const char* coinType);
	
	/************************************************* 
	* Description: ���������
	* id         : ���������ʱ��ע�����ԣ�������ԭ��
    * coinType   : ���������
	* lost       : ��������ҵ�����
	* left       : ���ʣ����������
	*************************************************/ 
    static void lost(const char* reason, const char* coinType, long long lost, long long left);
	
	/*************************************************
     * Description: ��������ң����ڹؿ��������¼�
     * id         : ���������ʱ��ע�����ԣ�������ԭ��
     * coinType   : ���������
     * lost       : ��������ҵ�����
     * left       : ���ʣ����������
     * levelId    : ��ҵ�ǰ���ڵĹؿ�ID
     *************************************************/
    static void lostInLevel(const char* reason, const char* coinType, long long lost, long long left, const char* levelId);
	
	/************************************************* 
	* Description: ���������
	* id         : ���������ʱ��ע�����ԣ�������ԭ��
    * coinType   : ���������
	* gain       : ��������ҵ�����
	* left       : ���ʣ����������
	*************************************************/
    static void gain(const char* reason, const char* coinType, long long gain, long long left);
	
	/*************************************************
     * Description: �������ң����ڹؿ��ڻ���¼�
     * id         : ��������ʱ��ע�����ԣ�������ԭ��
     * coinType   : ���������
     * gain       : �������ҵ�����
     * left       : ���ʣ����������
     * levelId    : ��ҵ�ǰ���ڵĹؿ�ID
     *************************************************/
    static void gainInLevel(const char* reason, const char* coinType, long long gain, long long left, const char* levelId);
};

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#ifdef __cplusplus
extern "C"
{
#endif

//���ø��³ɹ���,java��ص�C++��Ľӿڣ��ڲ�ʹ��
JNIEXPORT void JNICALL Java_com_dataeye_data_DCConfigParams_updateSuccess(JNIEnv *, jobject obj);

#ifdef __cplusplus
}
#endif
#endif

//���ø��³ɹ���SDK����Ϸ���͵ĸ��³ɹ���Ϣ����������Ҫ�ڼ�������Ϣ
#define DCCONFIGPARAMS_UPDATE_COMPLETE "DataeyeConfigParamsComplete"

class DCLuaConfigParams
{
public:
	/************************************************* 
	* Description: ���߲������½ӿ�
	*************************************************/
    static void update();
	
	/************************************************* 
	* Description: ��ȡString�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
    static const char* getParameterString(const char* key, const char* defaultValue);
	
	/************************************************* 
	* Description: ��ȡint�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
    static int getParameterInt(const char* key, int defaultValue);
	
	/************************************************* 
	* Description: ��ȡlong long�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
	static long long getParameterLong(const char* key, long long defaultValue);
	
	/************************************************* 
	* Description: ��ȡbool�Ͳ���
	* key        : ��Ҫ��ȡ�Ĳ�����keyֵ
    * defaultValue: ��Ҫ��ȡ�Ĳ�����Ĭ��ֵ
	*************************************************/
    static bool getParameterBool(const char* key, bool defaultValue);
};

//�ؿ��ӿ�
class DCLuaLevels
{
public:
	/************************************************* 
	* Description: ��ʼ�ؿ�
    * levelId    : �ؿ�ID
	*************************************************/
	static void begin(const char* levelId);
	
	/************************************************* 
	* Description: �ɹ���ɹؿ�
    * levelId    : �ؿ�ID
	*************************************************/
	static void complete(const char* levelId);
	
	/************************************************* 
	* Description: �ؿ�ʧ�ܣ���ҹؿ����˳���Ϸʱ��������øýӿ�
    * levelId    : �ؿ�ID
	* failPoint  : ʧ��ԭ��
	*************************************************/
	static void fail(const char* levelId, const char* failPoint);
};

class DCLuaCardsGame
{
public:
    /**
     *  @brief ��ҷ������һ����Ϸ�����
	 *  @brief roomId ����ID
     *  @brief lostOrGainCoin    ��û��߶�ʧ�����������������Ϊ�㣩
	 *  @brief roomType ��������
     *  @param taxCoin  ���һ����Ϸʱϵͳ��Ҫ���յ������������˰�գ�
     *  @param leftCoin   ���ʣ������������
     */
    static void play(const char* roomId, const char* roomType, const char* coinType, long long lostOrGainCoin, long long taxCoin, long long leftCoin);
    
    /**
     *  @brief ��ҷ����ڶ�ʧ�����ʱ���ã����һ����Ϸ����play�ӿں󲻱��ٵ��øýӿڣ�
	 *  @brief roomId ����ID
     *  @brief roomType ��������
     *  @param lostCoin  ��ʧ�����������
     *  @param leftCoin   ʣ������������
     */
    static void lost(const char* roomId, const char* roomType, const char* coinType, long long lostCoin, long long leftCoin);
    
    /**
     *  @brief ��ҷ����ڻ�������ʱ���ã����һ����Ϸ����play�ӿں󲻱��ٵ��øýӿڣ�
	 *  @brief roomId ����ID
     *  @brief roomType ��������
     *  @param gainCoin   Ӯ�õ����������
     *  @param leftCoin  ʣ������������
     */
    static void gain(const char* roomId, const char* roomType, const char* coinType, long long gainCoin, long long leftCoin);
};

#endif