//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <Cocoa/Cocoa.h>

typedef struct trieNode trieNode;

// Main class for decompression component of application. Instantiated by the
// app delegate.
@interface HuffZipDecode : NSObject {
 @private
  trieNode *root;
  unsigned long fileIndex;
  unsigned long fileLength;
  unsigned long decodedLength;
  unsigned char *fileContents;
  unsigned char *decodedContents;
  unsigned char destructorIndex;
  trieNode *destructorList[511];
}

// Main function that calls all functions below in a chronological order.
- (void)HuffZipDecodeMain:(const char *)filepath;

// Loads contents of file into RAM.
- (void)readFile:(const char *)filepath;

// Creates a trie based on the unique binary codes for each unique ascii saved
// at the beginning of the compressed file.
- (void)getPaths;

// Reads compressed file bit by bit in a single pass. Uses trie to reconstruct
// ascii values from the compressed binary codes. Writes uncompressed ascii
// values to the decompressed data stream.
- (void)decodeFile;

// Writes the decompressed data stream to a file saved on the disk.
- (void)writeFile:(const char *)filepath;

// Deallocates memory allocated during the execution of HuffZipDecodeMain.
- (void)HuffZipDecodeDestructor;

@end
