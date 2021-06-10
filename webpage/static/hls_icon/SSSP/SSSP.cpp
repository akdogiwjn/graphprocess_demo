#include "AccGraph.h"

class SSSP : AccGraph {
    public:
        int Process(int v, int e, int u) {
            return e + u;
        }

        int Reduce(int tmp, int newVal) { 
            return tmp < newVal? tmp : newVal;
        }

        int UpdateVertex(int v, int newVal) {
            return v < newVal? v : newVal;
        }
};