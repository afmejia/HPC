#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_WIDTH 2

void fillMatrix(float *A, int A_height, int A_width);
void printMatrix(float *A, int A_height, int A_width);
void tiledMat(float *A, float *result, int A_width, int A_height);

int main(int argc, char const *argv[])
{
        // Create matrix
        int A_width = 4;
        int A_height = 4;
        float *A = (float*) malloc(A_width * A_height * sizeof(float));
        float *result = (float*) malloc(A_width * A_height * sizeof(float));
        fillMatrix(A, A_height, A_width);
        printMatrix(A, A_height, A_width);
        tiledMat(A, result, A_width, A_height);
        printMatrix(result, A_height, A_width);
        free(A);
        return 0;
}

__global__
void blockTranspose(float *A_elements, int A_width, int A_height)
{
        __shared__ float blockA[BLOCK_WIDTH][BLOCK_WIDTH];
        int BLOCK_SIZE = BLOCK_WIDTH;
        int baseIdx = blockIdx.x * BLOCK_SIZE + threadIdx.x;
        baseIdx += (blockIdx.y * BLOCK_SIZE + threadIdx.y) * A_width;
        blockA[threadIdx.y][threadIdx.x] = A_elements[baseIdx];
        A_elements[baseIdx] = blockA[threadIdx.x][threadIdx.y];
}

void fillMatrix(float *A, int A_height, int A_width)
{
        int size = A_height * A_width;
        for(int i = 0; i < size; i++)
                A[i] = (float) i + 1;
}

void printMatrix(float *A, int A_height, int A_width)
{
        for (int i = 0; i < A_height; i++)
        {
                for (int j = 0; j < A_width; j++)
                {
                        printf("%d\t", (int)A[i * A_width + j]);
                }
                printf("\n");
        }
}

void tiledMat(float *A, float *result, int A_width, int A_height)
{
        // Create device matrix
        float *d_A;
        int A_size = A_width * A_height * sizeof(float);
        cudaError_t err = cudaMalloc((void **) &d_A, A_size);
        if (err != cudaSuccess)
        {
                printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
                exit(EXIT_FAILURE);
        }
        cudaMemcpy(d_A, A, A_size, cudaMemcpyHostToDevice);

        // Launch the kernel
        dim3 blockDim(BLOCK_WIDTH, BLOCK_WIDTH);
        dim3 griDim(A_width / blockDim.x, A_height / blockDim.y);
        blockTranspose<<<griDim, blockDim>>>(d_A, A_width, A_height);
        cudaMemcpy(result, d_A, A_size, cudaMemcpyDeviceToHost);
        cudaFree(d_A);
}
