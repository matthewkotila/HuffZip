//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "Document.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  [self setDisplayName:@"HuffZip"];
  return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
  [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace {
  return YES;
}

- (void)makeWindowControllers {
  [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
  [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
  return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
  [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
  return YES;
}

@end
