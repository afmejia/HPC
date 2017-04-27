#include <iostream>

using namespace std;

int main (int argc, char** argv)
{
  int number = 10;
  unsigned char table[256];

  for (int i = 0; i < 256; i++)
    table[i] = (unsigned char)(number * (i / number));

  for (int i = 0; i < 256; i++)
    cout << table[i] << " ";

  cout << endl;
}
