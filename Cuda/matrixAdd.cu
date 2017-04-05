#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define N 10

void addMatrices(float *h_A, float *h_B, float *h_C);
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

void addMatrices(float *h_A, float *h_B, float *h_C)
{
    int size = N * N;
    int d_size = N * N * sizeof(float);}
    float *d_A, *d_B, *d_C;

    // Allocate device memory for A, B, and C
    // copy h_A and h_B to device memory
    cudaError_t err = cudaMalloc((void**) &d_A, size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMalloc((void**) &d_B, size);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    cudaMalloc((void**) &d_C, size);

    // Kernel launch code - to have the device to perform the actual matrix addition

    // copy C from the device memory
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Free device vector (which represents our matrices)
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    for (int i = 0; i < size; i++)
    {
      h_C[i] = h_A[i] + h_B[i];
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
