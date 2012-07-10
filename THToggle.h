/*%%%%%
%% THHolder.h
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 21/5/2012
%%%%%*/

@protocol THToggle <NSObject>
@optional
- (BOOL)isCapable;
- (BOOL)shouldDisplay;
- (NSString *)currentImage;
- (float)haltDuration;
- (void)closeWindow;

@required
- (BOOL)isEnabled;
- (void)changeStateAtEnvironment:(NSString *)env;
@end