#include "AccGraph.h"

class BFS : AccGraph {
    public:
        int Process(int v, int e, int u) {
            return v < u + 1? v : u + 1;
        }

        int Reduce(int tmp, int newVal) { 
            return tmp < newVal? tmp : newVal;
        }

        int UpdateVertex(int v, int newVal) {
            return newVal;
        }
};