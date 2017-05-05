FLAGS = `pkg-config --cflags opencv`
LIBS = `pkg-config --libs opencv`

main : twoFilter.cpp
		nvcc $(CFLAGS) twoFilter.cpp $(LIBS) -o twoFilter.out -Wno-deprecated-gpu-targets
