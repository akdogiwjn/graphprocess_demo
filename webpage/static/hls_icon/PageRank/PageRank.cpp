#include "AccGraph.h"

class PageRank : AccGraph {
    public:
        int Process(int v, int e, int u) {
            return u / v;
        }

        int Reduce(int tmp, int newVal) { 
            return tmp + newVal;
        }

        int UpdateVertex(int v, int newVal) {
            return 0.2 + 0.8 * newVal;
        }
};