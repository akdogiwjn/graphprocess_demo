typedef struct{
	int type;
	double Vm,Va,P,Q,G,B;
	double deltaP,deltaQ;
}VT;
typedef struct{
	int src;
	double G,B,hB,K;
	int Kcount;
	double BIJ;
}ET;
void <font color="#FF0000">InitializeGraph</font>(V, E, isfirst){
	SetVertexType(VT);//VT为节点类型
	SetEdgeType(ET);//ET为边类型
	SetIteration(1);
	if(isfirst){
		LoadVertex(V);
		LoadEdge(E);
	}
	else{
		LoadVertex(V, "Vm", "Va");//只同步变化的顶点值
	}
} 
bool <font color="#FF0000">VertexFilter</font>(vertex){
	return false;
}
void <font color="#FF0000">ProcessEdge</font>(value, vertex, src, edge){
	double tap_ratio = fabs(edge.K/edge.Kcount);
	double tap_ratio_square = (edge.K/edge.Kcount)*(edge.K/edge.Kcount);
	if(edge.K==0){
		value.tmpP += vertex.Vm*src.Vm * (-1*edge.G*cos(vertex.Va-src.Va) + (edge.B * sin(vertex.Va - src.Va)));	
		value.tmpQ += vertex.Vm*src.Vm * (-1*edge.G*sin(vertex.Va-src.Va) - (edge.B * cos(vertex.Va-src.Va)));
	}
	else{
		double newG = edge.G/tap_ratio;
		double newB = edge.B/tap_ratio;
		value.tmpP += vertex.Vm*src.Vm * (-1*newG*cos(vertex.Va-src.Va) + (newB * sin(vertex.Va-src.Va)));
		value.tmpQ += vertex.Vm*src.Vm * (-1*newG*sin(vertex.Va-src.Va) - (newB * cos(vertex.Va-src.Va)));
	}
}
void <font color="#FF0000">AccumulateEdge</font>(tmp, value){
	tmp.P += value.tmpP;
	tmp.Q += value.tmpQ;
}
void <font color="#FF0000">AccumulateVertex</font>(vertex, tmp){
	if(vertex.type<3){
		vertex.deltaP = vertex.P / vertex.Vm + tmp.P;
	}
	else{
		vertex.deltaP = 0;
	}
	if(vertex.type<2){
		vertex.deltaQ = vertex.Q / vertex.Vm + tmp.Q;
	}
	else{
		vertex.deltaQ = 0;
	}
}
void <font color="#FF0000">print</font>(){
	StoreResult("deltaP", "deltaQ");
}

int main(){
	InitializeVertex(V);//顶点初始化
	InitializeEdge(E);//边初始化
	matrix=MakeYbus(E,V);//构建导纳矩阵，非加速器相关代码
	lu=LU_fac(matrix);//导纳矩阵分解，非加速器相关代码
	while(!CheckConv(E,V)){//收敛性判断
		PF = new <font color="#FF0000">UserAlgorithm</font>(InitializeGraph,
			VertexFilter, ProcessEdge, AccumulateEdge,
			AccumulateVertex, StoreResult);
		<b>ExecuteAlgorithm</b>(PF);//执行加速器代码
		<b>PrintPerformance</b>();
		
		BackForward(E,V);//前代回代过程更新顶点Vm和Va属性，非加速器相关代码
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
					<font color="#FF0000">ProcessEdge(value,vertex,src,edge);</font>
					<font color="#FF0000">AccumulateEdge(tmp,value);</font>
				}
				<font color="#FF0000">AccumulateVertex(vertex,tmp);</font>
			}
		}
	}
	<font color="#FF0000">Print();</font>
}
