# Split the downloaded dataset into train and test folder
# Usage:
#   bash split_dataset.sh 0.9
# First argument: the ratio of the training set

mkdir imagenet_split;
mkdir imagenet_split/train;
mkdir imagenet_split/test;

tf="$1"

cd imagenet/imagenet_images;
SAVEIFS=$IFS;
IFS=$(echo -en "\n\b");
for f in *
do
	echo $f;
	ls $f | wc -l;
	file_cnt=$(ls $f | wc -l);
	train_cnt=$(python3 ../../mul.py $tf $file_cnt);
	test_cnt=$(( file_cnt - train_cnt ));

	# Move training samples
	training_files=$(ls $f | shuf -n $train_cnt);
	for s_f in $training_files
	do
		echo "Moving $f/$s_f";
		mkdir ../../imagenet_split/train/$f;
		mv $f/$s_f ../../imagenet_split/train/$f;
	done

	# Move testing samples
	testing_files=$(ls $f);
	for s_f in $testing_files
	do
		echo "Test moving $f/$s_f";
		mkdir ../../imagenet_split/test/$f;
		mv $f/$s_f ../../imagenet_split/test/$f;
	done
done
IFS=$SAVEIFS

