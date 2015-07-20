# Define the Problem
My task for this assignment is to build a tile-based RPG collaboratively. By myself. The problem, as it stands, is that I am required by school to build a tile-based RPG as a part of an assignment, and that I have not yet build a tile-based RPG. Over the next month or so, I intend to rectify this, thus solving the problem.

If this weren’t part of an assignment, then the problem would be that current RPGs are insufficient. Many of them, like Pokèmon, force the player onto a set of quests, and leave little room for free-form combat. Others, like Pokèmon, add far too much useless stuff into the game, and it becomes a challenge of inventory management and far too much thinking. My game, Ärgermeister, will attempt to solve this by creating a free-form environment where the player can focus on moving around and fighting enemies, with no set eventual goal.

As it is named Ärgermeister, the challenge for the player will be in managing their frustration and anger at such a difficult, pointless game. Many modern players of video games are angry and insecure, so my hope with Ärgermeister is that they will learn to control their anger and persist in the face of futility and frustration. The moment the player wins the game is the moment that they come to terms with the futility of battling endless, difficult monsters so that they can ‘level up’ (but with no end level available). As the game cannot tell whether the player is quitting the game because they have achieved this, or whether they are quitting the game because they are angry, it will not be able to have a scoring system beyond the sheer satisfaction of knowing that one really did _beat the game_.

## Requirements
All of the requirements of this project have been set out for me in the task notification. They are as follows:

- The game reads in a file containing map data without any errors
- The player character triggers events depending on what tile they are on
- Characters can be generated with random statistics, and saved/reloaded
- Enemies move around the map and are able to be fought and killed
- The character can level up, but also die
- A variety of weapons/items/abilities are available to the player
- A variety of enemies and traps are available to be fought
- A combat system allows the player to fight the enemies
- The program is modular
- The code of the program is frequently pushed to source control systems
- The code has no bugs in it, and all variables/subroutines are named appropriately to their function

## Objectives
The primary objective of this task is to build a minimum viable product as quickly as possible. Any extra features or functionality should be added on after that has been achieved. Because of that, the art direction of the game is going to be minimalistic, probably with single-colour tiles representing different things. Proper art and effects will not be marked so need not be included.

## Constraints
Like the last task, I don’t have an infinite amount of time, or and infinite budget, or an infinite skill set. This means that I’ll have to impose a few constraints on the final solution:

- OS X Exclusive
	- Because I’m writing in Swift and SpriteKit, the game is going to have to be exclusive to OS X. I don’t have the time or the willingness to port my game to other platforms.
	- The game will also have version requirements of OS X to consider. The Swift language is only supported by OS X versions from Mavericks and above, which means my game is only going to work on OS X 10.9, OS X 10.10, and OS X 10.11 for the moment.
- Minimal art direction
	- As outlined in the constraints, I don’t need to spend any time on the art of my game. The resultant game, if it has any art beyond different-coloured tiles, will only have it for aesthetic purposes, and I will need to recognise this in development. Different art pieces for different objects in the game will only come when the minimum viable product is completed
- Minimal storyline
	- Much like the last task I did for this subject, the storyline should be as minimal as possible to avoid wasting time on it. Enemies and items should come with as little description as possible, to avoid there being any time wasted on such a small part of the game. Dialogue, if there is any, should be made up of single lines and be as minimal as possible.

## Feasibility
The RPG, as outlined at the start of this document, should be pretty much completely feasible. The task has been completed before by numerous other cohorts, and has been set for us, which means that it should be possible to complete. As the task is designed to be completed in Visual Studio, it should also be feasible to complete using Swift and XCode, as the two have more, better functionality for building videogames. I should not run into any issues here.

As outlined at the start of the document again, the only part of this game that will be unfeasible is determining whether the player has actually achieved the goal of introspection and acceptance. Instead of measuring it objectively, the nature of the goal should allow for it to be measured socially. A player who has achieved the goal of the game and understood its purpose should understand and know to themselves, ‘I have achieved the goal of the game. I have completed it’, where an angry player would not understand that, and instead know to themselves, ‘I became frustrated by this game. I stopped playing it because I was frustrated by this game. What is the point of this game?’. This feasibility problem is solved.

## Social and Ethical Issues
In programming a tile-based RPG, a number of social and ethical issues are present:

- Unintuitive controls
	- Most videogames use the same or similar control schemes. When they don’t, the quality ones will ensure that the user properly understands how to play the game, but they usually don’t mess with well-understood and accepted methods of controlling the game, like using ‘WASD’ for moving around. To be ergonomically sound, this game should use well-accepted schemes like ‘WASD’ to ensure that any new player understands exactly how to play the game. Any controls that are unable to be intuited should be presented to the user clearly.
- Enforced stereotypes or prescribed character attributes
	- As this game could be played by a large number of people, and involves a character creation facility, the characters should not conform to any specific racial, ethical, sexual or cultural ideas. Any of these attributes should either be non-specific, or able to be determined by the user.
- Language
	- The game will be programmed entirely in English (potentially with emoji), and any text on screen is given either in English or German. This means that the game will be inaccessible to anyone who does not have a reasonable understanding of English. To avoid having a wordless game, the development will recognise that due to language constraints it will only be written in English, and as a result may have complicated language which is only able to be understood by an English-speaking player.