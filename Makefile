clean:
	docker rm -f $$(docker ps -qa)
buildLeGO:
	docker build -t legoloam:latest . -f LeGO_LOAM.Dockerfile
	
buildLIO:
	docker build -t liosam:latest . -f LIO_SAM.Dockerfile

runLeGO:
	docker run -it --rm -e DISPLAY=$DISPLAY \
	--runtime nvidia \
	-e NVIDIA_VISIBLE_DEVICES=all \
	-e NVIDIA_DRIVER_CAPABILITIES=all \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/akshay/Documents/lidar_odometry_evaluation/data/LeGO\ SLAM:/home/akshay/catkin_ws/rosbag legoloam:latest

runLIO:
	docker run -it --rm -e DISPLAY=$DISPLAY \
	--runtime nvidia \
	-e NVIDIA_VISIBLE_DEVICES=all \
	-e NVIDIA_DRIVER_CAPABILITIES=all \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/akshay/Documents/lidar_odometry_evaluation/data/LIO\ SAM:/home/akshay/catkin_ws/rosbag liosam:latest

