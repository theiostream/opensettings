/*%%%%%
%% THHolder.m
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 13/5/2012
%%%%%*/

/*%%%
% This API was inspired on SBSettings and UISettings.
% Thanks BigBoss, qwertyoruiop, Maximus, DHowett.
%%%*/

/*%%
% TODO:
% 
%%*/

#import "THHolder.h"

static NSArray *_sharedHolders = nil;
@implementation THHolder
+ (NSArray *)loadHoldersForEnvironment:(NSString *)env {
	if (!_sharedHolders) {
		NSMutableArray *hld = [NSMutableArray array];
		
		NSFileManager *fm = [NSFileManager defaultManager];
		NSArray *contents = [fm contentsOfDirectoryAtPath:@"/Library/OpenSettings/Toggles/" error:nil];
		
		for (NSString *file in contents) {
			if ([[file pathExtension] isEqualToString:@"bundle"]) {
				NSBundle *bundle = [NSBundle bundleWithPath:file];
				
				Class toggleClass = [bundle principalClass];
				if (!toggleClass) {
					NSLog(@"[OpenSettings] Loader: Failed to load principal class of %@.", file);
					continue;
				}
				
				if (![toggleClass conformsToProtocol:@protocol(THToggle)]) {
					NSLog(@"[OpenSettings] Loader: Cowardly refused to load %@, whose principal class doesn't conform to the THToggle protocol.", file);
					continue;
				}
				
				THHolder *hl = [[[THHolder alloc] initWithClass:toggleClass andInfoDictionary:[[bundle infoDictionary] retain] plusEnvironment:env] autorelease];
				if ([hl validate]) [hld addObject:hl];
			}
		}
		
		if ([hld count] == 0)
			return nil;
			
		_sharedHolders = [hld retain];
	}
	
	return _sharedHolders;
}

- (THHolder *)initWithClass:(Class)cls andInfoDictionary:(NSDictionary *)dict plusEnvironment:(NSString *)env {
	if ((self = [super init])) {
		_toggle = [[cls alloc] init];
		_infoDictionary = [dict retain];
		
		_envDictionary = [[NSDictionary alloc] initWithContentsOfFile:env];
		_environment = [_envDictionary objectForKey:@"THEnvironmentIdentifier"];
	}
	
	return self;
}

- (BOOL)validate {
	BOOL req = (
		_toggle &&
		_infoDictionary &&
		[self name] &&
		[self identifier] &&
		[self isCapable] &&
		[_toggle respondsToSelector:@selector(isEnabled)] &&
		[_toggle respondsToSelector:@selector(changeStateAtEnvironment:)] &&
		[self enabledForEnvironment]
	);
	
	return req;
}

- (BOOL)isCapable {
	BOOL isCapable__ = [_toggle respondsToSelector:@selector(isCapable)];
	BOOL isCapable_ = isCapable__ ? [_toggle isCapable] : YES;
	
	NSArray *lockedEnv = [_infoDictionary objectForKey:@"THLockedEnvironments"];
	BOOL locked_ = lockedEnv ? [lockedEnv containsObject:_environment] : NO;
	
	return (isCapable_ && !locked_);
}

- (BOOL)enabledForEnvironment {
	NSArray *enabled_ = [_envDictionary objectForKey:@"THEnvironmentToggles"];
	if ([enabled_ containsObject:[self identifier]])
		return YES;
	
	return NO;
}

- (NSString *)name {
	NSString *nm = [_infoDictionary objectForKey:@"THToggleName"];
	return nm;
}

- (NSString *)identifier {
	NSString *thi = [_infoDictionary objectForKey:@"THToggleIdentifier"];
	NSString *cfi = [_infoDictionary objectForKey:@"CFBundleIdentifier"];
	return ide ? ide : cfi ? cfi : nil;
}

- (NSString *)theme {
	NSString *theme = [_envDictionary objectForKey:@"THEnvironmentTheme"];
	return theme ? theme : @"THDefault";
}	

- (UIImage *)currentImage {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *theme = [self theme];
	NSString *state = [self isEnabled] ? @"On" : @"Off";
	
	BOOL image__ = [_toggle respondsToSelector:@selector(currentImage)];
	NSString *path = image__ ? [_toggle currentImage] : [_infoDictionary objectForKey:[NSString stringWithFormat:@"TH%@ImageName", state]];
	
	NSString *fullPath = [NSString stringWithFormat:@"/Library/OpenSettings/Themes/%@/%@", theme, path];
	if (![fm fileExistsAtPath:fullPath])
		fullPath = [NSString stringWithFormat:@"/Library/OpenSettings/Themes/%@/THDefault%@.png", theme, state];
	if (![fm fileExistsAtPath:fullPath] && ![theme isEqualToString:@"THDefault"])
		fullPath = [NSString stringWithFormat:@"/Library/OpenSettings/Themes/THDefault/THDefault%@.png", state];
	if (![fm fileExistsAtPath:fullPath])
		return nil;
		
	return [UIImage imageWithContentsOfFile:fullPath];
}

- (BOOL)isEnabled {
	return [_toggle isEnabled];
}

- (BOOL)shouldDisplay {
	if ([_toggle respondsToSelector:@selector(shouldDisplay)])
		return [_toggle shouldDisplay];
	
	return YES;
}

- (float)haltDuration {
	if ([_toggle respondsToSelector:@selector(haltDuration)])
		return [_toggle haltDuration];
	
	return 0.f;
}

- (void)changeState {
	[_toggle changeStateAtEnvironment:_environment];
}

- (void)closeWindow {
	[_toggle closeWindow];
}

- (void)dealloc {
	[super dealloc];
	[_toggle release];
	[_infoDictionary release];
	[_environment release];
}
@end