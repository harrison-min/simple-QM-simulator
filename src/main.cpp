#include "quantumState.hpp"
#include <iostream>
int main () {
    QuantumState q (100, 100);
    q.debugPrint(); // expect a gaussian
    for (int i = 0; i < 100; ++ i) {
        q.updateState(.1);
    }
    q.debugPrint(); // expect simulation
    return 0;
}