#include "quantumState.hpp"
#include <cmath>
#include <thrust/transform_reduce.h> 
#include <vector>
#include <iomanip>

namespace {
    struct GaussianFunctor {
        double sigmaSquared;
        double mean;
        double dx;

        GaussianFunctor(double s, double m, double spacing): sigmaSquared {s * s}, mean {m}, dx{spacing} {
        }

        __device__ thrust::complex<double> operator()(int i) {
            double x = i * dx;
            double difference = x - mean;
            double exponent = -(difference) * (difference) / (2.0 * sigmaSquared);
            double amplitude = std::exp(exponent);
            return  thrust::complex<double> (amplitude, 0.0);
        }
    };

    struct SquareMagnitudeFunctor {
        __device__ double operator()(const thrust::complex<double> & c) const {
            return (c.real() * c.real () + c.imag() * c.imag());
        }
    };

    struct ScaleFunctor {
        double scaleFactor; 

        ScaleFunctor(double factor) : scaleFactor {factor} {

        }

        __device__ thrust::complex<double> operator ()(const thrust::complex<double> & c) const{
            return c * scaleFactor;
        }
    };
}

QuantumState::QuantumState(int numberOfSlices, double length) :
    totalSlices {numberOfSlices}, dx {length / (numberOfSlices - 1)} {
        psi.resize(numberOfSlices);
        potentialEnergy.resize(numberOfSlices);
        intitializeState();
}

void QuantumState::intitializeState() {
    thrust::fill(potentialEnergy.begin(), potentialEnergy.end(), 0.0);
    potentialEnergy[0] = 1e20;
    potentialEnergy[totalSlices - 1] = 1e20;

    double middle = (totalSlices * dx)/2.0;
    double width = (totalSlices * dx)/4.0;
    std::cerr<< "Middle and width are : " << middle << " and " << width << "\n";

    GaussianFunctor func(width, middle, dx);
    thrust::transform(thrust::make_counting_iterator(0), thrust::make_counting_iterator(totalSlices), psi.begin(), func);

    normalizePsi();
}

void QuantumState::normalizePsi() {
    double totalProbability = thrust::transform_reduce(psi.begin(), psi.end(), SquareMagnitudeFunctor(), 0.0, thrust::plus<double>()) * dx;

    double normalizationFactor = 1.0 / sqrt(totalProbability);
    ScaleFunctor func (normalizationFactor);

    thrust::transform(psi.begin(), psi.end(), psi.begin(), func);
}


void QuantumState::debugPrint() {
    std::vector<thrust::complex<double>> h_psi(totalSlices);
    std::vector<double> h_V(totalSlices);

    thrust::copy(psi.begin(), psi.end(), h_psi.begin());
    thrust::copy(potentialEnergy.begin(), potentialEnergy.end(), h_V.begin());

    std::cout << std::setw(10) << "Index" 
                << std::setw(15) << "Prob Density" 
                << std::setw(15) << "Potential" << std::endl;
    std::cout << "---------------------------------------------------" << std::endl;

    double sum = 0;

    for (int i = 0; i < totalSlices; ++i) {
        thrust::complex<double> curr =  h_psi[i];
        double prob = curr.real() * curr.real() + curr.imag() * curr.imag();
        sum += prob;
        std::cout << std::setw(10) << i 
                    << std::setw(15) << prob 
                    << std::setw(15) << h_V[i] << std::endl;
    }

    std::cout << "Sum is: " << sum;

}