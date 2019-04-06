
--require "amf3"
-- 主城场景模块声明
module("AudioUtil", package.seeall)

local m_currentBgm       --当前背景音乐

m_isBgmOpen = nil

m_isSoundEffectOpen = nil

local IMG_PATH = "Audio/"				-- 主路径

function initAudioInfo()
    if(CCUserDefault:sharedUserDefault():getBoolForKey("isAudioInit")==false)then
        CCUserDefault:sharedUserDefault():setBoolForKey("isAudioInit",true)
        CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",true)
        CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",true)
        CCUserDefault:sharedUserDefault():flush()
        
        m_isBgmOpen = true
        m_isSoundEffectOpen = true
    else
        m_isBgmOpen = CCUserDefault:sharedUserDefault():getBoolForKey("m_isBgmOpen")
        m_isSoundEffectOpen = CCUserDefault:sharedUserDefault():getBoolForKey("m_isSoundEffectOpen")
        
        if(m_isBgmOpen==true)then
            SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(1)
        else
            SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
        end
        if(m_isSoundEffectOpen==true)then
            SimpleAudioEngine:sharedEngine():setEffectsVolume(1)
            else
            SimpleAudioEngine:sharedEngine():setEffectsVolume(0)
        end
    end
end
--播放背景音乐
function playBgm(bgm,isLoop)
    
    if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
    
    if(bgm~=m_currentBgm)then
        isLoop = isLoop==nil and true or isLoop
        m_currentBgm = bgm
        --if(m_isBgmOpen==true)then
            SimpleAudioEngine:sharedEngine():playBackgroundMusic(m_currentBgm,isLoop)
        --end
    end
end
--播放音效
function playEffect(effect,isLoop)
    
    if(nil==m_isSoundEffectOpen)then
        initAudioInfo()
    end
    
    isLoop = isLoop==nil and false or isLoop
    --Log("AudioUtil.playEffect effect:",effect)
    
    if(m_isSoundEffectOpen==true)then
        SimpleAudioEngine:sharedEngine():playEffect(effect,isLoop)
    end
end
--关闭背景音乐
function muteBgm()
    m_isBgmOpen = false
    SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
    
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",false)
    CCUserDefault:sharedUserDefault():flush()
end
--开启背景音乐
function openBgm()
    m_isBgmOpen = true
    SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(1)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",true)
    CCUserDefault:sharedUserDefault():flush()
end
--关闭音效
function muteSoundEffect()
    m_isSoundEffectOpen = false
    SimpleAudioEngine:sharedEngine():setEffectsVolume(0)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",false)
    CCUserDefault:sharedUserDefault():flush()
end
--开启音效
function openSoundEffect()
    m_isSoundEffectOpen = true
    SimpleAudioEngine:sharedEngine():setEffectsVolume(1)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",true)
    CCUserDefault:sharedUserDefault():flush()
end

--按扭点击音效
function PlayBtnClick()
	SimpleAudioEngine:sharedEngine():playEffect("audio/button_01.mp3")
end


--播放背景音乐
function playMainBgm()
    playBgm("audio/main.mp3")
end
-- 退出场景，释放不必要资源
function release (...) 

end
