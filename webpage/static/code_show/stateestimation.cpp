typedef struct{
	int type;
	double Vm, Va, P, Q, G, B;
	double Ri_V, Ri_vP, Ri_vQ;
	double M_Vm;
	double sumG,sumB,sumBi,sumBedge;
	double deltaH_r_P,deltaH_r_Q;
}VT;
typedef struct{
	int src;
	double G, B, hB, K;
	int Kcount;
	double BIJ, M_P_TLPF, M_Q_TLPF, Ri_eP, Ri_eQ;
	double M_P_TLPF_reverse,M_Q_TLPF_reverse;
	double Ri_eP_reverse,Ri_eQ_reverse;
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
		
		value.tmpH_r_P = edge.BIJ * (edge.M_P_TLPF - (vertex.Vm * vertex.Vm * edge.G - vertex.Vm * src.Vm * (edge.G*cos(vertex.Va-src.Va) + (-edge.B)*sin(vertex.Va-src.Va)))) * edge.Ri_eP + (-1) * edge.BIJ * (edge.M_P_TLPF_reverse - (src.Vm * src.Vm * edge.G - src.Vm * vertex.Vm * (edge.G*cos(src.Va-vertex.Va) + (-edge.B)*sin(src.Va-vertex.Va)))) * edge.Ri_eP_reverse;
	
		value.tmpH_r_Q = (edge.B - edge.hB) * (edge.M_Q_TLPF - (- vertex.Vm * vertex.Vm * (-edge.B + 0.5*edge.hB) - vertex.Vm * src.Vm * (edge.G*sin(vertex.Va-src.Va) - (-edge.B)*cos(vertex.Va-src.Va)))) * edge.Ri_eQ + (-1) * edge.B * (edge.M_Q_TLPF_reverse - (- src.Vm * src.Vm * (-edge.B + 0.5*edge.hB) - src.Vm * vertex.Vm * (edge.G*sin(src.Va-vertex.Va) - (-edge.B)*cos(src.Va-vertex.Va)))) * edge.Ri_eQ_reverse;;
	}
	else if(edge.K>0){
		double newG = edge.G/tap_ratio;
		double newB = edge.B/tap_ratio;
		value.tmpP += vertex.Vm*src.Vm * (-1*newG*cos(vertex.Va-src.Va) + (newB * sin(vertex.Va-src.Va)));
		
		value.tmpQ += vertex.Vm*src.Vm * (-1*newG*sin(vertex.Va-src.Va) - (newB * cos(vertex.Va-src.Va)));
		
		value.tmpH_r_P = edge.BIJ * (edge.M_P_TLPF - (vertex.Vm * vertex.Vm * (edge.G/tap_ratio_square) - vertex.Vm * src.Vm * ((edge.G/tap_ratio)*cos(vertex.Va-src.Va) + (-edge.B/tap_ratio)*sin(vertex.Va-src.Va)))) * edge.Ri_eP + (-1) * edge.BIJ * (edge.M_P_TLPF_reverse - (src.Vm * src.Vm * edge.G - src.Vm * vertex.Vm * ((edge.G/tap_ratio)*cos(src.Va-vertex.Va) + (-edge.B/tap_ratio)*sin(src.Va-vertex.Va)))) * edge.Ri_eP_reverse;
		
		value.tmpH_r_Q = (edge.B/tap_ratio - edge.hB) * (edge.M_Q_TLPF - (- vertex.Vm * vertex.Vm * (-edge.B + 0.5*edge.hB) / tap_ratio_square - vertex.Vm * src.Vm * ((edge.G/tap_ratio)*sin(vertex.Va-src.Va) - (-edge.B/tap_ratio)*cos(vertex.Va-src.Va)))) * edge.Ri_eQ + (-1) * (edge.B/tap_ratio) * (edge.M_Q_TLPF_reverse - (- src.Vm * src.Vm * (-edge.B + 0.5*edge.hB) - src.Vm * vertex.Vm * ((edge.G/tap_ratio)*sin(src.Va-vertex.Va) - (-edge.B/tap_ratio)*cos(src.Va-vertex.Va)))) * edge.Ri_eQ_reverse;
	}
	else{
		double newG = edge.G/tap_ratio;
		double newB = edge.B/tap_ratio;
		value.tmpP += vertex.Vm*src.Vm * (-1*newG*cos(vertex.Va-src.Va) + (newB * sin(vertex.Va-src.Va)));
		
		value.tmpQ += vertex.Vm*src.Vm * (-1*newG*sin(vertex.Va-src.Va) - (newB * cos(vertex.Va-src.Va)));
		
		value.tmpH_r_P = edge.BIJ * (edge.M_P_TLPF - (vertex.Vm * vertex.Vm * edge.G - vertex.Vm * src.Vm * ((edge.G/tap_ratio)*cos(vertex.Va-src.Va) + (-edge.B/tap_ratio)*sin(vertex.Va-src.Va)))) * edge.Ri_eP + (-1) * edge.BIJ * (edge.M_P_TLPF_reverse - (src.Vm * src.Vm * (edge.G/tap_ratio_square) - src.Vm * vertex.Vm * ((edge.G/tap_ratio)*cos(src.Va-vertex.Va) + (-edge.B/tap_ratio)*sin(src.Va-vertex.Va)))) * edge.Ri_eP_reverse;
	
		value.tmpH_r_Q = (edge.B/tap_ratio - edge.hB) * (edge.M_Q_TLPF - (- vertex.Vm * vertex.Vm * (-edge.B + 0.5*edge.hB) - vertex.Vm * src.Vm * ((edge.G/tap_ratio)*sin(vertex.Va-src.Va) - (-edge.B/tap_ratio)*cos(vertex.Va-src.Va)))) * edge.Ri_eQ + (-1) * (edge.B/tap_ratio) * (edge.M_Q_TLPF_reverse - (- src.Vm * src.Vm * (-edge.B + 0.5*edge.hB) / tap_ratio_square - src.Vm * vertex.Vm * ((edge.G/tap_ratio)*sin(src.Va-vertex.Va) - (-edge.B/tap_ratio)*cos(src.Va-vertex.Va)))) * edge.Ri_eQ_reverse;
	}
}
void <font color="#FF0000">AccumulateEdge</font>(tmp, value){
	tmp.P += value.tmpP;
	tmp.Q += value.tmpQ;
	tmp.H_r_P += value.tmpH_r_P;
	tmp.H_r_Q += value.tmpH_r_Q;
}
void <font color="#FF0000">AccumulateVertex</font>(vertex, tmp){
	if(vertex.type<3){
		vertex.deltaH_r_P = (-1) * vertex.sumBi * (vertex.P - (tmp.P + vertex.Vm*vertex.Vm*vertex.sumG)) * vertex.Ri_vP + tmp.H_r_P;
	}
	else{
		vertex.deltaH_r_P = 0;
	}
	vertex.deltaH_r_Q = (-1) * (2*vertex.sumB + vertex.sumBedge)* vertex.Q - (tmp.Q - vertex.Vm*vertex.Vm*vertex.sumB) * vertex.Ri_vQ + (vertex.M_Vm - vertex.Vm) * vertex.Ri_V + tmp.H_r_Q;
}
void <font color="#FF0000">print</font>(){
	StoreResult("deltaH_r_P", "deltaH_r_Q");
}

int main(){
	InitializeVertex(V);//顶点初始化
	InitializeEdge(E);//边初始化
	matrix=MakeH(E,V);//构建H矩阵，非加速器相关代码
	lu=LU_fac(matrix);//导纳H矩阵分解，非加速器相关代码
	while(!CheckConv(E,V)){//收敛性判断
		SE = new <font color="#FF0000">UserAlgorithm</font>(InitializeGraph,
			VertexFilter, ProcessEdge, AccumulateEdge,
			AccumulateVertex, StoreResult);
		<b>ExecuteAlgorithm</b>(SE);//执行加速器代码
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
