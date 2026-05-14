# set up lsst env and pfs2d pipeline on idark (N. Yasuda, K. Hayashi, J. Shi)
+ install pfs datamodel (this can be done after creating pfs environment; I set this up before I create the pfs env)
cd Subaru-PFS
git clone https://github.com/Subaru-PFS/datamodel.git
cd datamodel
git fetch --tags
git tag | tail
git checkout (xxxx) newest_tag
python -m pip install -e . --no-deps
git status 

1. Anaconda should be installed
2. conda deactivate
3. conda deactivate 
4. conda create -n pfs python=3.12
5. python --version #make sure it's python3.12
6. conda activate pfs
6. source /lustre/work/yasuda/PFS/stack_28/loadLSST.bash
7. setup pfs_pipe2d


# if you want to work on jupyter notebook
+ log on to a computing node interactively
'qsub -q small -I -l nodes=1:ppn=1,walltime=24:00:00'
+ conda deactivate
+ conda deactivate
+ conda activate pfs
+ source /lustre/work/yasuda/PFS/stack_28/loadLSST.bash
+ setup pfs_pipe2d

+ 'jupyter-lab --no-browser --ip=0.0.0.0 --port=1111'
+ on your local terminal end
ssh -NfL 7777:ansys06:1111 username@idark.ipmu.jp #check ansysxx:xxxx
+ in your local web browser
http://localhost:7777/


# verfify your installation in jupyter notebook
from lsst.daf.butler import Butler
import pfs.datamodel as datamodel
butler_Run21 = Butler('/lustre/work/jingjing.shi/PFS_SSP/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/', collections=['run21_June2025'])
butler_Run22 = Butler('/lustre/work/jingjing.shi/PFS_SSP/hscpfs.mtk.nao.ac.jp/fileaccess/pfs/programs/S25A-OT02/2d/', collections=['run22_July2025'])
dataRef = list(butler_Run22.registry.queryDatasets('pfsCoadd'))
