#arg1 network model
#arg2 trained parameters
#arg3 GPU ID
#arg4 batch size
#arg5 number of mini batches
#arg6 output file prefix

#if [ $1 != 'fb' ] && [ $1 != 'bb' ]; then
#    echo 'xfeat <fb/bb>'
#    exit
#fi

#GLOG_logtosterr=1 ../../CDC/build/tools/extract_image_features.bin xfeat_${1}.prototxt ../training/snapshot/$1_iter_24390 0 4 9046 prefix_${1}.lst prob 2>&1 | tee xfeat.log

GLOG_logtosterr=1 ../../CDC/build/tools/extract_image_features.bin \
                  xfeat.prototxt \
                  ../../model/thumos_CDC/convdeconv-TH14_iter_24390 \
                  0 \
                  4 \
                  9046 \
                  prefix.lst prob 2>&1 | tee xfeat.log

