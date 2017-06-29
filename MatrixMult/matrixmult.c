#include <stdio.h>
#include <time.h>

const long int M = 10;
const long int N = 10;
const long int O = 10;

void fillMatrix(long long int *A, long long int sizeA);
void printMatrix(long long int *A, long long int sizeA, long long int N);
long long int getValue(long long int *A, long long int i, long long int j, long long int cols);
void setValue(long long int *A, long long int i, long long int j, long long int value);
void multiMatrices(long long int *A, long long int *B, long long int *C);

int main(int argc, char const *argv[])
{
  //Creting the sizes
  long long int sizeA = M * N;
  long long int sizeB = M * O;
  long long int sizeC = M * O;

  //Creating the matrices
  long long int A[sizeA];
  long long int B[sizeB];
  long long int C[sizeC];

  //Filling the matrices with secuencial numbers
  fillMatrix(A, sizeA);
  fillMatrix(B, sizeB);
  fillMatrix(C, sizeC);

  // Multiplying A and B
  multiMatrices(A, B, C);
  printMatrix(A, sizeA, N);
  printMatrix(C, sizeC, O);
  return 0;
}

void fillMatrix(long long int *A, long long int sizeA)
{
  for (long long int i = 0; i < sizeA; i++)
    A[i] = i+1;
}

// Get the value in the position (i, j) in matrix A
long long int getValue(long long int *A, long long int i, long long int j, long long int cols)
{
  return A[cols * i + j];
}

// Set the value on the position (i, j) of matrix A
void setValue(long long int *A, long long int i, long long int j, long long int value)
{
  A[O * i + j] = value;
}

// Print the entire matrix A
void printMatrix(long long int *A, long long int sizeA, long long int N)
{
  for (long long int i = 0; i < sizeA; i++)
  {
    if (i % N == 0 && i != 0)
      printf("\n");
    printf("%lld ", A[i]);
  }
  printf("\n");
}

// Computes the multiplications between matrices A and B and stores the result on Matrix C
void multiMatrices(long long int *A, long long int *B, long long int *C)
{
  long long int temp = 0;
  for (long long int i = 0; i < M; i++)
  {
    for (long long int j = 0; j < O; j++)
    {
      for (long long int k = 0; k < N; k++)
      {
        temp = temp + getValue(A, i, k, N) * getValue(B, k, j, O);
        //printf("A[%lld][%lld] = %lld\n", i, k, getValue(A, i, k));
        //printf("B[%lld][%lld] = %lld\n", k, j, getValue(B, k, j));

        //printf("A[%lld][%lld] * B[%lld][%lld] = %lld\n", i, k, k, j, temp);
        //printf("%lld, %lld, %lld\n", i, j, k);
        //printf("%lld * %lld \n", getValue(A, i, k), getValue(B, k, j));
        //printf("%lld \n", temp);
      }
      setValue(C, i, j, temp);
      temp = 0;
    }
  }
}
