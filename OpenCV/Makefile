FLAGS = `pkg-config --cflags opencv`
LIBS = `pkg-config --libs opencv`

main : display_image.cpp
		nvcc $(CFLAGS) reduceColor.cpp $(LIBS) -o reduceColor.out -Wno-deprecated-gpu-targets
