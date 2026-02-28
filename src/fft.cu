#include "fft.hpp"
#include <cmath>

namespace myFFT{
    void dftTest (std::vector<thrust::complex<double>> & input, std::vector<thrust::complex<double>> & output) {
        int totalSize = input.size();
        double inverseTotalSize = 1.0 / totalSize;
        output.assign(totalSize, thrust::complex<double>(0, 0));


        for (int k = 0; k < totalSize; ++k) {
            thrust::complex<double> sum (0, 0);
            
            for (int n = 0; n < totalSize; ++n) {
                double rotationAngle = -2.0 * M_PI * inverseTotalSize * n * k;

                thrust::complex<double> rotation (std::cos(rotationAngle), std::sin(rotationAngle));


                sum += input[n] * rotation;

            }

            output[k] = sum;
        }
    }


    void inverseDftTest (std::vector<thrust::complex<double>> & input, std::vector<thrust::complex<double>> & output) {
        int totalSize = input.size();
        output.assign(totalSize, thrust::complex<double>(0, 0));
        double inverseTotalSize = 1.0/ totalSize;

        for (int k = 0; k < totalSize; ++k) {
            thrust::complex<double> sum (0, 0);
            
            for (int n = 0; n < totalSize; ++n) {
                double rotationAngle = 2.0 * M_PI * inverseTotalSize * n * k;

                thrust::complex<double> rotation (std::cos(rotationAngle), std::sin(rotationAngle));

                sum += input[n] * rotation;

            }

            output[k] = sum * inverseTotalSize;
        }
    }
}