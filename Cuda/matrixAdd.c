#include <stdio.h>
#include <stdlib.h>

#define N 10

void addMatrices(float *A, float *B, float *C);
void fillMatrix(float *A);
void printMatrix(float *A);

int main(int argc, char const *argv[]) {
  float *A = (float *) malloc(N * N * sizeof(float));
  float *B = (float *) malloc(N * N * sizeof(float));
  float *C = (float *) malloc(N * N * sizeof(float));
  fillMatrix(A);
  fillMatrix(B);
  addMatrices(A, B, C);
  printMatrix(C);
  free(A);
  free(B);
  free(C);
  return 0;
}

void fillMatrix(float *A)
{
  int size = N * N;
  for (int i = 0; i < size; i++)
  {
    A[i] = i + 1;
  }
}

void addMatrices(float *A, float *B, float *C)
{
    int size = N * N;
    for (int i = 0; i < size; i++)
    {
      C[i] = A[i] + B[i];
    }
}

void printMatrix(float *A)
{
  int size = N * N;
  for (int i = 0; i < size; i++)
  {
    if (i % N == 0 && i != 0)
      printf("\n");
    printf("%d\t", (int)A[i]);
  }
}
