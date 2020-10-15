CUDA_PATH=/usr/local/cuda
HOST_COMPILER ?= g++
NVCC=${CUDA_PATH}/bin/nvcc -ccbin ${HOST_COMPILER}
CC=gcc
CXXFLAGS =  -Wall -Wextra#-std=c++11 #-O2 #-std=c++11 #-stdlib=libstdc++ #  $(DEBUG)  -Wall
LIB= -lpng -ltiff -lglut -lGL#-L/usr/informix/lib/c++ OBJS = knnsearch_test.o -lm
OBJS = obj/film_grain_rendering_main.o obj/film_grain_rendering.o obj/matrix.o obj/io_png.o obj/libtiff_io.o
INC = -I${CUDA_PATH}/samples/common/inc -I${CUDA_PATH}/include #-I/home/alasdair/Alasdair/Postdoc/2015_descartes/Codes/External_codes/CImg-1.6.9

film_grain_rendering_main: $(OBJS)
	$(NVCC) $(INC) $(OBJS) -o bin/film_grain_rendering_main $(LIB)
obj/film_grain_rendering_main.o: src/film_grain_rendering_main.cpp
	$(NVCC) $(INC) -c src/film_grain_rendering_main.cpp -o obj/film_grain_rendering_main.o
obj/film_grain_rendering.o: src/film_grain_rendering.cu
	$(NVCC) $(INC) -c src/film_grain_rendering.cu -o obj/film_grain_rendering.o
obj/matrix.o: src/matrix.cpp src/matrix.h
	$(CC) $(INC) -c src/matrix.cpp -o obj/matrix.o
obj/io_png.o: src/io_png.c
	$(CC) $(CXXFLAGS) $(INC) -c src/io_png.c -o obj/io_png.o
obj/libtiff_io.o: src/libtiff_io.cpp src/libtiff_io.h
	$(CC) $(CXXFLAGS) $(INC) -c src/libtiff_io.cpp -o obj/libtiff_io.o
clean: src/film_grain_rendering_main.cpp src/film_grain_rendering.cu src/io_png.c src/libtiff_io.cpp
	rm -f bin/* obj/*.o
