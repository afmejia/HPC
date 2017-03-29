#include <stdio.h>
#include <stdlib.h>

const int size = 10;

void fillVectors(float *A);
void printVector(float *V);
void sumVectors(float *A, float *B, float *C);

int main(int argc, char const *argv[]) {
  float *A = (float *) malloc(size * sizeof(float));
  float *B = (float *) malloc(size * sizeof(float));
  float *C = (float *) malloc(size * sizeof(float));
//  int *C;
//  B = (int *) malloc(size);
//  C = (int *) malloc(size);
  fillVectors(A);
  fillVectors(B);
  sumVectors(A, B, C);
  printVector(A);
  printVector(B);
  printVector(C);
  free(A);
  free(B);
  free(C);
  return 0;
}


void fillVectors(float *A) {
  for (int i = 0; i < size; i++)  {
    A[i] = i + 1;
  }
}

void printVector(float *V) {
  for (int i = 0; i < size; i++)
    printf("%f ", V[i]);
  printf("\n");
}


void sumVectors(float *A, float *B, float *C) {
  //int n = size * sizeof(float);
  //int *d_A, *d_B, *d_C;
    for (int i = 0; i < size; i++)
      C[i] = A[i] + B[i];
}
