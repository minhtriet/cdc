import sys
import os
import pdb
import shutil

# Create folder structure from list of frame

if (sys.argv[1] != 'fb') and (sys.argv[1] != 'bb'):
    print 'gen_prefix fb/bb'
    sys.exit(1)

if os.path.exists('feat'):
  shutil.rmtree('feat')

with open('prefix_%s.lst' % sys.argv[1], 'w') as g:
    with open('/media/data/mtriet/cdc/huawei/predata/%s/test_eval.lst' % sys.argv[1], 'r') as lines:
        for name in lines:
            if os.path.isdir(name):
                os.system('rm %s/*' % name)
            else:
                path, ext = os.path.splitext(name)
                directory = '/'.join(os.path.splitext(path)[0].split('/')[-2:]) # /media/data/mtriet/dataset/fb_cdc/window/Por_Mex_2_gs/000001 --> Por_Mex_2_gs/000001/ 
                os.system('mkdir -p feat/%s' % directory)
                g.write('feat/%s\n' % directory)
            
