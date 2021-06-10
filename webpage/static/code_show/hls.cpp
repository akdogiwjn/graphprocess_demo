<font style="font-size:21px"><font color="#0070C0">//遍历点</font>
Foreach(vertex by 1){k=>
	verf := offset(k)
	vert := offset(k + 1)
	edge_on load edge(verf::vert)      <font color="#0070C0">//x658</font>
<font color="#0070C0">//遍历边</font>
	Foreach(vert - verf <font color="#FF0000">by 1 par 16</font>){ii=>       <font color="#0070C0">//x711</font>
		if(level(edge_on(ii)) == 0){
			level(edge_on(ii)) = count_level + 1
		}
	}
}</font>
