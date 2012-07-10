/*%%%%%
%% THHelpers.m
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 14/5/2012
%%%%%*/

#define kTHSettingsChangedNotificationId "am.theiostre.opensettings.rldprefs"

typedef enum _THWindowEnvironment {
	THWindowEnvironmentHood = 0,
	THWindowEnvironmentNotificationCenter
} THWindowEnvironment;

typedef enum _THSituation {
	THSituationInCall,
	
	THSituationInLockScreen,
	THSituationInApplication,
	
	THSituationInHoodWindow,
	THSituationInNotificationCenter
} THSituation;

static BOOL THCheckSituation(THSituation situation) {
	BOOL ret = NO;
	
	switch (situation) {
		case THSituationInCall:
			ret = x;
			break;
		case THSituationInLockScreen:
			ret = x;
			break;
		case THSituationInApplication:
			ret = x;
			break;
		case THSituationInHoodWindow:
			ret = x;
			break;
		case THSituationInNotificationCenter:
			ret = x;
			break;
		default:
	}
	
	return ret;
}

/* ************
************* */

static NSDictionary *togglePreferences = nil;
static void THReloadPrefs() {
	NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/am.theiostre.opensettings.plist"];
	if (!plist) return;
	
	togglePreferences = [plist retain];
}

static void THSettingsCallback(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
	NSLog(@"[OpenSettings] Notify: Reloaded Preferences");
	THReloadPrefs();
}

static void THPreferencesStartWatchingPreferenceNotifications() {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &THSettingsCallback, CFSTR(kTHSettingsChangedNotificationId), NULL, 0);
}

/* ************
************* */

static BOOL _THBoolPref(NSDictionary *dict, NSString *key, BOOL def) {
	if (!togglePreferences) return def;
	
	NSNumber *v = [dict objectForKey:key];
	return v ? [v boolValue] : def;
}

static BOOL _THEnabledToggleForIdentifier(NSString *ident) {
	NSString *key = [@"THToggle:" stringByAppendingString:ident];
	BOOL enabled = _THBoolPref(key, YES);
	
	return enabled;
}

static NSString *_THEnabledTheme(NSString *env) {
	NSString *key = [NSString stringWithFormat:@"THTheme:%@", env);
	NSString *obj = [togglePreferences objectForKey:key];
	
	return obj ? obj : @"THDefault";
}