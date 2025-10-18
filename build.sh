TAG=5.1
docker system prune -f
docker build --no-cache  -t fusionpbx-docker-dev:$TAG .

