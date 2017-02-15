#include <stdio.h>
#include <time.h>

const long int M = 2;
const long int N = 2;
const long int O = 1;

void fillMatrix(long long int *A, long long int sizeA);
void printMatrix(long long int *A, long long int sizeA, long long int N);
//void multiMatrices(int A[][N], int B[][O], int C[][O]);

int main(int argc, char const *argv[]) {
  //Creting the sizes
  long long int sizeA = M * N;
  long long int sizeB = M * O;
  long long int sizeC = M * O;

  //Creating the matrices
  long long int A[M*N];
  long long int B[N*O];
  long long int C[M*O];

  //Filling the matrices with secuencial numbers
  fillMatrix(A, sizeA);
  fillMatrix(B, sizeB);
  fillMatrix(C, sizeC);

  /*//Calculating the dot product of matrices A and B and saving the result in C and timing the process
  clock_t begin = clock();
  multiMatrices(A, B, C);
  clock_t end = clock();
  double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;*/
  //printf("Time spent: %f\n", time_spent);
  return 0;
}

void fillMatrix(long long int *A, long long int sizeA)
{
  for (long long int i = 0; i < sizeA; i++)
    A[i] = i+1;
}

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


/*
void fillMatrixB(int B[][O])
{
  int num = 1;
  for (int i = 0; i < N; i++)
    for (int j = 0; j < O; j++)
    {
      B[i][j] = num;
      num++;
    }
}

void multiMatrices(int A[][N], int B[][O], int C[][O])
{
  int temp = 0;
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < O; j++) {
      for (int k = 0; k < N; k++) {
        temp = temp + A[i][k] * B[j][k];
      }
      C[i][j] = temp;
      temp = 0;
    }
  }
}

*/
