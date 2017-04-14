#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define N 1000

void addMatrices(float *h_A, float *h_B, float *h_C);
void fillMatrix(float *h_A);
void printMatrix(float *A);

int main(int argc, char const *argv[]) {
  float *h_A = (float *) malloc(N * N * sizeof(float));
  float *h_B = (float *) malloc(N * N * sizeof(float));
  float *h_C = (float *) malloc(N * N * sizeof(float));
  fillMatrix(h_A);
  fillMatrix(h_B);
  addMatrices(h_A, h_B, h_C);
  printMatrix(h_C);
  free(h_A);
  free(h_B);
  free(h_C);
  return 0;
}

__global__
void matAddKernel(float *d_A, float *d_B, float *d_C, int size)
{
  int i = threadIdx.x + blockDim.x * blockIdx.x;
  int element;
  if (i < size)
  {
    for (int j = 0; j < size; j++)
    {
      element = i * size + j;
      d_C[element] = d_A[element] + d_B[element];
      //printf("Element %d from thread %d\n", element, i);
    }
  }
}

void fillMatrix(float *h_A)
{
  int size = N * N;
  for (int i = 0; i < size; i++)
  {
    h_A[i] = i + 1;
  }
}

void addMatrices(float *h_A, float *h_B, float *h_C)
{
    int size = N * N;
    int d_size = size * sizeof(float);
    float *d_A, *d_B, *d_C;

    // Allocate device memory for A, B, and C
    // copy h_A and h_B to device memory
    cudaError_t err = cudaMalloc((void**) &d_A, d_size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }
    cudaMemcpy(d_A, h_A, d_size, cudaMemcpyHostToDevice);

    err = cudaMalloc((void**) &d_B, d_size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }
    cudaMemcpy(d_B, h_B, d_size, cudaMemcpyHostToDevice);

    err = cudaMalloc((void**) &d_C, d_size);
    if (err != cudaSuccess)
    {
      printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
      exit(EXIT_FAILURE);
    }

    // Kernel launch code - to have the device to perform the actual matrix addition
    matAddKernel<<<ceil((N)/256.0), 256>>>(d_A, d_B, d_C, N);

    // copy C from the device memory
    cudaMemcpy(h_C, d_C, d_size, cudaMemcpyDeviceToHost);

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
}

