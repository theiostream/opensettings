/*%%%%%
%% THHolder.h
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 13/5/2012
%%%%%*/

#include <objc/runtime.h>
#import "THToggle.h"

@interface THHolder : NSObject {
	id<THToggle> _toggle;
	NSDictionary *_infoDictionary;
	
	NSDictionary *_envDictionary;
	NSString *_environment;
}

+ (NSArray *)loadHoldersForEnvironment:(NSString *)env withPlatforms:(NSArray *)platforms;

- (THHolder *)initWithClass:(Class)cls andInfoDictionary:(NSDictionary *)dict plusEnvironment:(NSString *)env;
- (BOOL)validate;

- (NSString *)name;
- (NSString *)identifier;
- (BOOL)enabledForEnvironment;
- (NSString *)theme;

- (BOOL)isCapable;
- (BOOL)isEnabled;
- (BOOL)shouldDisplay;
- (float)haltDuration;
- (UIImage *)currentImage;

- (void)changeState;
- (void)closeWindow;
@end