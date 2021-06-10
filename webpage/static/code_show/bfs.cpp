void <font color="#FF0000">InitializeGraph</font>(V, E) {
	SetVertexType(byte);
	SetEdgeType(NULL);
	SetIteration(10);
	InitializeVertex(V, MAX_VALUE);
	InitializeVertex(V_ROOT, 0);
	LoadVertex(V, "vertex.in");
	LoadEdge(E, "edge.in");
}

bool <font color="#FF0000">VertexFilter</font>(vertex) {
	return true;
}

void <font color="#FF0000">ProcessEdge</font>(value, vertex.src) {
	value = src.value + 1;
}

void <font color="#FF0000">AccumulateEdge</font>(tmp, value) {
	tmp = min(tmp, value);
}

void <font color="#FF0000">AccumulateVertex</font>(vertex, tmp) {
	vertex.value = min(vertex.value, tmp);
}

void <font color="#FF0000">print</font>() {
	StoreResult("result.out");
}

int main {
	BFS = new <font color="#FF0000">UserAlgorithm</font>(
			InitializeGraph,
			VertexFilter, 
			ProcessEdge, 
			AccumulateEdge,
			AccumulateVertex, 
			StoreResult);
	<b>ExecuteAlgorithm</b>(BFS);
	<b>PrintPerformance</b>();
}

void <b>UserAlgorithm</b>(){
	<font color="#0070C0">//图数据初始化</font>
	<font color="#FF0000">InitializeGraph</font>(V,E);

	while(iter++ < MAX_ITERS){
	<font color="#0070C0">//图数据交互</font>
		for vertex in V{
			if(!<font color="#FF0000">VertexFilter</font>(vertex)){
				Ngh = <b>GetInNeighbor</b>(vertex);
				for src in Ngh{
					<font color="#0070C0">//图数据计算</font>
					<font color="#FF0000">ProcessEdge(value,vertex,src);</font>
					<font color="#FF0000">AccumulateEdge(tmp,value);</font>
				}
				<font color="#FF0000">AccumulateVertex(vertex,tmp);</font>
			}
		}
	}
	<font color="#FF0000">Print();</font>
}
