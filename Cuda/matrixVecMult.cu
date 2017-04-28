#include <cuda.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define N 5

void fillMatrix(float *h_A, int size);
void mult(float *h_B, float *h_C, float *h_A, int n);
void printVector(float *h_A, int size);

int main(int argc, char const *argv[]) {
  // Input matrix h_B and input vector h_C
  float *h_B = (float *) malloc(N * N * sizeof(float));
  float *h_C = (float *) malloc(N * sizeof(float));

  // Result vector h_A
  float *h_A = (float *) malloc(N * sizeof(float));

  // Fill vector h_C and matrix h_B
  fillMatrix(h_C, N);
  fillMatrix(h_B, N * N);

  // Save dot product between h_B and h_C in h_A
  mult(h_B, h_C, h_A, N);

  // Print the result vector
  printVector(h_A, N);

  //Free host memory
  free(h_A);
  free(h_B);
  free(h_C);

  return 0;
}

__global__
void dotProduct(float *d_B, float *d_C, float *d_A, int n)
{
  float temp = 0;
  int i = threadIdx.x + blockDim.x * blockIdx.x;
  if (i < n)
  {
    for (int j = 0; j < n; j++)
      temp = temp + (d_B[i * n + j] * d_C[j]);
    d_A[i] = temp;
  }
}

void fillMatrix(float *h_A, int size)
{
  for (int i = 0; i < size; i++)
    h_A[i] = i + 1;
}

void mult(float *h_B, float *h_C, float *h_A, int n)
{
  // Define sizes of matrix and vectors in device memory
  int B_size = N * N * sizeof(float);
  int C_size = N * sizeof(float);

  // Create device arrays
  float *d_A, *d_B, *d_C;

  // Allocate device memory for A, B, and C
  // copy h_B and h_C to device memory
  cudaError_t err = cudaMalloc((void **) &d_B, B_size);
  if (err != cudaSuccess)
  {
    printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
    exit(EXIT_FAILURE);
  }
  cudaMemcpy(d_B, h_B, B_size, cudaMemcpyHostToDevice);

  err = cudaMalloc((void **) &d_C, C_size);
  if (err != cudaSuccess)
  {
    printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
    exit(EXIT_FAILURE);
  }
  cudaMemcpy(d_C, h_C, C_size, cudaMemcpyHostToDevice);

  err = cudaMalloc((void **) &d_A, C_size);
  if (err != cudaSuccess)
  {
    printf("%s in %s at line %d", cudaGetErrorString(err), __FILE__, __LINE__);
    exit(EXIT_FAILURE);
  }

  // Launch kernel for each row
  dotProduct<<<ceil(n / 256.0), 256>>>(d_B, d_C, d_A, n);

  // Copy the result vector from devive to host
  cudaMemcpy(h_A, d_A, C_size, cudaMemcpyDeviceToHost);

  // Free device memory
  cudaFree(d_A);
  cudaFree(d_C);
  cudaFree(d_B);
}

void printVector(float *h_A, int size)
{
  for (int i = 0; i < size; i++)
    printf("%d ", (int)h_A[i]);
  printf("\n");
}

