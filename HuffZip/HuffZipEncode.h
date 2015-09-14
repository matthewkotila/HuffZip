//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <Cocoa/Cocoa.h>

typedef struct heapNode heapNode;

// Main class for compression component of application. Instantiated by the view
// controller.
@interface HuffZipEncode : NSObject {
 @private
  unsigned int codes[256];
  unsigned char codeLengths[256];
  unsigned long fileLength;
  unsigned long encodedLength;
  unsigned char *fileContents;
  unsigned char *encodedContents;
  unsigned char destructorIndex;
  heapNode *destructorList[255];
}

// Main function that calls all functions below in a chronological order.
- (void)HuffZipEncodeMain:(const char *)filepath;

// Loads contents of file into RAM.
- (void)readFile:(const char *)filepath;

// Creates custom heapNode objects containing a certain ascii value and frequency
// of that ascii value in file. Inserts heapNodes into binary heap to sort frequencies.
// Assigns parent of two least frequent ascii value nodes to newly created node and
// repeats until no nodes are left -> Huffman tree created.
- (void)constructTree;

// Traverses Huffman binary tree to create binary code for each unique ascii value.
- (void)getEncodings:(heapNode *)root :(unsigned char)place :(unsigned int)slate;

// Writes each unique binary code mapping for each unique ascii value at the beginning
// of the compressed data stream for future decompressing.
- (void)saveEncodings;

// Goes through uncompressed file in a single pass and writes compressed version of
// each ascii value into the compressed data stream.
- (void)encodeFile;

// Writes the compressed data stream to a file saved on the disk.
- (void)writeFile:(const char *)filepath;

// Deallocates memory allocated during the execution of HuffZipEncodeMain.
- (void)HuffZipEncodeDestructor;

@end
