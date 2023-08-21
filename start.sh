# echo 'Delete all containers'
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker network prune -f

sudo chown -R hoimingkenny $PWD/mysql/data
sudo chown -R hoimingkenny $PWD/rabbitmq/data
sudo chown -R hoimingkenny $PWD/redis/redis-cluster

chmod 664 $PWD/mysql/conf.d/docker.cnf

rm -rf $PWD/mysql/data
rm -rf $PWD/rabbitmq/data
rm -rf $PWD/redis/redis-clusters

mkdir -p $PWD/mysql/data
mkdir -p $PWD/rabbitmq/data

for port in `seq 7001 7006`; do \
  mkdir -p ./redis/redis-cluster/${port}/conf \
  && PORT=${port} envsubst < ./redis/redis-cluster.tmpl > ./redis/redis-cluster/${port}/conf/redis.conf \
  && mkdir -p ./redis/redis-cluster/${port}/data; \
done

# echo 'Delete all Docker images'
# docker rmi -f $(docker images -q)

# echo 'Building containers'
docker-compose up -d