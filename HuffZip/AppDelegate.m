//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "AppDelegate.h"
#import "HuffZipDecode.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
  @autoreleasepool {
    HuffZipDecode *main = [[HuffZipDecode alloc] init];
    [main HuffZipDecodeMain:[filename UTF8String]];
    [NSApp terminate:self];
  }
  return YES;
}

@end
