# Flappy-Bird
Guided Programming &amp; Non-Guided Advancements of Flappy Bird Game on LOVE2D

The program herein is based on the Harvard CS50 course Lecture 1: Flappy Bird.

The preliminary code was provided by Colton Ogden et al. as part of the course, with advancements and modifications made by myself.

Those advancements and modifications were done by myself (Liam Farmer) and are listed below:

1. Sound Effects were added for the following instances:

-Bird Colliding with the pipes/ground.
-Randomized pool of jump sounds drawn from an array.
-Pause/Resume
-Countdown/Start
-Medal Earned (unique for each medal)
-Pipes Scored
-Background Music 
-Volumes adjusted for better balance.

2. Pause Game State Added

-Created pause game state that suspends play and exchanges positional variables in process of that state change.
-Also pauses the parallax scrolling of the foreground and background. 

3. Pipe Spawn Variations

-Pipes spawn with varying gap heights (90-120 pixels)
-Pipes spawn with varying distances in between them (3 different intervals)
-Fine-tuned the upper and lower limits of the spawn points.
-Fine-tuned the volatility of gap positioning to not create unbeatable scenarios.

Potential Future Improvements:

-Experimented some with the bird graphic rotating on jump, but it created wild collisions that weren't realistic. A rotated sprite that shows while dy > 0 could work, but will have to be cognizant of how the bird's hit-box might change.

-Adjustable Speeds/Difficulty: code is written for provisions to do this, but a new game state would be required with options.





