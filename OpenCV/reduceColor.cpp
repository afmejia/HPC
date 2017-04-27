#include <opencv2/opencv.hpp>

#include <iostream>
#include <sstream>

using namespace std;
using namespace cv;

static void help ()
{
  cout
       << "\n--------------------------------------------------------------------------" << endl
       << "This program shows how to scan image objects in OpenCV (cv::Mat). As use case"
       << " we take an input image and divide the native color palette (255) with the "  << endl
       << "input. Shows C operator[] method, iterators and at function for on-the-fly item address calculation."<< endl
       << "Usage:"                                                                       << endl
       << "./reduceColor <imageNameToUse> <divideWith> [G]"                       << endl
       << "if you add a G parameter the image is processed in gray scale"                << endl
       << "--------------------------------------------------------------------------"   << endl
       << endl;
}

Mat& ScanImageAndReduceC(Mat& I, const uchar* table);

int main (int argc, char** argv)
{
  help();

  if (argc < 3)
  {
    cout << "Not enough parameters" << endl;
    return -1;
  }

  Mat I, J;

  if (argc == 4 && !strcmp(argv[3], "[G]"))
    I = imread(argv[1], IMREAD_GRAYSCALE)
  else
    I = imread(argv[1], IMREAD_COLOR);

  if (I.empty())
  {
    cout << "Not enough parameters" << endl;
    return -1;
  }

  int divideWith = 0; // convert our input string to number - C++ style
  stringstream s;
  s << argv[2];
  s >> divideWith;

  if (!s || !divideWith)
  {
    cout << "Invalid number entered for dividing. " << endl;
    return -1;
  }

  uchar table[256];

  for (int i = 0, i < 256, i++)
    table[i] = (uchar)(divideWith * (i / divideWith));

  const int times = 100;
  double t;
  t = (double)getTickCount();

  for (int i = 0; i < times; i++)
  {
    Mat clone_i = I.clone();
    J = ScanImageAndReduceIterator(clone_i, table);
  }
}

Mat& ScanImageAndReduceC(Mat& I, const uchar* const table)
{
  // Accept only char type matrices
  CV_Assert(I.depth() == CV_8U);
}
