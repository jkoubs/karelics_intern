# Laser scan visualization

```bash
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
ros2 launch turtlebot3_bringup rviz2.launch.py
```
# Waypoint Navigation

## Map-building

```bash
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=True
ros2 run teleop_twist_keyboard teleop_twist_keyboard
# Move the bot around so that entire world is explored
ros2 run nav2_map_server map_saver_cli -f ~/map
```
## Waypoint Follower

```bash
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
ros2 launch turtlebot3_navigation2 navigation2.launch.py use_sim_time:=True map:=$HOME/map.yaml
# Set initial pose estimate near bot's current location
ros2 run teleop_twist_keyboard teleop_twist_keyboard
# Move bot around a little to improve the AMCL cloud confidence
# Inside Rviz2-
# Switch to "Waypoint mode", add three "Navigation2 Goal"'s and "Start Navigation"
```