#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_WIDTH 3

void fillMatrix(float *A, int A_height, int A_width);
void printMatrix(float *A, int A_height, int A_width);
void tileddMat(int A_width, int A_height);

int main(int argc, char const *argv[])
{
        // Create matrix
        int A_width = 9;
        int A_height = 9;
        float *A = (float*) malloc(A_width * A_height * sizeof(float));
        fillMatrix(A, A_height, A_with);
        tiledMat(A_with, A_height);
        return 0;
}

void fillMatrix(float *A, int A_height, int A_width)
{
  int size = A_height * A_width;
  for(int i = 0; i < size; i++)
    A[i] = (float) i + 1;
}

void printMatrix(float *A, int A_height, int A_width)
{
  int size = A_height * A_width;
  for (int i = 0; i < A_height; i++)
  {
    for (int j = 0; j < A_width; j++)
    {
      printf("%d\t", (int)A[i * A_width + j]);
    }
    printf("\n");
  }
}

void tiledMat(int A_width, int A_height)
{
        dim3 blockDim(BLOCK_WIDTH, BLOCK_WIDTH);
        dim3 griDim(A_width / blockDim.x, A_height / blockDim.y);
}
