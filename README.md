# Pac-Man MC68000

A Pac-Man-style game developed in **MC68000 assembly** using the **EASy68K** assembler and simulator.  
This project was created for the *Computer Structure II* course and focuses on structured assembly code, game state management, sprite rendering, and basic enemy AI.

## Demo

[<video src="media/pac.mp4" controls width="600"></video>](https://github.com/user-attachments/assets/ecb84285-bc10-492f-9e88-c98d55a8f4b3)

## About

The game is entirely written in **MC68000 assembly language** and runs on the simulated environment provided by **EASy68K**, which supplies graphics, audio, and file-system services via system traps.

The codebase is modularized into multiple `.X68` files, separating concerns such as:
- Main execution loop and state handling
- Map representation and rendering
- Player and ghost logic
- Scoring and timing
- Shared utilities and global constants

## Executing the game

If you want to play the game you need the EASy68K assembler and simulator available at www.easy68k.com.

To play the game just open MAIN.X68 from the EASy68K editor and run it.

> To ensure the game runs correctly, both checkboxes in the Options tab of MAIN.S68 must be enabled: Enable Exceptions and Enable VBIT Field Instructions.

## Authors

- [Diego Malagrida González](https://github.com/diegoMalagrida)

- [Andreu Massanet Felix](https://github.com/andreumassanet)
