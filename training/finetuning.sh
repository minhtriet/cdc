mkdir snapshot
GLOG_logtostderr=1 ../../CDC/build/tools/finetune_net.bin solver.prototxt init/conv3d_deepnetA_sport1m_iter_1900000.convdeconv 2>log.train-val
