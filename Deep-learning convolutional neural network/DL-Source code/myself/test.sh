#!/usr/bin/env sh

TOOLS=./build/tools

GLOG_logtostderr=1 $TOOLS/caffe test -model=./myself/train_val.prototxt -weights=./myself/caffe_alexnet_train_iter_2000.caffemodel 
#--solver=./myself/solver.prototxt

echo "Done."
