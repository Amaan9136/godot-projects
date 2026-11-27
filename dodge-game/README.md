# Dodge Game

A portrait 2D arcade game built with Godot 4.7 (GDScript). Move left and right, dodge the falling enemies, and survive as long as you can. Runs on desktop and Android.

## How it works

- Enemies fall from the top. Each one you dodge scores 1 point.
- Touching an enemy ends the run.
- The level goes up every 10 seconds. Enemies spawn faster and fall faster with each level.
- Best score, highest level and best survival time are saved after every run.

## Controls

| Action | Desktop | Mobile |
|---|---|---|
| Move | `A` / `D` or Left / Right arrows | Touch and drag |
| Pause / resume | Pause icon (top-right while playing) | Pause icon |
| Restart after game over | `R` or Restart button | Restart button |

## Accounts

| Mode | Where scores are stored | Needs internet |
|---|---|---|
| Guest (default, tap Play) | On the device | No |
| Logged in | MongoDB, linked to your account | Yes |

Tap the login icon (top-right on the menu) to log in or register with name, username and password. The same icon becomes logout when signed in. Guest scores and account scores are kept separate.

## Run the game

1. Install Godot 4.7.
2. Open Godot, click Import, and select `project.godot` in this folder.
3. Press `F5`.

Guest play works with nothing else set up.

## Run the server (only for login/register)

Requires Node.js 20.19 or newer and a MongoDB instance (local or Atlas).

```
cd server
cp .env.example .env
npm install
npm start
```

`server/.env`:

```
MONGODB_URI=mongodb://127.0.0.1:27017
DB_NAME=dodge
JWT_SECRET=change-me-to-a-long-random-string
PORT=3000
```

Use `npm run dev` for auto-restart while developing.

### Point the game at the server

Set `config/api_url` under `[application]` in `project.godot`:

| Where you run the game | Value |
|---|---|
| Desktop | `http://localhost:3000/api` (default) |
| Android emulator | `http://10.0.2.2:3000/api` |
| Real phone on the same Wi-Fi | `http://<your-pc-lan-ip>:3000/api` |
| Production | `https://your-domain/api` |

### API

| Method | Path | Auth | Purpose |
|---|---|---|---|
| POST | `/api/register` | No | Create account (name, username, password) |
| POST | `/api/login` | No | Log in (username, password) |
| GET | `/api/me` | Bearer token | Current user and bests |
| PUT | `/api/score` | Bearer token | Save score, level, time (keeps the highest) |

## Build for Android

1. In Godot: Project, Export, select the Android preset.
2. Export the APK (the Internet permission is already enabled).
3. SDK, JDK and keystore setup: see `SDK Setup and Build Notes.md` in the repo root.

## Project layout

```
auth/        login and register screen
menu/        main menu
hud/         score, level, time, pause button, game over panel
player/      player scene and movement
enemy/       falling enemy
spawner/     enemy spawning and difficulty scaling
assets/      audio, fonts, icons (Lucide SVGs)
scripts/
  systems/   autoloads: GameManager, Api, AudioManager, DebugOverlay
  utils/     LocalStore (local save file)
server/      Node + Express + MongoDB backend (ignored by Godot)
```

## Tech

Godot 4.7, GDScript, Node.js, Express 5, MongoDB driver 7.
