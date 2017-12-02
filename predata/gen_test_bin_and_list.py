import numpy as np
import cv2
import os
from time import localtime, strftime
import scipy.io
import sys
import pdb
import json

class_ids = json.load(open('/media/data/mtriet/dataset/script/%s_classes.json' % sys.argv[1]))
BG_NUM = 25
MAX_LENGTH = 256

if sys.argv[2] == 'train':
  inputdir = '/media/data/mtriet/dataset/%s_frames/' % sys.argv[1] # a list of folders; each folder contains all frames for one video
  outputdir = '/media/data/mtriet/cdc/huawei/predata/%s/' % sys.argv[1]
  listfile = open(outputdir+"test.lst",'w')
elif sys.argv[2] == 'eval':
  inputdir = '/media/data/mtriet/dataset/%s_frames_%s/' % (sys.argv[1], sys.argv[2]) 
  outputdir = '/media/data/mtriet/cdc/huawei/predata/%s_eval/' % sys.argv[1]
  listfile = open(outputdir+"test_eval.lst",'w')

window = 32  # window length per each bin file
sr = 25 # sampling rate per frame
bg_count = 1
for v in os.listdir(inputdir):
  compute = True
  class_name = v.split('_')[-1]
  imglist = os.listdir(os.path.join(inputdir,v))

  if class_name == 'fkwg' or class_name == 'fkwog':
      class_name = 'fk'

  if class_name == 'bg':
    if bg_count < BG_NUM and len(imglist) < MAX_LENGTH:
      bg_count += 1 
    else:
      continue
       
  if len(imglist) < window:
      continue
      print "Too short video %s " % v

  print v
  print strftime("%a, %d %b %Y %X +0000", localtime())
  try:
    os.mkdir(os.path.join(outputdir,'window',v))
  except:
    print "%s existed" % (os.path.join(outputdir,'window',v))
    compute = False

  imglist = os.listdir(os.path.join(inputdir,v))
  # prepare label
  if sys.argv[2] == 'eval':
    vlabel = np.zeros(len(imglist)) # during training, assign frame-level label here instead of all zeros
  elif sys.argv[2] == 'train':
    vlabel = [class_ids[class_name]] * len(imglist)
  else
    print 'eval or train?'
    sys.exit(1)
 
  # iter over window
  for s in range(0,len(imglist)-window+1,window):
    binfilename = int(s+1)  # the index from 1 of the first frame
    if compute:
      video = [ cv2.imread(os.path.join(inputdir,v,img)) for img in imglist[s:s+window] ]  # read image
      video = [ cv2.resize(video[i],(171,128)) for i in range(0,len(video)) ] # resize
      seg = np.stack(video)  # stack a set of frames
      seg = np.moveaxis(seg,-1,0)  # adjust axis location
      slabel = [ vlabel[s+idx] for idx in range(0,window) ]
      pdb.set_trace()
      label = np.expand_dims( np.stack( [ int(slabel[idx]) * np.ones(seg.shape[2:], dtype=np.uint8) for idx in range(0,window) ] ), axis=0) # add class label for softmax loss as additional channel
      binfile = np.concatenate((seg, label), axis=0)  # concat seg and label
      with open(os.path.join(outputdir,'window',v,str(binfilename).zfill(6)+".bin"),'wb') as f:
        np.asarray([1]+list(binfile.shape),dtype=np.int32).tofile(f)  # meta write in 32 bits
        binfile.tofile(f)  # write data
    listfile.write(os.path.join(outputdir,'window',v,str(binfilename).zfill(6)+".bin"))
    listfile.write('\n')
  # last window
  if (len(imglist)%window) != 0 :
    binfilename = int(len(imglist)-window+1)  # the index from 1 of the first frame
    if compute:
      video = [ cv2.imread(os.path.join(inputdir,v,img)) for img in imglist[-window:] ]  # read image
      video = [ cv2.resize(video[i],(171,128)) for i in range(0,len(video)) ] # resize
      seg = np.stack(video)  # stack a set of frames
      seg = np.moveaxis(seg,-1,0)  # adjust axis location
      slabel = [ vlabel[len(imglist)-window+idx] for idx in range(0,window) ]
      label = np.expand_dims( np.stack( [ int(slabel[idx]) * np.ones(seg.shape[2:], dtype=np.uint8) for idx in range(0,window) ] ), axis=0) # add class label for softmax loss as additional channel
      binfile = np.concatenate((seg, label), axis=0)  # concat seg and label
      with open(os.path.join(outputdir,'window',v,str(binfilename).zfill(6)+".bin"),'wb') as f:
        np.asarray([1]+list(binfile.shape),dtype=np.int32).tofile(f)  # meta write in 32 bits
        binfile.tofile(f)  # write data
    listfile.write(os.path.join(outputdir,'window',v,str(binfilename).zfill(6)+".bin"))
    listfile.write('\n')
        
    
