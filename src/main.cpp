#include "quantumState.hpp"
#include <iostream>
int main () {
    QuantumState q (100, 100);
    q.debugPrint();
    q.runFFT();
    q.runInverseFFT();
    return 0;
}