#include <opencv2/opencv.hpp>
#include <cuda.h>
#include <iostream>
#include <math.h>
#include <stdio.h>

using namespace cv;
using namespace std;

Mat& filter(Mat& image);
Mat& gpuFilter(Mat& image, uchar* h_img, uchar* h_imgOut, Size size, int im_size);

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

        // Define image size in host memory
        Size size = image.size();
        int channels = image.channels();
        int width = size.width;
        int height = size.height;
        int im_size = width * height * channels * sizeof(uchar);

        //Create host image container
        uchar* h_img = (uchar*) malloc(im_size);
        uchar* h_imgOut = (uchar*) malloc(im_size);

        // Apply filter
        Mat result = image.clone();
        //resultCpu = filter(result);
        Mat resultGpu = gpuFilter(result, h_img, h_imgOut, size, im_size);

        //Show image
        imshow("landscape", image);
        imshow("filtered landscape", resultGpu);
        waitKey(0);
        free(h_img);
        free(h_imgOut);
        return 0;
}

<<<<<<< HEAD
__global__ void pictureKernel(uchar* d_img_in, uchar* d_img_out, int rows, int cols)
{
=======
/*__global__ void pictureKernel(uchar* d_img_in, uchar* d_img_out, int rows, int cols)
   {
>>>>>>> 9c34741928fa05cd2d29c6608c860598aa0796ee
        // Calculate the row # of the d_img element to process
        int row = blockIdx.y * blockDim.y + threadIdx.y;

        // Calculate the column # of the d_img element to process
        int col = blockIdx.x * blockDim.x + threadIdx.x;

        // Each thread computes one element of d_img if in range
        if ((row < rows) && (col < cols))
                d_img_out[row * cols + col] = 2 * d_img_in[row * cols + col];
<<<<<<< HEAD
}
=======
   }*/
>>>>>>> 9c34741928fa05cd2d29c6608c860598aa0796ee

Mat& filter(Mat& image)
{
        // Accept only char type matrices
        CV_Assert(image.depth() == CV_8U);

        // Create iterator and iterate over the whole image
        MatIterator_<Vec3b> it, end;

        for (it = image.begin<Vec3b>(), end = image.end<Vec3b>(); it != end; ++it)
        {
                (*it)[0] = -(*it)[0] - 2;
                (*it)[1] = -(*it)[1] - 2;
                (*it)[2] = -(*it)[2] - 2;
        }

        return image;
}

Mat& gpuFilter(Mat& image, uchar* h_img, uchar* h_imgOut, Size size, int im_size)
{
        // Accept only char type matrices
        CV_Assert(image.depth() == CV_8U);

        // Create host image
        h_img = image.data;
<<<<<<< HEAD

        // Sequencial filter
        /*for(int i = 0; i < im_size; i++)
           {
           h_imgOut[i] = 2 * h_img[i];
           }
           image.release();
           image.create(size, CV_8UC3);
           image.data = h_imgOut;*/

        // Allocate device memory for the image
        // Copy image to the device
        uchar *d_img, *d_imgOut;
        cudaError_t err = cudaMalloc((void**) &d_img, im_size);
        if (err != cudaSuccess)
        {
                printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
                exit(EXIT_FAILURE);
        }
        cudaMemcpy(d_img, h_img, im_size, cudaMemcpyHostToDevice);

        // Create image in the device for the result image
        err = cudaMalloc((void**) &d_imgOut, im_size);
        if (err != cudaSuccess)
        {
                printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
                exit(EXIT_FAILURE);
        }

        //Kernel launch code
        int cols = size.width;
        int rows = size.height;
        dim3 dimGrid(ceil(cols / 16.0), ceil(rows / 16.0), 1);
        dim3 dimBlock(16, 16, 1);
        pictureKernel<<<dimBlock, dimGrid>>>(d_img, d_imgOut, rows, cols);

        // Copy result into the host from the device memory
        cudaMemcpy(h_imgOut, d_imgOut, im_size, cudaMemcpyDeviceToHost);

        // Put the host image in a Mat container
        image.release();
        image.create(size, CV_8UC3);
        image.data = h_imgOut;
        Mat result(rows, cols / 3, CV_8UC3, (void*)h_img);

        // Free memory
        cudaFree(d_img);
        cudaFree(d_imgOut);

=======
        //Mat result;
        //result.create(size, CV_8UC3);
        //result.data = h_imgOut;

        // Sequencial filter
        for(int i = 0; i < im_size; i++)
        {
                h_img[i] = 2 * h_img[i];
        }

        // Allocate device memory for the image
        // Copy image to the device
        /*uchar* d_img, d_imgOut;
           cudaError_t err = cudaMalloc((void**) &d_img, im_size);
           if (err != cudaSuccess)
           {
                printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
                exit(EXIT_FAILURE);
           }
           cudaMemcpy(d_img, h_img, im_size, cudaMemcpyHostToDevice);

           // Create image in the device for the result image
           err = cudaMalloc((void**) &d_imgOut, im_size);
           if (err != cudaSuccess)
           {
                printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__);
                exit(EXIT_FAILURE);
           }*/

        //Kernel launch code
        /*int cols = size.width;
           int rows = size.height;
           dim3 dimGrid(ceil(cols / 16.0), ceil(rows / 16.0), 1);
           dim3 dimBlock(16, 16, 1);
           pictureKernel<<<dimBlock, dimGrid>>>(d_img, d_imgOut, rows, cols);

           // Copy result into the host from the device memory
           cudaMemcpy(h_img, d_imgOut, im_size, cudaMemcpyDeviceToHost);

           // Put the host image in a Mat container
           Mat result(rows, cols / 3, CV_8UC3, (void*)h_img);

           // Free memory
           cudaFree(d_img);
           cudaFree(d_imgOut);*/

>>>>>>> 9c34741928fa05cd2d29c6608c860598aa0796ee
        return image;
}
