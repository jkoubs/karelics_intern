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
                       tree \
                       ros-galactic-turtlebot3 \
                       ros-galactic-gazebo-ros-pkgs
RUN apt-get -y dist-upgrade
RUN pip3 install transforms3d
# transforms3d = Functions for 3D coordinate transformations
# Conversions between different representations: 3x3 rotation matrices, Euler angles, quaternions


# Create catkin_ws containing the turtlebot3 pkgs
RUN mkdir -p catkin_ws/src/turtlebot3_pkgs

# COPY contents from host to container (turtlebot3 directory) 
# COPY . /catkin_ws/src/turtlebot3

# Git clone turtlebot3_simulations, turtlebot3_msgs and turtlebot3 pkg 
RUN source /opt/ros/galactic/setup.bash && \
    cd catkin_ws/src/turtlebot3_pkgs  && \
    git clone -b galactic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git && \
    git clone -b galactic-devel https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
    git clone -b galactic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git && \
    cd ../.. && \
    colcon build --symlink-install

# Source and Build workspace
RUN source /opt/ros/galactic/setup.bash && \
    cd catkin_ws/ && \
    apt-get update --fix-missing && \
    # This installs dpdencies declared in package.xml from all pkgs in the src folder for ROS 2 Galactic
    rosdep install -i --from-path src --rosdistro galactic -y && \
    colcon build --symlink-install

# Source automatically the underlay (all necessary setup to run ROS2) (add it to .bashrc file)
RUN echo "source /opt/ros/galactic/setup.bash" >> ~/.bashrc
# Source automatically the overlay (workspace -> catkin_ws) (add it to .bashrc file)
RUN echo "source /catkin_ws/install/setup.bash" >> ~/.bashrc




# Create ros2_ws for code
RUN mkdir -p ros2_ws/src/

# Source and Build workspace
RUN source /opt/ros/galactic/setup.bash && \
    cd ros2_ws/ 


# Set Working directory
WORKDIR '/ros2_ws'
# ENTRYPOINT ["/bin/bash"]