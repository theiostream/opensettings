/*%%%%%
%% Hood.m
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 11/5/2012
%%%%%*/

/*
api:
- plist shit
- sbsettings meh
- loader
- lock daemon
- lock window/plugin
- (toggle caller)
*/

#import <libactivator.h>
#import "THWindow.h"
#import "THHelpers.h"

#define kHoodShowNotificationId   "am.theiostre.opensettings.HoodShow"
#define kHoodHideNotificationId   "am.theiostre.opensettings.HoodHide"
#define kHoodChangeNotificationId "am.theiostre.opensettings.HoodChange"

@interface THActivator : NSObject <LAListener>
@end

@implementation THActivator
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[[THWindow sharedWindow] changeHiddenState];
	[event setHandled:YES];
}
@end

static void THHoodCallback(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
	if (CFStringCompare(name, CFSTR(kHoodShowNotificationId), 0) == 0)
		[[THWindow sharedWindow] setHidden:NO];
		
	else if (CFStringCompare(name, CFSTR(kHoodHideNotificationId), 0) == 0)
		[[THWindow sharedWindow] setHidden:YES];
	
	else
		[[THWindow sharedWindow] changeHiddenState];
}

__attribute__((constructor))
static void THInitialize() {
	THPreferencesStartWatchingPreferenceNotifications();
	
	CFNotificationCenterRef darwinCenter = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(darwinCenter, NULL, &THHoodCallback, CFSTR(kHoodShowNotificationId), NULL, 0);
	CFNotificationCenterAddObserver(darwinCenter, NULL, &THHoodCallback, CFSTR(kHoodHideNotificationId), NULL, 0);
	CFNotificationCenterAddObserver(darwinCenter, NULL, &THHoodCallback, CFSTR(kHoodChangeNotificationId), NULL, 0);
}