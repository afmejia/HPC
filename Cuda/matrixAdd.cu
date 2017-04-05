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
  //printMatrix(A);
  //printMatrix(B);
  printMatrix(C);
  free(A);
  free(B);
  free(C);
  return 0;
}

__global__
void matAddKernel(float *A, float *B, float *C, int size)
{
  int i = threadIdx.x + blockDim.x * blockIdx.x;
  if (i < size)
    C[i] = A[i] + B[i];
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
    int d_size = N * N * sizeof(float);
    float *d_A, *d_B, *d_C;

    // Allocate device memory for A, B, and C
    // copy h_A and h_B to device memory
    cudaMalloc((void**)&d_A, d_size);
    cudaMalloc((void**)&d_B, d_size);
    cudaMalloc((void**)&d_C, d_size);
    /*cudaError_t err = cudaMalloc((void**) &d_A, size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }*/
    cudaMemcpy(d_A, h_A, d_size, cudaMemcpyHostToDevice);

    /*err = cudaMalloc((void**) &d_B, size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }*/
    cudaMemcpy(d_B, h_B, d_size, cudaMemcpyHostToDevice);

    /*err = cudaMalloc((void**) &d_C, d_size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }*/

    // Kernel launch code - to have the device to perform the actual matrix addition
    matAddKernel<<<ceil(size/256.0), 256>>>(d_A, d_B, d_C, size);

    // copy C from the device memory
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Free device vector (which represents our matrices)
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
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
  printf("\n");
}

