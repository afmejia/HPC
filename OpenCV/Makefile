FLAGS = `pkg-config --cflags opencv`
LIBS = `pkg-config --libs opencv`

main : DisplayImage.cpp
		nvcc $(CFLAGS) DisplayImage.cpp $(LIBS) -o DisplayImage.out -Wno-deprecated-gpu-targets
