//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "HuffZipDecode.h"
#import <sys/stat.h>
#import "Trie.h"

@implementation HuffZipDecode

- (void)HuffZipDecodeMain:(const char *)filepath {
  [self readFile:filepath];
  [self getPaths];
  [self decodeFile];
  [self writeFile:filepath];
  [self HuffZipDecodeDestructor];
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

- (void)getPaths {
  root = (trieNode*)calloc(1, sizeof(trieNode));
  destructorList[destructorIndex++] = root;
  trieNode *node;
  for (fileIndex = 1; fileContents[fileIndex] || fileIndex == 1; fileIndex += 6) {
    node = root;
    int length = fileContents[fileIndex + 1];
    unsigned int code;
    memcpy(&code, &fileContents[fileIndex + 2], sizeof(unsigned char) * 4);
    for (unsigned long i = 0, bitChecker = 1; i < length; i++, bitChecker <<= 1) {
      if (code & bitChecker) {
        if (!node->right) {
          node->right = (trieNode*)calloc(1, sizeof(trieNode));
          destructorList[destructorIndex++] = node->right;
        }
        node = node->right;
      }
      else {
        if (!node->left) {
          node->left = (trieNode*)calloc(1, sizeof(trieNode));
          destructorList[destructorIndex++] = node->left;
        }
        node = node->left;
      }
    }
    node->ascii = fileContents[fileIndex];;
  }
  fileIndex++;
}

- (void)decodeFile {
  decodedContents = (unsigned char*)malloc(fileLength * 2);
  decodedLength = 0;
  unsigned char lastBit = fileContents[0];
  unsigned char bitPlace = 0;
  
  while (fileIndex < fileLength - 1 || bitPlace != lastBit) {
    trieNode *node = root;
    while (node->left || node->right) {
      if (fileContents[fileIndex] & (1 << bitPlace++))
        node = node->right;
      else
        node = node->left;
      if (bitPlace > 7) {
        fileIndex++;
        bitPlace = 0;
      }
    }
    decodedContents[decodedLength++] = node->ascii;
  }
}

- (void)writeFile:(const char *)filepath {
  NSString *newFilepath = [[NSString stringWithUTF8String:filepath] stringByDeletingPathExtension];
  for (int i = 2; [[NSFileManager defaultManager] fileExistsAtPath:newFilepath]; i++) {
    newFilepath = [[newFilepath stringByDeletingLastPathComponent] stringByAppendingFormat:@"/%@ %i", [[[NSString stringWithUTF8String:filepath] stringByDeletingPathExtension] lastPathComponent], i];
  }
  FILE *file = fopen([newFilepath UTF8String], "w");
  fwrite(decodedContents, 1, decodedLength, file);
  fclose(file);
}

- (void)HuffZipDecodeDestructor {
  free(fileContents);
  free(decodedContents);
  while (destructorIndex > 0)
    free(destructorList[--destructorIndex]);
}

@end
