#include <opencv2/opencv.hpp>

#include <iostream>
#include <string>

using namespace cv;
using namespace std;

int main(int argc, char** argv) {
  String imageName("data/happyFish.png"); // By default
  if (argc > 1)
    imageName = argv[1];

  Mat image;
  image = imread(imageName, IMREAD_GRAYSCALE);  //Read the file

  if (image.empty())
  {
    cout << "Could not open or find the image" << endl;
    return -1;
  }
  namedWindow("Display window", WINDOW_AUTOSIZE); // Create a window for display.
  imshow("Display window", image);
  waitKey(0); // Wait for a keystroke in the window
  return 0;
}

