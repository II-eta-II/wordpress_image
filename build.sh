set -ex
#set registry
USERNAME=875707074940.dkr.ecr.ap-northeast-1.amazonaws.com
# image name
IMAGE=cjc102-19-ecr-repo
docker build -t $USERNAME/$IMAGE:latest .
version=`cat VERSION`
echo "version: $version"
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version
