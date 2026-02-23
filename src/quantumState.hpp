#pragma once
#include <thrust/complex.h>
#include <thrust/device_vector.h>

class QuantumState {
    private:
        int totalSlices; 
        double dx;
        thrust::device_vector <thrust::complex <double>> psi;
        thrust::device_vector <double> potentialEnergy;
        void intitializeState();
        void normalizePsi();    
    public:
        QuantumState (int numberOfSlices, double length);
        void debugPrint();

};

