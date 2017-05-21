#include <opencv2/opencv.hpp>
#include <cuda.h>
#include <iostream>

using namespace cv;
using namespace std;

Mat& filter(Mat& image);
Mat gpuFilter(Mat& image);

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
        //resultCpu = filter(result);
        Mat resultGpu = gpuFilter(result);

        //Show image
        imshow("landscape", image);
	imshow("filtered landscape", resultGpu);
        waitKey(0);
        return 0;
}

/*__global__ void pictureKernel(uchar* d_img_in, uchar* d_img_out, int rows, int cols)
{
        // Calculate the row # of the d_img element to process
        int row = blockIdx.y * blockDim.y + threadIdx.y;

        // Calculate the column # of the d_img element to process
        int col = blockIdx.x * blockDim.x + threadIdx.x;

        // Each thread computes one element of d_img if in range
        if ((row < rows) && (col < cols))
                d_img_out[row * cols + col] = 2 * d_img_in[row * cols + col];
}*/

Mat& filter(Mat& image)
{
        // Accept only char type matrices
        CV_Assert(image.depth() == CV_8U);

        // Create iterator and iterate over the whole image
        MatIterator_<Vec3b> it, end;

        for (it = image.begin<Vec3b>(), end = image.end<Vec3b>(); it != end; ++it)
        {
                (*it)[0] = - (*it)[0] - 2;
                (*it)[1] = - (*it)[1] - 2;
                (*it)[2] = - (*it)[2] - 2;
        }

        return image;
}

Mat gpuFilter(Mat& image)
{
        // Accept only char type matrices
        CV_Assert(image.depth() == CV_8U);

        // Define image size in host memory
	Size size = image.size();
	int channels = image.channels();
	int width = size.width;
	int height = size.height;
	int im_size = width * height * channels * sizeof(uchar);


	// Create host image
	uchar* h_img = (uchar*) malloc(im_size);
	h_img = image.data;
	Mat result;
	result.create(size, CV_8UC3);
	result.data = h_img;

	// Sequencial filter
	for(int i = 0; i < im_size; i++)
	{
		h_img[i] = 2 * h_img[i];
	}
	
	//TODO: Finally the fucking kernel with the two filter
	
        // Flat host image
        //uchar* h_img = (uchar*) image.data;
	//Mat result(rows, cols, CV_8UC3, (void*) h_img);

	// Sequencial filter using sizeof
	/*int size = sizeof(h_img);
	for(int i = 0; i < size; i++)
	{
		h_img[i] = h_img[i] * 2;
	}*/

	//Mat result(rows, cols, CV_8UC3, (void*) h_img);

        /*// Create device images and result host image
        uchar* d_img_in;
        uchar* d_img_out;
        uchar* h_result = (uchar*) malloc(im_size);

        // Allocate device memory for the images
        cudaError_t err = cudaMalloc((void **) &d_img_in, im_size);
        if (err != cudaSuccess)
        {
                cout << cudaGetErrorString(err) << " in " << __FILE__ << " at line " << __LINE__;
                exit(EXIT_FAILURE);
        }

        err = cudaMalloc((void**) &d_img_out, im_size);
        if (err != cudaSuccess)
        {
                cout << cudaGetErrorString(err) << " in " << __FILE__ << " at line " << __LINE__;
                exit(EXIT_FAILURE);
        }

        // Copy image from host to device
        err = cudaMemcpy(d_img_in, h_img, im_size, cudaMemcpyHostToDevice);
        if (err != cudaSuccess)
        {
                cout << cudaGetErrorString(err) << " in " << __FILE__ << " at line " << __LINE__;
                exit(EXIT_FAILURE);
        }

        // Launch the Kernel
        dim3 dimGrid(ceil(cols / 256.0), ceil(rows / 256.0), 1);
        dim3 dimBlock(16, 16, 1);
        pictureKernel<<<dimGrid, dimBlock>>>(d_img_in, d_img_out, rows, cols);

        // Copy result image from device to host
        err = cudaMemcpy(h_result, d_img_out, im_size, cudaMemcpyDeviceToHost);
        if (err != cudaSuccess)
        {
                cout << cudaGetErrorString(err) << " in " << __FILE__ << " at line " << __LINE__;
                exit(EXIT_FAILURE);
        }
        Mat result(rows, cols, CV_8UC3, (void*) h_result);

        cout << "Success" << endl;
        cudaFree(d_img_in);
        cudaFree(d_img_out);*/
        return result;
}


