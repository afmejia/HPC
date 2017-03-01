#include <stdio.h>

const int size = 100;

void fillVectors(int *A, int *B);
void printVector(int *V);
void sumVectors(int *A, int *B, int *C);

int main(int argc, char const *argv[]) {
  int A[size];
  int B[size];
  int C[size];
  fillVectors(A, B);
  sumVectors(A, B, C);
  printVector(C);
  return 0;
}

void fillVectors(int *A, int *B) {
  for (int i = 0; i < size; i++)  {
    A[i] = i + 1;
    B[i] = i + 1;
  }
}

void printVector(int *V) {
  for (int i = 0; i < size; i++)
    printf("%d ", V[i]);
}

void sumVectors(int *A, int *B, int *C) {
    for (int i = 0; i < size; i++)
      C[i] = A[i] + B[i];
}
