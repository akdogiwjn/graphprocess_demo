void InitializeGraph(V, E) {
	SetVertexType(float);
	SetEdgeType(NULL);
	SetIteration(10);
	InitializeVertex(V, MAX_VALUE);
	InitializeVertex(V_ROOT, 0);
	LoadVertex(V, "vertex.in");
	LoadEdge(E, "edge.in");
}

bool VertexFilter(vertex) {
	return true;
}

void ProcessEdge(value, vertex.src) {
	value = src.value + 1;
}

void AccumulateEdge(tmp, value) {
	tmp = min(tmp, value);
}

void AccumulateVertex(vertex, tmp) {
	vertex.value = min(vertex.value, tmp);
}

void print() {
	StoreResult("result.out");
}

int main {
	SSSP = new UserAlgorithm(InitializeGraph,
		VertexFilter, ProcessEdge, AccumulateEdge,
		AccumulateVertex, StoreResult);
	ExecuteAlgorithm(BFS);
	PrintPerformance();
}
