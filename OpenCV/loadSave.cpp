#include <opencv2/opencv.hpp>
#include <stdio.h>

using namespace cv;

int main (int argc, char** argv)
{
  char* imageName = argv[1];
  Mat image;
  image = imread(imageName, 1);

  if (argc != 2 || !image.data)
  {
    printf("No image data \n");
    return -1;
  }

  Mat gray_image;
  cvtColor(image, gray_image, COLOR_BGR2GRAY);
  imwrite("gray.jpg", gray_image);
  namedWindow(imageName, WINDOW_AUTOSIZE);
  namedWindow("Gray", WINDOW_AUTOSIZE);
  imshow(imageName, image);
  imshow("Gray", gray_image);
  waitKey(0);
  return 0;
}
