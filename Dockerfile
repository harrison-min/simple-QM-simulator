FROM nvidia/cuda:12.6.0-devel-ubuntu24.04

RUN apt-get update && rm -rf /var/lib/apt/lists/*

COPY src/ /src/

RUN nvcc src/main.cpp -std=c++20 --extended-lambda -arch=sm_89 -o main
RUN mkdir output

ENTRYPOINT ./main 
#docker run --mount type=bind,source="$(pwd)/output",target=/output --gpus all -e LD_LIBRARY_PATH=/usr/lib/wsl/lib qm-sim