#pragma once
#include <vector>
#include <thrust/complex.h>

namespace myFFT {
    struct fftFunctor {

        // using Cooley Turkey FFT
    };

    void dftTest (std::vector<thrust::complex<double>> & input, std::vector<thrust::complex<double>> & output);
    void inverseDftTest (std::vector<thrust::complex<double>> & input, std::vector<thrust::complex<double>> & output);

}