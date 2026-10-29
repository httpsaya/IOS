# Music Player Lab — corrected files

Open `MusicPlayerLab.xcodeproj` in Xcode and run on an iPhone simulator.

## Fixes

- All 10 uploaded MP3 files are bundled under stable filenames (`track01.mp3`–`track10.mp3`).
- TrackLibrary uses the corresponding resource names without extensions.
- ViewController loads files using `withExtension: "mp3"` and no longer requests `*.mp3.m4a`.
- All uploaded cover images are in `Assets.xcassets` as `cover01`–`cover10`.
- The uploaded Main.storyboard is preserved and retains all 7 outlets and 4 actions.
- Slider shows position and supports seeking; elapsed/duration labels update.
- Next/Previous wrap around; autoplay transitions are preserved.

## Verify before submitting

Build and run in Xcode, inspect Target → Build Phases → Copy Bundle Resources for 10 MP3 files and compiled asset catalog; test SE 3rd gen and 16 Pro Max. Xcode is unavailable in this environment, so a simulator build was not run.

**Course requirement notice:** The assignment specifies royalty-free audio. Your uploaded commercial recordings should only be used if you have appropriate rights; replace them with royalty-free music for a compliant submission.
