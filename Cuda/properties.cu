#include <stdio.h>

int main(int argc, char const *argv[]) {
  int dev_count;
  cudaGetDeviceCount(&dev_count);
  printf("There are %d cuda Devices\n", dev_count);
  return 0;
}
