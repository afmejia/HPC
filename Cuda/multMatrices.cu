#include <stdio.h>
#include <time.h>

const long int M = 10;
const long int N = 10;
const long int O = 10;
#define BLOCK_WIDTH 16

void fillMatrix(float *A, long long int sizeA);
void printMatrix(float *A, long long int sizeA, long long int N);
float getValue(float *A, long long int i, long long int j, long long int cols);
void setValue(float *A, long long int i, long long int j, float value);
void multiMatricesCPU(float *A, float *B, float *C);
void multiMatricesGPU(float *A, float *B, float *C);

int main(int argc, char const *argv[])
{
        //Creting the sizes
        long long int sizeA = M * N;
        long long int sizeB = M * O;
        long long int sizeC = M * O;

        //Creating the matrices
        float A[sizeA];
        float B[sizeB];
        float C[sizeC];

        //Filling the matrices with secuencial numbers
        fillMatrix(A, sizeA);
        fillMatrix(B, sizeB);
        fillMatrix(C, sizeC);

        // Multiplying A and B
        //multiMatricesCPU(A, B, C);
        multiMatricesGPU(A, B, C);
        //printMatrix(A, sizeA, N);
        printMatrix(C, sizeC, O);
        return 0;
}

__global__ void matrixMultKernel (float *d_A, float *d_B, float *d_C, int N)
{
  // Calculate the row index of the d_C element and d_A
  int row = blockIdx.y * blockDim.y + threadIdx.y;

  // Calculate the column index of d_C and d_B
  int col = blockIdx.x * blockDim.x + threadIdx.x;

  if ((row < N) && (col < N))
  {
    float Cvalue = 0;
    for (int k = 0; k < N; k++)
      Cvalue += d_A[row * N + k] * d_B[k * N + col];
    d_C[row * N + col] = Cvalue;
  }
}

void fillMatrix(float *A, long long int sizeA)
{
        for (long long int i = 0; i < sizeA; i++)
                A[i] = i+1;
}

// Get the value in the position (i, j) in matrix A
float getValue(float *A, long long int i, long long int j, long long int cols)
{
        return A[cols * i + j];
}

// Set the value on the position (i, j) of matrix A
void setValue(float *A, long long int i, long long int j, float value)
{
        A[O * i + j] = value;
}

// Print the entire matrix A
void printMatrix(float *A, long long int sizeA, long long int N)
{
        for (long long int i = 0; i < sizeA; i++)
        {
                if (i % N == 0 && i != 0)
                        printf("\n");
                printf("%d ", (int) A[i]);
        }
        printf("\n");
}

// Computes the multiplications between matrices A and B and stores the result on Matrix C
void multiMatricesCPU(float *A, float *B, float *C)
{
        long long int temp = 0;
        for (long long int i = 0; i < M; i++)
        {
                for (long long int j = 0; j < O; j++)
                {
                        for (long long int k = 0; k < N; k++)
                        {
                                temp = temp + getValue(A, i, k, N) * getValue(B, k, j, O);
                        }
                        setValue(C, i, j, temp);
                        temp = 0;
                }
        }
}

void multiMatricesGPU(float *h_A, float *h_B, float *h_C)
{
        // Define sizes of matrices in device memory
        int A_size = N * N * sizeof(float);
        int B_size = A_size;
        int C_size = A_size;

        // Create device matrices
        float *d_A, *d_B, *d_C;

        // Allocate device memory for matrices
        // copy host matrices to device matrices
        cudaError_t err = cudaMalloc((void **) &d_A, A_size);
        if (err != cudaSuccess)
        {
                printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
                exit(EXIT_FAILURE);
        }
        cudaMemcpy(d_A, h_A, A_size, cudaMemcpyHostToDevice);

        err = cudaMalloc((void **) &d_B, B_size);
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

        // Launch kernel
        int NumBlocks = N / BLOCK_WIDTH;
        if (N % BLOCK_WIDTH)
                NumBlocks++;
        dim3 dimGrid(NumBlocks, NumBlocks);
        dim3 dimBlock(BLOCK_WIDTH, BLOCK_WIDTH);
        matrixMultKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_C, N);

        // Put results again on host conrainers
        cudaMemcpy(h_C, d_C, C_size, cudaMemcpyDeviceToHost);
        cudaFree(d_A);
        cudaFree(d_B);
        cudaFree(d_C);
}

