# GDD

**Title:** Koishi Eyes Shut Paradigm (KESP)
**Platform:** Gameboy color (emulation)
**Genre:** Platformer
**Target:** General public (3+)

## Concept
The concept is to create a small-sized platformer which will blend both action and puzzle elements through the readapted mechanic of Ikaruga.

### Synopsis
Koishi's third eye has been stolen, she cannot avoid conscious beings with her eyes open. To find back her third eye, she must go deep down to hell and retrieve it.

### Unique Selling Points
- Touhou
- platformer with an Ikaruga mechanic of gameplay
- Could have some puzzle mechanics

### Game objectives
- Go down each level and survive.
- Beat the boss of each level (as of now, Orin, Satori, Marisa(?))

### Graphics
- Given the hardware, the pixel art will be minimalistic, and is reduced to 8 palettes (of 4 colours, transparent included in 8x8 squares) that can be displayed at a time.
- Traditional side view, typical of any platformer
- HUD: Health, Eye open/closed

### Data storage:
Data storage is handled by the GBC emulator.

## GAMEPLAY
### Basic mechanics
- Health: 3 hearts, if you get hit 3 times you die
- Hearts: Recovers your health by a point
- Eyes: Mario coins (?)

### Unique mechanic: Dimension-shift
- In the open-eyed dimension, both spiritual enemies and spiritual platforms are tangible.
-  In the closed-eyed dimension,
1. spiritual entities are not visible (?) nor tangible, but you can only stay in this dimension for a second, as Koishi is scared. It serves as a pseudo invulnerable state to spiritual entities. 
2. spiritual entities are frozen in time, but your view of the field does not update since Koishi has her eyes closed.
3. Koishi blinks for up to half a second (which you can hold manually), in which you can see nothing at all (or world vision does not update), and spiritual entities are not tangible
// open and closed dimensions can be reversed if need be
- In any of these dimensions, physical platforms are tangible and can hurt you.

### Controls
up: look up
right: right
left: left
down: go through platform
A: Jump
B: Action (depends on the nearby object)
Start: pause
Select: Close eyes
