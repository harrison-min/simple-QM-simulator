#include <thrust/device_vector.h>
#include <iostream>
int main () {
    thrust::device_vector<int> dev;
    std::cerr << "Include test success!";

    return 0;
}