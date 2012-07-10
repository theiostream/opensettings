/*%%%%%
%% THWindow.m
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 11/5/2012
%%%%%*/

#import "THHolder.h"

@interface THWindow : UIWindow
+ (TIWindow *)sharedWindow;
- (TIWindow *)initWithHoodFrame;

- (void)changeHiddenState;
@end
static THWindow *_sharedWindow = nil;

@implementation THWindow
+ (TIWindow *)sharedWindow {
	if (!_sharedWindow)
		_sharedWindow = [[[self class] alloc] initWithHoodFrame];
	
	return _sharedWindow;
}

- (TIWindow *)initWithHoodFrame {
	TIWindow *wd = [super initWithFrame:CGRectMake(0, 0, 320, 320)];
	[wd _initializeToggles];
	[wd _initializeStats];
	
	return wd;
}

- (void)_initializeToggles {
	NSArray *holders = [THHolder loadHolders];
	
	if (holders) {
		UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, 310, 140)] autorelease];
		
		for (THHolder *hld in holders) {
			
		}
		
		return;
	}
	
	// make error label
}

- (void)changeHiddenState {
	[self setHidden:![self hidden]];
}
@end