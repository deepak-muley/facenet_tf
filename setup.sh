#https://github.com/davidsandberg/facenet/wiki/Validate-on-lfw
#https://jekel.me/2017/How-to-detect-faces-using-facenet/
virtualenv venv27
. ./venv27/bin/activate
git clone https://github.com/davidsandberg/facenet.git
pip install -r facenet/requirements.txt
export PYTHONPATH=$PYTHONPATH:$(pwd)/facenet/src

#Download datasets
mkdir datasets
pushd datasets
curl -LO http://vis-www.cs.umass.edu/lfw/lfw.tgz
mkdir -p lfw/raw
tar xvf ./lfw.tgz -C lfw/raw --strip-components=1
popd

pushd facenet
#validate
for N in {1..4}; do \
python src/align/align_dataset_mtcnn.py \
../datasets/lfw/raw \
../datasets/lfw/lfw_mtcnnpy_160 \
--image_size 160 \
--margin 32 \
--random_order \
--gpu_memory_fraction 0.25 \
& done
popd

#Download models
mkdir models
pushd models
#TBD curl -LO https://drive.google.com/open?id=1EXPBSXwTaqrSC0OhUdXNmKSh9qJUQ55-
unzip 20180402-114759.zip
popd

pushd facenet
python src/validate_on_lfw.py \
../datasets/lfw/lfw_mtcnnpy_160 \
../models/20180402-114759 \
--distance_metric 1 \
--use_flipped_images \
--subtract_mean \
--use_fixed_image_standardization
popd