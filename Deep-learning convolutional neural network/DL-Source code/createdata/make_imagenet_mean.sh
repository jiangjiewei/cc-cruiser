#!/usr/bin/env sh
# Compute the mean image from the imagenet training leveldb
# N.B. this is available in data/ilsvrc12

rm -rf ./createdata/mnist_test_lmdb_mean.binaryproto
rm -rf ./createdata/mnist_train_lmdb_mean.binaryproto


./build/tools/compute_image_mean createdata/mnist_train_lmdb \
  ./createdata/mnist_train_lmdb_mean.binaryproto

echo "Done."

./build/tools/compute_image_mean createdata/mnist_test_lmdb \
  ./createdata/mnist_test_lmdb_mean.binaryproto

echo "Done."
