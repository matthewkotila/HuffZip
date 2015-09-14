//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "ViewController.h"
#import "HuffZipEncode.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (IBAction)chooseFile:(id)sender {
  @autoreleasepool {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
      HuffZipEncode *main = [[HuffZipEncode alloc] init];
      [main HuffZipEncodeMain:[[[panel URL] path] UTF8String]];
      [NSApp terminate:self];
    }
  }
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
}

@end
