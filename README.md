# Pizzabot

Pizzabot - is a robot for delivering pizza. This app helps to make route for the robot, you can give points which robot should visit and leave pizza there and the algorith will give you commands for the robot. 
Possible commands are:
- N : Move north 
- S: Move south
- E: Move east 
- W: Move west 
- D: Drop pizza
Pizzabot always strarts from the point (0, 0).

## Version 

1.0

## Build and runtime requirements

- XCode 12.4 or later 
- macOS Catalina 10.15.4  or later

## Instructions
To check the functionality of the program open the project in XCode and strat the application. And follow this instructions: 
1. You will see the screen with a textfield where you should enter path for the pizzabot. 
    Example: 5x5 (1, 3) (4, 4) , where "5x5" is grid size and "(1, 3) (4, 4)" - points on the grid which robot should visit
2. Tap return or any place on the screen to start the route building algorithm
3. Answer will be displayed on the screen
4. In case of incorrect input an error will be displayed on the screen

Pizzabot does not consider the most optimal route. It is first aligned to the x-axis (west, east) and then to the y-axis (north, south).

## Unit tests
In folder PizzabotTests you can find several tests for pizzabot function. To check both correct input  and not. You can run tests from this file and see results.
