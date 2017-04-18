#include <stdlib.h>

#define N 5

void fillMatrix(float *h_A, int size);

int main(int argc, char const *argv[]) {
  // Input matrix h_B and input vector h_C
  float *h_B = (float *) malloc(N * N * sizeof(float));
  float *h_C = (float *) malloc(N * sizeof(float));

  // Result vector h_A
  float *h_A = (float *) malloc(N * sizeof(float));

  // Fill vector h_C and matrix h_B
  fillMatrix(h_A, N * N);
  return 0;
}

void fillMatrix(float *h_A, int size);
{
  for (int i = 0; i < size; i++)
    h_A[i] = i + 1;
}
