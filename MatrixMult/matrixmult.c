#include <stdio.h>

const int M = 2;
const int N = 2;
const int O = 1;

void fillMatrix(int A[][N]);
void multiMatrices(int A[][N], int B[][O], int C[][O]);
void printMatrix(int C[][O]);

int main(int argc, char const *argv[]) {
  //Creating the matrices
  int A[M][N];
  int B[N][O];
  int C[M][O];

  //Filling the matrices with secuencial numbers
  fillMatrix(A);
  fillMatrix(B);
  fillMatrix(C);

  //Calculating the dot produc of matrices A and B and saving the result in C
  multiMatrices(A, B, C);

  printMatrix(C);
  return 0;
}

void fillMatrix(int A[][N])
{
  int num = 1;
  for (int i = 0; i < M; i++)
    for (int j = 0; j < N; j++)
    {
      A[i][j] = num;
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

void printMatrix(int C[][O])
{
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < O; j++) {
      printf("%i", C[i][j]);
    }
    printf("\n");
  }
}
