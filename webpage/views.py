from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from paramiko.client import SSHClient, AutoAddPolicy

import paramiko
import time

# Create your views here.



def test(request):
	return render(request, "test.html")


def test_run(request):
	dataset = request.GET.get('dataset')
	algorithm = request.GET.get('algorithm')
	acc_count = request.GET.get('acc_count')
	print(dataset)
	print(algorithm)
	print(acc_count)
	
	myclient = SSHClient()
	
	myclient.set_missing_host_key_policy(AutoAddPolicy())

	myclient.connect("ip",port=port,username=user",password="passwd")
	
	if algorithm=='bfs' :
		mycommand='make '+dataset+'_run'
	else :
		mycommand='make '+dataset+'_pr_run'
	if (acc_count=='1') :
		mycommand=mycommand
	else :
		mycommand=mycommand+'_2'
	
	print(mycommand)
	stdin,stdout,stderr=myclient.exec_command(''+mycommand+';')
	
	acc_run_ans=[]
	for i in stdout.readlines():
		acc_run_ans.append(list(i.strip('\n').split(',')))
	return JsonResponse(acc_run_ans, safe=False)

