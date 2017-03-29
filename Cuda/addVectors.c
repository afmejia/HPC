#include <stdio.h>

#define N 10

void add (int *a, int *b, int *c);
void printVector(int *a);

int main (void)
{
  int a[N], b[N], c[N];

  // Fill the arrays 'a' and 'b' on the CPU
  for (int i = 0; i < N; i++)
  {
    a[i] = -i;
    b[i] = i * i;
  }

  add(a, b, c);
  printVector(c);
}

void add(int *a, int *b, int *c)
{
  int tid = 0;  // This is CPU zero, so we start at zero
  while (tid < N)
  {
      c[tid] = a[tid] + b[tid];
      tid += 1;  // We have one CPU, so we increment by one
  }
}

void printVector(int *a) {
  for (int i = 0; i < N; i++)
    printf("%d ", a[i]);
  printf("\n");
}
