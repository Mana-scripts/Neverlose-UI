# Neverlose UI Game Loader

A simple Roblox script loader that automatically loads supported game scripts from the Neverlose-UI library based on the current `PlaceId`.

## 📦 Features

* Auto-detects game using `game.PlaceId`
* Supports multiple games
* Displays welcome message after loading
* Easy to expand with new games

---

### Supported Games

- Pixel Blade
- Anime Fighting Simulator
- Anime Card Collection
- Tap Simulator
- Blox Fruits
- Rebirth Champions Ultimate (No longer being updated)

---

## 🚀 Usage

### Run the Loader

```lua
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Loader.lua"))()
```

---

## 📂 Repository Structure

```
Neverlose-UI/
│
├── Games/
│   ├── Blox Fruits.lua
│   ├── Pixel Blade.lua
│   ├── Anime Fighting Simulator.lua
│   ├── Tap Simulator.lua
│
└── Loader.lua
```

---

## 👤 Author

**Mana**

GitHub:
[https://github.com/Mana-scripts](https://github.com/Mana-scripts)

---

## 🛠 Requirements

* Roblox Executor
* HttpGet enabled
* loadstring support

---

## 📜 License
