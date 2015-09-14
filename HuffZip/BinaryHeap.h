//  Copyright © 2015 Matthew Kotila. All rights reserved.
typedef struct heapNode {
  unsigned char ascii;
  unsigned int freq;
  struct heapNode *left;
  struct heapNode *right;
} heapNode;

@interface BinaryHeap : NSObject {
@public
  int size;
  heapNode* array[511];
}

- (void)heapify;

- (void)getAndDeleteMin:(heapNode**)x;

- (void)insert:(heapNode*)x;

- (void)bubbleDown:(int)hole;

@end

@implementation BinaryHeap

- (id)init {
  if (self = [super init]) {
    return self;
  }
  else
    return nil;
}

- (void)heapify {
  for (int i = size / 2; i >= 0; i--)
    [self bubbleDown:i];
}

- (void)insert:(heapNode*)x {
  int spot = size++;
  for (; spot > 0 && x->freq < array[(spot - 1) / 2]->freq; spot = (spot - 1) / 2)
    array[spot] = array[(spot - 1) / 2];
  array[spot] = x;
}

- (void)getAndDeleteMin:(heapNode**)x {
  *x = array[0];
  array[0] = array[--size];
  [self bubbleDown:0];
}

- (void)bubbleDown:(int)spot {
  int child;
  heapNode* temp = array[spot];
  for (; (spot * 2) + 1 < size; spot = child) {
    child = (spot * 2) + 1;
    if (child != (size - 1) && array[child + 1]->freq < array[child]->freq)
      child++;
    if (array[child]->freq < temp->freq)
      array[spot] = array[child];
    else
      break;
  }
  array[spot] = temp;
}

@end
