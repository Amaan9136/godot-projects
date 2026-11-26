# TO DO (NOT STARTED)

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

4. make it modern themed designs and animation to make it look very modern based retro game feel. it should be like brining back nostalgia, give good colors effects and make it overall verygood and colors / bgs/ overall theme. music is already good. add more things if needed only. also landing menu page make it very good animations. (maybe u can make use of drei/three js or anything that supports this then only). also in landing page give blurred animations of auto playing and dodging in the bg as part of animation. remove the computer based instruction, any instruction from menu.

5. when game opens it shows "GODOT ENGINE", question (is its possible to remove that), then remove it (if possible replace it with our own loading animation or whatever or build some loading anim and use make sure to use it). also better initial app icon loading bg, instead of solid gray (godot default) for/in apk.

6. make themes and option for users to change between from settings in the modern card preview format for each (corosal format with next and previous each shows 2 previews in one row and slideable), like cosmic designs and objects (astroid falling as enemy -> spaceship as player), highway / street (opposite cars as enemy -> self car as player), farm theme (eggs falling as enemy -> choose player design yourself. (not decided), also add multiple themes, also keep our current one (red and blue box) as default but with better bg and design)

_____________
QUESTIONS:

A. question no need changes for this (If same user or if any user plays multiple times and surv almost 100 seconds let's say will the score be different?)

B. POSSIBLE TO RMV GODOT ENGINE MARK FOR FREE IN THE LOADING?
___________

NEVER CHANGE THE VERSION NUMBER FROM THE export_presets.cfg, UNTIL ITS NEEDED.

each goes to its own changes-1,.... -4 

where also give commit message for each one, and consider the root itself , where the acutal update will be in the folder of dodge game, so each zip paretn will be dodge game folder