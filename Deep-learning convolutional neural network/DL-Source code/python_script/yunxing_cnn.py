
__author__ = 'jiangjiewei'

from get_result1 import *
from get_result2 import *
from test_image import *

model=['daxiao-5','daxiao-6','daxiao-7','daxiao-8','ok-5','ok-6','ok-7','ok-8','shenqian-5','shenqian-6','shenqian-7','shenqian-8','zhongyang-5','zhongyang-6','zhongyang-7','zhongyang-8']
ok_file=['small/5','small/6','small/7','small/8','ok/5','ok/6','ok/7','ok/8','qian/5','qian/6','qian/7','qian/8','zhouwei/5','zhouwei/6','zhouwei/7','zhouwei/8']
other_file=['big/5','big/6','big/7','big/8','other/5','other/6','other/7','other/8','shen/5','shen/6','shen/7','shen/8','zhongyang/5','zhongyang/6','zhongyang/7','zhongyang/8']
cnn='cnn'
train_caffemodel='caffe_alexnet_train_iter_2000.caffemodel'

#cnn='cataract_cnn'
#train_caffemodel='caffe_alexnet_train_96_iter_2000.caffemodel'
l=len(model)
#i=3
# while i<8:
for i in range(0,16):
    print i
    #test_image(model[i],ok_file[i],other_file[i],cnn,train_caffemodel)
    get_result2(model[i],ok_file[i],other_file[i],cnn,train_caffemodel)
    #i=i+1
