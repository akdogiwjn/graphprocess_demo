from django.urls import path
from . import views

urlpatterns = [
	path('mem',views.mem),
	path('index',views.index),
	path('financial',views.financial),
	path('power',views.power),
	path('hls',views.hls),
	path('compare',views.compare),
	path('graphstream',views.graphstream),
	path('rdma',views.rdma),
	path('distribute',views.distribute),
	path('test',views.test),
]
