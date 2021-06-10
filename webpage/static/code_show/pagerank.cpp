void InitializeGraph(V, E) {
	SetVertexType(float);
	SetEdgeType(NULL);
	SetIteration(10);
	InitializeVertex(V, 1);
	LoadVertex(V, "vertex.in");
	LoadEdge(E, "edge.in");
}

bool VertexFilter(vertex) {
	return true;
}

void ProcessEdge(value, vertex.src) {
	value = 0.85 * (src.value / src.degree);
}

void AccumulateEdge(tmp, value) {
	tmp = tmp + value);
}

void AccumulateVertex(vertex, tmp) {
	vertex.value = tmp + BASE;
}

void print() {
	StoreResult("result.out");
}

int main {
	PR = new UserAlgorithm(
			InitializeGraph,
			VertexFilter, 
			ProcessEdge, 
			AccumulateEdge,
			AccumulateVertex, 
			StoreResult);
	ExecuteAlgorithm(PR);
	PrintPerformance();
}
