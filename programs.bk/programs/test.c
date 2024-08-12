#include <stdlib.h>
int main() {
  void *buf;
  buf = malloc(0x500);
  void *prevent_consolidate;
  prevent_consolidate = malloc(0x18);
  free(buf);
  void *buf2;
  buf2 = malloc(0x18);
  return 0;
}
