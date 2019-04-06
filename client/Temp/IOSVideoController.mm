#import "IOSVideoController.h"  
#import "AppController.h"  
@implementation IOSVideoController  
  
//����������Ƶ  
-(void)playUrlVideo  
{  
  
  
  
}  
-(void)playVideo:(NSString *)filename :(CCLayer *)targetLayer  
{  
	TargetLayer =targetLayer;  
	//��תLayer�ǿ�  
	if (targetLayer) {  
		TargetLayer->retain();  
	}  
  
	SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();  
	SimpleAudioEngine::sharedEngine()->pauseAllEffects();  
  
	NSString *myFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:nil];  
	NSURL *url = [NSURL fileURLWithPath:myFilePath];  
	  
	movePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];  
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:movePlayer];  
	  
	if([movePlayer respondsToSelector:@selector(setFullscreen:animated:)])  
	{  
		movePlayer.shouldAutoplay=YES;  
		  
		CCSize winSize=CCDirector::sharedDirector()->getWinSize();  
		CCLog("winSize.width====%f    winSize.height====%f",winSize.width,winSize.height);  
		//         ����iPad2��ipad3 ��Ƶλ�õ�������ȷ�ģ�Iphone ������Ҫϸ΢����  
		  
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)  
		{  
			movePlayer.view.frame=CGRectMake(-80,80, 480, 320);  
		}  
		else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)  
		{  
			movePlayer.view.frame=CGRectMake(-128, 128, winSize.width, winSize.height);  
		}  
		else  
		{  
			movePlayer.view.frame=CGRectMake(-80,80, 480, 320);  
			  
		}  
		  
		//        ǿ�ƺ���  
		CGAffineTransform landscapeTransform;  
		UIDevice *device = [UIDevice currentDevice] ;  
		if (device.orientation==UIDeviceOrientationLandscapeLeft)  
		{  
			landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);  
		}  
		else  
		{  
			landscapeTransform = CGAffineTransformMakeRotation(-M_PI / 2);  
		}  
		movePlayer.view.transform = landscapeTransform;  
		  
		// �½�һ��window�������Ƶ���UIView  
		window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];  
		  
		[window addSubview:movePlayer.view];  
		[window makeKeyAndVisible];  
//  ����Ƶ�Ϸ���ӡ���������ť        
		CGRect frame = CGRectMake(768-100, 100, 100, 50);  
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
		button.frame = frame;  
		[button setTitle:@"����" forState: UIControlStateNormal];  
		  
		button.transform =landscapeTransform;  
		button.backgroundColor = [UIColor clearColor];  
		button.tag = 2000;  
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];  
		[window addSubview:button];  
		  
  
		//  �����Ƿ��������  
		movePlayer.controlStyle = MPMovieControlStyleNone;  
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];  
		  
	}  
	else  
	{  
		movePlayer.controlStyle=MPMovieControlModeHidden;  
	}  
	  
	[self playMovie];  
  
  
}  
//������Ƶ  
-(IBAction) buttonClicked:(id)sender {  
	[movePlayer stop];  
  
	[movePlayer.view removeFromSuperview];  
	[movePlayer release];  
	[window release];  
	SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();  
	SimpleAudioEngine::sharedEngine()->resumeAllEffects();  
	  
	if (!TargetLayer) {  
		return;  
	}  
	TargetLayer->removeAllChildrenWithCleanup(true);  
	TargetLayer->removeFromParent();  
  
	CCScene * scene =CCScene::create();  
	scene->addChild(TargetLayer,10);  
	CCDirector::sharedDirector()->replaceScene(scene);  
	  
	  
}  
//���ſ�ʼ  
-(void) playMovie  
{  
	MPMoviePlaybackState state=movePlayer.playbackState;  
	if(state==MPMoviePlaybackStatePlaying)  
	{  
		NSLog(@"Movie is already playing.");  
		return;  
	}  
	[movePlayer play];  
}  
//�˳�ȫ��  
-(void)exitFullScreen:(NSNotification *)notification{  
	CCLOG("exitFullScreen");  
	movePlayer.controlStyle=MPMovieControlStyleDefault;  
	[movePlayer.view removeFromSuperview];  
}  
//��Ƶ���Ž���  
- (void) movieFinished:(NSNotificationCenter *)notification{  
//    CCLOG("moviePlaybackFinished");  
	//��Ƶ�������  
	
	movePlayer.controlStyle=MPMovieControlStyleDefault;  
	MPMoviePlaybackState state=movePlayer.playbackState;  
	if(state==MPMoviePlaybackStateStopped){  
		NSLog(@"Movie is already stopped.");  
		return;  
	}  
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:movePlayer];  
	if([movePlayer respondsToSelector:@selector(setFullscreen:animated:)])  
	{  
  
		[movePlayer.view removeFromSuperview];  
		[window release];  
		  
		SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();  
		SimpleAudioEngine::sharedEngine()->resumeAllEffects();  
		  
		if (!TargetLayer) {  
			return;  
		}  
		TargetLayer->removeAllChildrenWithCleanup(true);  
		TargetLayer->removeFromParent();  
		CCScene * scene =CCScene::create();  
		scene->addChild(TargetLayer,10);  
		CCDirector::sharedDirector()->replaceScene(scene);  
  
	}  
	  
}  
  
- (void)dealloc {  
	[super dealloc];  
	if (TargetLayer) {  
			TargetLayer->release();  
	}  
  
}  
@end  