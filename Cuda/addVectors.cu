#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

const int size = 1000;

void fillVectors(float *A);
void printVector(float *V);
void sumVectors(float *A, float *B, float *C);
//void vecAddKernel(float *A, float *B, float *C);

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
    printf("%d ", (int)V[i]);
  printf("\n");
}

__global__
void vecAddKernel(float *A, float *B, float *C)
{
  int i = threadIdx.x + blockDim.x * blockIdx.x;
  if (i < size)
    C[i] = A[i] + B[i];
}

void sumVectors(float *A, float *B, float *C) {
  int n = size * sizeof(float);
  float *d_A, *d_B, *d_C;

  // Allocate device memory for A, B, and C
  // copy A and B to device memory
  cudaMalloc((void**)&d_A, n);
  cudaMemcpy(d_A, A, n, cudaMemcpyHostToDevice);
  cudaMalloc((void**)&d_B, n);
  cudaMemcpy(d_B, B, n, cudaMemcpyHostToDevice);
  cudaMalloc((void**)&d_C, n);

  // Kernel launch code - to have the device to perform the actual vector addition
  // Run ceil(size/256) blocks of 256 threads each
  vecAddKernel <<< ceil(size/256.0), 256 >>> (d_A, d_B, d_C);

  // copy C from the device memory
  cudaMemcpy(C, d_C, n, cudaMemcpyDeviceToHost);

  // Free device vectors
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}
