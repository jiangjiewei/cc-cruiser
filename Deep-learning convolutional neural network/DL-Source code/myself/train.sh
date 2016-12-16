#!/usr/bin/env sh

TOOLS=./build/tools

GLOG_logtostderr=1 $TOOLS/caffe train --solver=./myself/solver.prototxt

echo "Done."
