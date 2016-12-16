# -*-  encoding:utf-8  -*-
def get_result2(model,ok_file,other_file,cnn,train_caffemodel):
	import numpy as np
	import matplotlib.pyplot as plt
	import os,types

	caffe_root = '/home/jie/caffe/caffe-master/'
	import sys
	sys.path.insert(0,caffe_root+'python')
	import caffe

	MODEL_FILE = caffe_root+'myself/cnn_test/'+cnn+'/deploy.prototxt'
	PRETRAINED = caffe_root+'myself/cnn_test/'+cnn+'/'+model+'/'+train_caffemodel+''
	MEAN_FILE = caffe_root+'myself/cnn_test/'+cnn+'/'+model+'/mnist_train_lmdb_mean.binaryproto'



	# Open mean.binaryproto file

	blob = caffe.proto.caffe_pb2.BlobProto()
	data = open(MEAN_FILE , 'rb').read()
	blob.ParseFromString(data)
	mean_arr = caffe.io.blobproto_to_array(blob)
	mean_test1 = mean_arr[0].mean(1).mean(1)
	mean_zero=[0,0,0]
	mean_tmp=np.array(mean_zero)
	mean_tmp[0]=int(round(mean_test1[0]))
	mean_tmp[1]=int(round(mean_test1[1]))
	mean_tmp[2]=int(round(mean_test1[2]))


	# Initialize NN
	net = caffe.Classifier(MODEL_FILE, PRETRAINED,


						   image_dims=(256,256),
						   mean = mean_tmp,
						   raw_scale=255,
						   channel_swap=(2,1,0)
							)

	net.blobs['data'].reshape(1,3,224,224)

	test_other='/home/jie/桌面/test_data/'+other_file+'/test'
	test_ok='/home/jie/桌面/test_data/'+ok_file+'/test'
	sum_other=0
	error_other_number=0
	list_other=[]
	otherp=['D']
	for root,dirs,files in os.walk(test_other):
		for file in files:
			#print file
			IMAGE_FILE = os.path.join(root,file)
			prediction = net.predict([caffe.io.load_image(IMAGE_FILE)],oversample=False) 
			print 'image: ',file
			print 'predicted class:',prediction[0].argmax()
			sum_other=sum_other+1
			otherp.append(prediction)
			if prediction[0].argmax() == 1:

				#print ("file name is %s"%(file))

				error_other_number = error_other_number+1
				list_other.append(file)
			#print("Predicted class probe argmax is #{}.".format(out['prob'].argmax()))
	#print prediction[0]
	#print 'sum_other is: ',sum_other
	#print 'error_other_number is:',error_other_number



	sum_ok=0
	error_ok_number=0
	list_ok=[]
	okp=['N']
	for root,dirs,files in os.walk(test_ok):
		for file in files:
			#print file
			IMAGE_FILE = os.path.join(root,file)
			prediction = net.predict([caffe.io.load_image(IMAGE_FILE)],oversample=False)
			print 'predicted class:',prediction[0].argmax()
			sum_ok=sum_ok+1
			okp.append(prediction)
			if prediction[0].argmax() == 0:
				error_ok_number = error_ok_number+1
				list_ok.append(file)
			#print("Predicted class probe argmax is #{}.".format(out['prob'].argmax()))

	# print '******************************************'
	# print 'sum_other is: ',sum_other
	# print 'error_other_number is:',error_other_number
	# print 'sum_ok is: ',sum_ok
	# print 'error_ok_number is:',error_ok_number
	# print '*****************************************'
	accuracy = float((sum_ok+sum_other)-(error_ok_number+error_other_number))/float(sum_ok+sum_other)
	#print 'the accuracy is:', accuracy*100

	#FN+TP=P positive other, TN+FP=N negative ok.
	RESULT_FILE='/home/jie/桌面/test_data/result_cnn/'+cnn+'/'+model+'.txt'
	TEST_FILE='/home/jie/桌面/test_data/result_cnn/'+cnn+'/probability/'+model+'.txt'
	FN=float(error_other_number)
	FP=float(error_ok_number)
	TP=float(sum_other-FN)
	TN=float(sum_ok-FP)


	result_list=['TP:'+str(int(TP)),'FP:'+str(int(FP)),'TN:'+str(int(TN)),'FN:'+str(int(FN)),'ACC:'+str(accuracy)]

	FPR=float(FP/(FP+TN))
	result_list.append('FPR:'+str(FPR))

	FNR=float(FN/(TP+FN))
	result_list.append('FNR:'+str(FNR))

	SPE=float(TN/(TN+FP))
	result_list.append('SPE:'+str(SPE))

	SEN=float(TP/(TP+FN))
	result_list.append('SEN:'+str(SEN))


	#F1_score=2*(TP/(TP+FP))*(TP/(TP+FN))/((TP/(TP+FP))+(TP/(TP+FN)))
	#result_list.append('F1_score:'+str(F1_score))
	file_object = open(RESULT_FILE, 'w')
	for i in result_list:
		file_object.writelines(i+'\n')
	file_object.writelines('ERROR_OTHER\n')
	for i in list_other:
		file_object.writelines(i+'\n')
	file_object.writelines('ERROR_OK\n')
	for i in list_ok:
		file_object.writelines(i+'\n')
	file_object.close()

	file_object = open(TEST_FILE, 'w')
	for i in otherp:
		for j in i[0]:
			file_object.writelines(str(j)+'\t')
			# file_object.writelines(str(i[0][1])+'\n')
		file_object.writelines('\n')
	for i in okp:
		for j in i[0]:
			file_object.writelines(str(j)+'\t')
		# file_object.writelines(str(i[0][1])+'\n')
		file_object.writelines('\n')
	file_object.close()
        	#print 'prediction shape:',prediction[0].shape
		#plt.plot(prediction[0])
		#print "predicted class:%s"%(IMAGE_FILE)
		#input_image = caffe.io.load_image(IMAGE_FILE)
		#print input_image
		#prediction class


