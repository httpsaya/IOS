# Favorites List — UITableView & Custom Cells

A single-screen UIKit application for the assignment **Lab: Favorites List — UITableView & Custom Cells**.

## Features

- 20 favorite movie and TV items (title, subtitle, individual original stylized poster image, rating out of five)
- Custom `FavoriteCell` UITableViewCell with **8 connected outlets** for poster/title/subtitle/five stars
- `UITableViewDataSource`, reusable prototype cell with identifier `FavoriteCell`
- Fully storyboard-based layout; no constraints or subviews added in code
- Five SF Symbol stars update properly on every cell reuse
- Dynamic cell sizing and multiline titles; safe-area-pinned table view

The images are **original generated geometric poster illustrations**, not official movie artwork.

## How to run

1. Open `FavoritesListLab.xcodeproj` in Xcode.
2. Select the `FavoritesListLab` target and an iPhone simulator.
3. Run (`Cmd + R`). If needed, change the bundle identifier / signing team in project settings.

## Submission checklist

- [ ] Test in portrait on **iPhone SE (3rd gen)** and **iPhone 16 Pro Max**.
- [ ] Ensure **zero Auto Layout warnings** in Storyboard/console.
- [ ] Add two screenshots to `docs/screenshots/` and link them below.
- [ ] Record a short video scrolling through all 20 items.
- [ ] Push to a public repository (or share it with the instructor).

### Screenshots (add after running in Xcode)

- iPhone SE (3rd gen): `docs/screenshots/iphone-se.png`
- iPhone 16 Pro Max: `docs/screenshots/iphone-16-pro-max.png`

## Implementation

`FavoriteItem.swift` defines the data model, `FavoriteLibrary.swift` stores all items, `FavoriteCell.swift` only configures content and SF Symbol states, and `ViewController.swift` acts as the table data source. All table and prototype cell constraints live in `Main.storyboard`.
