#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

Mat& filter(Mat& image);
Mat& gpuFilter(Mat& image);

int main(int argc, char const *argv[]) {
        // Load the image
        if (argc != 2)
        {
                cout << "Usage: ./twoFilter.out <Image_Path>" << endl;
                return -1;
        }

        String imageName = argv[1];
        Mat image;
        image = imread(imageName, IMREAD_COLOR);

        if (image.empty())
        {
                cout << "Could not open or find the image." << endl;
                return -1;
        }

        // Apply filter
        Mat result = image.clone();
        result = gpuFilter(result);

        //Show image
        /*namedWindow("Original image", WINDOW_AUTOSIZE);
        imshow("landscape", image);
        //namedWindow("Filtered image", WINDOW_AUTOSIZE);
        imshow("filtered landscape", result);
        waitKey(0);*/
        return 0;
}

Mat& filter(Mat& image)
{
        // Accept only char type matrices
        CV_Assert(image.depth() == CV_8U);

        // Create iterator and iterate over the whole image
        MatIterator_<Vec3b> it, end;

        for (it = image.begin<Vec3b>(), end = image.end<Vec3b>(); it != end; ++it)
        {
                (*it)[0] = (*it)[0] * 2;
                (*it)[1] = (*it)[1] * 2;
                (*it)[2] = (*it)[2] * 2;
        }

        return image;
}

Mat& gpuFilter(Mat& image)
{
        // Accept only char type matrices
        CV_Assert(image.depth() == CV_8U);

        // Define image size in the device memory
        int channels = image.channels();
        int cols = image.cols * channels;
        int rows = image.rows;
        int im_size = cols * rows * sizeof(uchar);

        // Flat host image
        uchar* h_img;
        h_img = img.ptr<uchar>(0);

        // Create device image
        uchar* d_img;

        // Allocate device memory for the image
        cudaError_t err = cudaMalloc((void **) &d_img, im_size);
        if (err != cudaSuccess)
        {
          cout << cudaGetErrorString(err) << " in " << __FILE__ << " at line " << __LINE__;
          exit(EXIT_FAILURE);
        }

        // Copy image from host to device
        cudaMemcpy(d_img, h_img, im_size, cudaMemcpyHostToDevice);

        cout << "Success" << endl;
        cudaFree(d_img);



        // Create iterator and iterate over the whole image
        MatIterator_<Vec3b> it, end;

        for (it = image.begin<Vec3b>(), end = image.end<Vec3b>(); it != end; ++it)
        {
                (*it)[0] = (*it)[0] * 2;
                (*it)[1] = (*it)[1] * 2;
                (*it)[2] = (*it)[2] * 2;
        }

        return image;
}

/*__global__ void PictureKernell(float* d_Pin, float* d_Pout, int n, int m)
   {
   // Calculate the row # of the d_Pin and d_Pout element to process
   int Row = blockIdx.y * blockDim.y + threadIdx.y;

   // Calculate the column # of the d_Pin and d_Pout element to process
   int Col = blockIdx.x * blockDim.x + threadIdx.x;

   //each thread computes one element of d_Pout if in range
   if ((Row < m) && (Col < n))
    d_Pout[Row * n + Col] = 2 d_Pin[Row * n + Col];
   }*/

