FROM osrf/ros:galactic-desktop
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# dependencies
RUN apt-get update --fix-missing && \
    apt-get install -y git && \
    apt-get install -y build-essential \
                       terminator \
                       nano \
                       vim \
                       python3-pip \
                       libeigen3-dev \
                       ros-galactic-turtlebot3 \
                       ros-galactic-gazebo-ros-pkgs
RUN apt-get -y dist-upgrade
RUN pip3 install transforms3d

# t
# RUN git clone galactic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
# RUN cd f1tenth_gym && \
#     pip3 install -e .

# Create turtlebot3 directory
RUN mkdir -p catkin_ws/src/turtlebot3

# COPY contents from host to container (turtlebot3 directory) 
COPY . /catkin_ws/src/turtlebot3

# Git clone turtlebot3_simulations pkg 
RUN source /opt/ros/galactic/setup.bash && \
    cd catkin_ws/src  && \
    git clone -b galactic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git && \
    cd .. && \
    colcon build --symlink-install

# Source and Build workspace
RUN source /opt/ros/galactic/setup.bash && \
    cd catkin_ws/ && \
    apt-get update --fix-missing && \
    rosdep install -i --from-path src --rosdistro galactic -y && \
    colcon build --symlink-install

# Source automatically the underlay (all necessary setup to run ROS2) (add it to .bashrc file)
RUN echo "source /opt/ros/galactic/setup.bash" >> ~/.bashrc
# Source automatically the overlay (workspace -> catkin_ws) (add it to .bashrc file)
RUN echo "source /catkin_ws/install/setup.bash" >> ~/.bashrc

# Set Working directory
WORKDIR '/catkin_ws'
# ENTRYPOINT ["/bin/bash"]