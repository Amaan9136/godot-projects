# TO DO (APPLIED CHANGES FOR 1ST TASK)

_________________GROUP 1____________________
1. SOUND CONFIGURATION BASED ON USER (INCL OFFLINE / GUEST - OR DB IF INTERNET EXISTS) TO ADJUST / MUTE. OPTION WITH RELEVANT ICONS. IN THE MENU, TOP RIGHT SETTINGS -> THEN SOUND ADJUSTMENTS

2. in bottom left it shows
| Term | Meaning |
|---|---|
| **FPS** | Frames per second. 60 is the usual target; 30 is acceptable for some mobile games. |
| **Frame time** | Milliseconds per frame. 60 FPS = 16.6 ms budget. |
| **CPU bound** | Slow because of script logic, physics, or too many nodes. |
| **GPU bound** | Slow because of drawing: big textures, overdraw, shaders, particles. |
| **Draw calls** | Number of separate draw commands per frame. Fewer is better. |
| **Memory** | Textures and audio dominate; large images cost RAM even if drawn small. |
i want to by default disable these things for an normal user. but normal user can toggle these option and see these things from the setting itself. handle it local / mongodb based normal user flag. where only show whats useful for normal user to use do not show that are core developer things. only if its would be friendly for normal user to have then show it. i want you to remove all the other things that are not normal user related or non normal user helpful.

3. implement leaderboard, when connected to internet show the leaderboard and show the top 50 users and scroll as you go type (pagination). design it nicely, where its sorted based on more time survived + highest score.

4. pause and play buttons are too big, make it smaller.