#include <stdio.h>

int main(int argc, char const *argv[]) {
        int dev_count;
        cudaGetDeviceCount(&dev_count);
        printf("There are %d cuda Devices\n", dev_count);
        cudaDeviceProp dev_prop;
        for (int i = 0; i < dev_count; i++)
        {
                cudaGetDeviceProperties(&dev_prop, i);
                printf("Device %d: \n", i);
                printf("Maximum number of threads per block: %d \n", dev_prop.maxThreadsPerBlock);
                printf("Number of SMs in the device: %d \n", dev_prop.multiProcessorCount);
                printf("Clockrate: %d \n", dev_prop.clockRate);
                printf("Maximum threads in x = %d, y = %d and z = %d \n",
                       dev_prop.maxThreadsDim[0], dev_prop.maxThreadsDim[1],
                       dev_prop.maxThreadsDim[2]);
                printf("Maximum size of grid in x = %d, y = %d, z = %d \n",
                       dev_prop.maxGridSize[0], dev_prop.maxGridSize[1],
                       dev_prop.maxGridSize[2]);
                printf("\n");
        }
        return 0;
}

