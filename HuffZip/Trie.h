//  Copyright © 2015 Matthew Kotila. All rights reserved.
#ifndef TRIE_H_
#define TRIE_H_

typedef struct trieNode {
  unsigned char ascii;
  struct trieNode *left;
  struct trieNode *right;
} trieNode;

#endif
