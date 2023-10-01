FROM osrf/ros:noetic-desktop-full

# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update
RUN apt-get install -y python3-rosdep python3-rosinstall python3-wstool build-essential python3-rosdep wget
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl git libpcl-dev libopencv-dev python3-opencv libeigen3-dev libgoogle-glog-dev libgflags-dev\
    libatlas-base-dev libsuitesparse-dev nano tmux
WORKDIR /home/akshay/Downloads

# Install dependencies 
# Change the default shell
RUN git clone https://ceres-solver.googlesource.com/ceres-solver
RUN cd ceres-solver && git checkout tags/1.14.0 -b v1.14.0 && mkdir build && cd build && cmake .. && make -j4 && make install

RUN git clone https://github.com/borglab/gtsam.git && cd gtsam && git checkout 4.1 && mkdir build && cd build && cmake .. && make install


WORKDIR /home/akshay/
RUN apt-get install -y libopencv-dev libboost-all-dev
RUN ln -s /usr/include/opencv4/opencv2 /usr/include/opencv
RUN mkdir -p catkin_ws/src
SHELL ["/bin/bash", "-c"]
RUN . /opt/ros/noetic/setup.bash && cd catkin_ws && catkin_make
RUN cd catkin_ws/src && git clone https://github.com/RobustFieldAutonomyLab/LeGO-LOAM.git
RUN sed -i 's@<opencv/cv.h>@<opencv/opencv.hpp>@g' catkin_ws/src/LeGO-LOAM/LeGO-LOAM/include/utility.h
RUN sed -i 's/-std=c++11/-std=c++14/g' catkin_ws/src/LeGO-LOAM/LeGO-LOAM/CMakeLists.txt
RUN sed -i 's/Eigen::Index/int/g' /usr/include/pcl-1.10/pcl/filters/voxel_grid.h
RUN . /opt/ros/noetic/setup.bash && cd catkin_ws && catkin_make -j1