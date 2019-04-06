
--require "amf3"
-- 主城场景模块声明
module("AudioUtil", package.seeall)

m_isBgmOpen = nil
m_isSoundEffectOpen = nil

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
            --SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
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
	
    --[[if(CCUserDefault:sharedUserDefault():getBoolForKey("isAudioInit")==false)then
        initAudioInfo()
    end]]--

	--add by sxin 重写	 
	local bloop = true
	if 	isLoop ~= nil then		
		bloop = isLoop		
	end
	
	if(m_isBgmOpen==true)then
	   SimpleAudioEngine:sharedEngine():playBackgroundMusic(bgm,bloop)
	end		
	
end
--播放音效
function playEffect(effect,isLoop)
    
    --[[if(CCUserDefault:sharedUserDefault():getBoolForKey("isAudioInit")==false)then
        initAudioInfo()
    end]]--
--	isLoop = isLoop==nil and false or isLoop
	--print("AudioUtil.playEffect effect:",effect)
	if(m_isSoundEffectOpen==true)then
		SimpleAudioEngine:sharedEngine():playEffect(effect,false)
	end
end
function rusumeBgm()
	SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
end
--关闭背景音乐
function muteBgm()
    m_isBgmOpen = false
	--SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0.0)
	--add 
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",false)
    CCUserDefault:sharedUserDefault():flush()
end
--开启背景音乐
function openBgm()
    m_isBgmOpen = true
    SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(1.0)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",true)
    CCUserDefault:sharedUserDefault():flush()
end
--关闭音效
function muteSoundEffect()
    m_isSoundEffectOpen = false
    --SimpleAudioEngine:sharedEngine():setEffectsVolume(0.0)
	SimpleAudioEngine:sharedEngine():stopAllEffects()
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",false)
    CCUserDefault:sharedUserDefault():flush()
end
--开启音效
function openSoundEffect()
    m_isSoundEffectOpen = true
    SimpleAudioEngine:sharedEngine():setEffectsVolume(1.0)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",true)
    CCUserDefault:sharedUserDefault():flush()
end

--按扭点击音效
function PlayBtnClick()
	if(CCUserDefault:sharedUserDefault():getBoolForKey("m_isSoundEffectOpen")==true)then
		SimpleAudioEngine:sharedEngine():playEffect("audio/button_UI.mp3")
	end
end


-- 退出场景，释放不必要资源
function release (...) 

end
