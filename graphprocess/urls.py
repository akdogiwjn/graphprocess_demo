"""graphprocess URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from webpage import views

urlpatterns = [
    path('admin/', admin.site.urls),
	path('mem/',views.mem,name="mem"),
	path('index/',views.index,name="index"),
	path('test/',views.index,name="test"),
	path('financial/',views.financial,name="financial"),
	path('power/',views.power,name="power"),
	path('hls/',views.hls,name="hls"),
	path('compare/',views.compare,name="compare"),
	path('graphstream/',views.graphstream,name="graphstream"),
	path('rdma/',views.rdma,name="rdma"),
	path('distribute/',views.distribute,name="distribute"),
	path('dis_run/',views.dis_run),
	path('acc_run/',views.acc_run),
	path('test_run/',views.test_run),
	path('financial_run/',views.financial_run),
	path('financial_getfile/',views.financial_getfile),
	path('power_run/',views.power_run),
	path('hls_run/',views.hls_run),
	path('reset_run/',views.reset_run),
]
