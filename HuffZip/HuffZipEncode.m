//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "HuffZipEncode.h"
#import <sys/stat.h>
#import "BinaryHeap.h"

@implementation HuffZipEncode

- (void)HuffZipEncodeMain:(const char *)filepath {
  [self readFile:filepath];
  [self constructTree];
  [self saveEncodings];
  [self encodeFile];
  [self writeFile:filepath];
  [self HuffZipEncodeDestructor];
}

- (void)readFile:(const char *)filepath {
  struct stat st;
  stat(filepath, &st);
  fileLength = st.st_size;
  fileContents = (unsigned char*)malloc(st.st_size);
  FILE *file = fopen(filepath, "r");
  fread(fileContents, 1, st.st_size, file);
  fclose(file);
}

- (void)constructTree {
  heapNode leaves[256];
  memset(leaves, 0, sizeof(heapNode) * 256);
  for (int i = 0; i < fileLength; i++)
    leaves[fileContents[i]].freq++;
  
  BinaryHeap *heap = [[BinaryHeap alloc] init];
  int j = 0;
  for (int i = 0; i < 256; i++) {
    if (leaves[i].freq != 0) {
      heap->array[j++] = &leaves[i];
      leaves[i].ascii = i;
    }
  }
  heap->size = j;
  [heap heapify];
  
  destructorIndex = 0;
  heapNode *root = NULL;
  while (heap->size > 1) {
    root = (heapNode*)malloc(sizeof(heapNode));
    destructorList[destructorIndex++] = root;
    [heap getAndDeleteMin:&root->left];
    [heap getAndDeleteMin:&root->right];
    root->freq = root->left->freq + root->right->freq;
    [heap insert:root];
  }
  
  memset(codes, 0, sizeof(unsigned int) * 256);
  memset(codeLengths, 0, sizeof(unsigned char) * 256);
  [self getEncodings:root :0 :0];
}

- (void)getEncodings:(heapNode *)rootNode :(unsigned char)place :(unsigned int)slate {
  if (rootNode->left) {
    [self getEncodings:rootNode->left :place + 1 :slate];
  }
  
  if (rootNode->right) {
    slate |= (1 << place);
    [self getEncodings:rootNode->right :place + 1 :slate];
  }
  
  if (!rootNode->right && !rootNode->left) {
    codes[rootNode->ascii] = slate;
    codeLengths[rootNode->ascii] = place;
  }
}

- (void)saveEncodings {
  encodedContents = (unsigned char *)malloc(fileLength * 2);
  encodedLength = 1;
  for (int i = 0; i < 256; i++) {
    if (codeLengths[i] != 0) {
      encodedContents[encodedLength++] = i;
      encodedContents[encodedLength++] = codeLengths[i];
      memcpy(&encodedContents[encodedLength], &codes[i], 4);
      encodedLength += 4;
    }
  }
  encodedContents[encodedLength++] = 0;
}

- (void)encodeFile {
  unsigned long buffer = 0;
  unsigned char bufferLength = 0;
  for (int i = 0; i < fileLength; i++) {
    buffer |= (codes[fileContents[i]] << bufferLength);
    bufferLength += codeLengths[fileContents[i]];
    while (bufferLength >= 8) {
      encodedContents[encodedLength++] = buffer;
      buffer >>= 8;
      bufferLength -= 8;
    }
  }
  encodedContents[encodedLength++] = buffer;
  encodedContents[0] = bufferLength;
}

- (void)writeFile:(const char *)filepath {
  NSString *newFilepath = [[NSString stringWithUTF8String:filepath] stringByAppendingPathExtension:@"hzip"];
  for (int i = 2; [[NSFileManager defaultManager] fileExistsAtPath:newFilepath]; i++) {
    newFilepath = [[newFilepath stringByDeletingLastPathComponent] stringByAppendingFormat:@"/%@ %i.hzip", [[NSString stringWithUTF8String:filepath] lastPathComponent], i];
  }
  FILE *file = fopen([newFilepath UTF8String], "w");
  fwrite(encodedContents, 1, encodedLength, file);
  fclose(file);
}

- (void)HuffZipEncodeDestructor {
  free(fileContents);
  free(encodedContents);
  while (destructorIndex > 0)
    free(destructorList[--destructorIndex]);
}

@end
