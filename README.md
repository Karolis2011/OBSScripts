
# OBS scripts

##  autoscene.lua - Automatic Scene Switcher
Script written only to switch scenes on rotation with set timer. It is meant to switch scenes in order.  
### Usage
To add scene to rotation you need to add suffix `@AS@` to scene name with time in seconds that scene should be shown. For example: `Scene1@AS@10` would show this scene for around 10 seconds. 

Scene is removed from rotation by deleting suffix `@AS@`. 

This script is partially intelligent. It won't switch scene if active scene isn't in rotation.