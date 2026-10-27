# Coven of Shadows — Herbal Grimoire v0.2

A Godot 4.2+ portrait mobile prototype, written in GDScript. Fully offline. No plugins or third-party art required.

## What's playable
- Cottage and cauldron: select one herb and one crystal, then brew.
- 12 herbs, 8 crystals, inventory quantities and collection.
- 7 named recipes plus unknown combinations.
- Herbal Grimoire: educational facts, fictional magical lore, discovered recipes.
- Crystal Cabinet inventory and lore.
- Woods foraging (+3 random items per tap).
- Restore herb garden for 40 moon coins, then harvest 4 herbs per tap.
- Lunar Ceremony requiring Moonflower + Moonstone and the silver-symbol clue.
- Five-step quest progression and chapter ending.
- Automatic local JSON save after actions, manual Save, Reset Adventure.
- Basic import of coins, clue, ingredient stock and progress from the original v0.1 save.

## Windows setup
1. Download Godot 4.2 or newer (standard edition, not .NET required) at https://godotengine.org/download/windows/
2. Extract this ZIP.
3. In Godot Project Manager click Import and choose project.godot in this folder.
4. Click Edit, then F5 / Run Project. Test the tabs along the bottom.
5. The window uses a 540 x 960 portrait viewport.

## Test the main story
1. Cottage -> Explore Woods to complete the first quest.
2. Satchel -> choose Moonflower and Moonstone -> Cottage -> Brew.
3. Earn 40 coins by brewing; Garden -> Restore Garden.
4. Ensure at least 1 Moonflower and Moonstone remain (forage if necessary).
5. Ritual -> Perform Lunar Ceremony. The chapter completes.

Other known combinations:
- Lavender + Amethyst = Dreamweaver Charm
- Rosemary + Obsidian = Shadow Ward
- Moonflower + Moonstone = Lunar Revelation
- Mugwort + Clear Quartz = Whispering Vision
- Chamomile + Rose Quartz = Kindred Rest
- Sage + Fluorite = Clarity Mist
- Mint + Citrine = Quickstep Draught

## Android export
1. In Godot choose Editor -> Manage Export Templates and install matching templates.
2. Install the Android SDK and a supported JDK following:
   https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
3. Set the Java SDK and Android SDK paths in Editor Settings -> Export -> Android.
4. Project -> Export -> Add -> Android; use package name such as org.example.covenofshadows.
5. Connect an Android device with USB debugging enabled or export a debug APK to install manually.
6. For release distribution, configure your own signing keystore and follow Play Store policies.

## Visual art status
This version implements a dark, ornate anime-inspired **UI palette** (violet, gold, gothic panels).
It does NOT yet include bespoke anime character illustrations or animated background art.
Those require separate asset creation and integration. The Grimoire has text/icon placeholders for art.

## Files
- project.godot: Godot settings
- scenes/main.tscn: main scene
- scripts/main.gd: game logic, UI, saves

## Save notes
Progress is saved to user://coven_v02.json.
On first run it can read the earlier user://coven_save.json file, if it exists in the same Godot user-data directory.
Reset Adventure removes the v0.2 save and reloads. If an older v0.1 save is still present, it can be imported again.

## Important safety note
Herb/crystal effects in the game are fictional. Do not ingest unknown plants or minerals. Some plants called nightshade are toxic.

## Development status
Prototype source code, not an exported APK. It has not been engine-tested in this environment.
