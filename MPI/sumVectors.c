#include <stdio.h>
#include <stdlib.h>

const int size = 1000000000;

void fillVectors(int *A);
void printVector(int *V);
//void sumVectors(int *A, int *B, int *C);

int main(int argc, char const *argv[]) {
  int *A = (int *) malloc(size * sizeof(int));
  int *B = (int *) malloc(size * sizeof(int));
  int *C = (int *) malloc(size * sizeof(int));
//  int *C;
//  B = (int *) malloc(size);
//  C = (int *) malloc(size);
  fillVectors(A);
  fillVectors(B)
  //sumVectors(A, B, C);
  //printVector(A);

  // printVector(B);
  //printVector(C);
  free(A);
  free(B);
  free(C);
  return 0;
}


void fillVectors(int *A) {
  for (int i = 0; i < size; i++)  {
    A[i] = i + 1;
  }
}

void printVector(int *V) {
  for (int i = 0; i < size; i++)
    printf("%d ", V[i]);
  printf("\n");
}

/*
void sumVectors(int *A, int *B, int *C) {
    for (int i = 0; i < size; i++)
      C[i] = A[i] + B[i];
}*/
