#include <opencv2/opencv.hpp>

#include <iostream>
#include <string>

using namespace std;
using namespace cv;

Mat& filter(Mat& image);

int main(int argc, char const *argv[]) {
  // Load the image
  if (argc != 2)
  {
    cout << "Usage: ./twoFilter.out <Image_Path>" << endl;
    return -1;
  }

  String imageName = argv[1];
	cout << "Image name: " << imageName << endl;
  Mat image;
  image = imread(imageName, IMREAD_COLOR);

  if (image.empty())
  {
    cout << "Could not open or find the image." << endl;
    return -1;
  }

  // Apply filter
  Mat result = image.clone();
  result = filter(image);

  // Show the result
  namedWindow("Image with 2 filter", WINDOW_AUTOSIZE);
  imshow("landscape", result);
  waitKey(0);
  return 0;
}

Mat& filter(Mat& image)
{
  // Accept only char type matrices
  CV_Assert(image.depth() == CV_8U);

  //Create iterator and iterate over the whole image
  MatIterator_<Vec3b> it, end;

  for (it = image.begin<Vec3b>(), end = image.end<Vec3b>(); it != end; ++it)
  {
    (*it)[0] = (*it)[0] * 2;
    (*it)[1] = (*it)[1] * 2;
    (*it)[2] = (*it)[2] * 2;
  }
  return image;
}

