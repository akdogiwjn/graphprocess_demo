void <font color="#FF0000">InitializeGraph</font>(V, E) {
	SetVertexType(float);
	SetEdgeType(NULL);
	SetIteration(50);
	InitializeVertex(V, 1);
	LoadVertex(V, "vertex.in");
	LoadEdge(E, "edge.in");
}

bool <font color="#FF0000">VertexFilter</font>(vertex) {
	return true;
}

void <font color="#FF0000">ProcessEdge</font>(value, vertex.src) {
	value = 0.85 * (src.value / src.degree);
}

void <font color="#FF0000">AccumulateEdge</font>(tmp, value) {
	tmp = tmp + value);
}

void <font color="#FF0000">AccumulateVertex</font>(vertex, tmp) {
	vertex.value = tmp + BASE;
}

void <font color="#FF0000">print</font>() {
	StoreResult("result.out");
}


int main(){
	PR = new <font color="#FF0000">UserAlgorithm</font>(
				InitializeGraph, 
				VertexFilter, 
				ProcessEdge, 
				AccumulateEdge, 
				AccumulateVertex, 
				StoreResult);
	for(int i = 0;i < SEED_NUM; i++){
		Transfer_PList_to_Acc(PList);

		<b>ExecuteAlgorithm</b>(PR);

		Transfer_result_back(result);

		Filter(result);

		<b>PrintPerformance</b>();
	}
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
