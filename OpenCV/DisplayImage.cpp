#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <vector>

using namespace cv;
using namespace std;

int main(int argc, char** argv )
{
    if ( argc != 2 )
    {
        printf("usage: DisplayImage.out <Image_Path>\n");
        return -1;
    }

    Mat image;
    image = imread( argv[1], CV_LOAD_IMAGE_COLOR);

    if ( !image.data )
    {
        printf("No image data \n");
        return -1;
    }
    namedWindow("Display Image", WINDOW_AUTOSIZE );
    imshow("Display Image", image);

    size_t size = image.rows * image.cols * 3;

    // vector<unsigned char> imageFilter(size);
    // for (int i = 0; i < size; i++)
    // {
    //   imageFilter[i] = image.data[i];
    //
    // }
    /*
    vector<unsigned char> imageFilter(size);
    std::memcpy(&imageFilter[0], image.data, size);*/

    vector<unsigned char> imageFilter(image.data, image.data + size);

    for (size_t i = 0; i < size; i += 3)
    {
      imageFilter[i] = imageFilter[i] * 2;
      imageFilter[i + 1] = imageFilter[i + 1] * 2;
      imageFilter[i + 2] = imageFilter[i + 2] * 2;
    }

    Mat multTwoImage(image.rows, image.cols, CV_8UC3, imageFilter.data());
    imshow("Display Image 2", multTwoImage);

    vector<unsigned char> imageGray;
    imageGray.reserve(image.rows * image.cols);

    for (size_t i = 0; i < size; i += 3)
    {
      unsigned char pixel_gray = image.data[i] * 0.0722 +
                                 image.data[i + 1] * 0.7152 +
                                 image.data[i + 2] * 0.2126;
      imageGray.push_back(pixel_gray);
    }

    Mat grayImage(image.rows, image.cols, CV_8UC1, imageGray.data());
    imshow("Display Image 3", grayImage);

    waitKey(0);

    return 0;
}
