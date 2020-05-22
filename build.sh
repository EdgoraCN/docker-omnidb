docker build -t edgora/omnidb .
docker push edgora/omnidb

docker tag edgora/omnidb registry.cn-beijing.aliyuncs.com/edgora-oss/omnidb
docker push  registry.cn-beijing.aliyuncs.com/edgora-oss/omnidb