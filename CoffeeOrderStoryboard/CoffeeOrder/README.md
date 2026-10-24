# Module 8 — Assignment: Variant B (Coffee order)

Open `CoffeeOrder.xcodeproj` in Xcode. Select the **CoffeeOrder** scheme and run on **iPhone SE (3rd generation)** and **iPhone 16 Pro Max** simulators.

All view construction and Auto Layout constraints are in `CoffeeOrder/Base.lproj/Main.storyboard`. There is **no UIStackView**, and no Swift layout code. Buttons are visual components for the assignment, not a working checkout flow.

## What to show during defense

- Hero view has a **16:9 width-to-height Aspect Ratio** constraint.
- Screen horizontal margins are **16 pt from the safe area**.
- Size buttons have **48 pt** height, **10 pt** gaps, and **equal width** constraints.
- Title is multiline; price is aligned by first baseline, and its resistance to horizontal compression is raised in storyboard if needed.
- Quantity is a left label and right-side minus / count / plus controls.
- Add to order has a **16 pt bottom safe-area** constraint.
- Change the storyboard title to `Iced Caramel Oat Milk Latte` and run both devices to check wrapping.
- Verify the Document Outline has no Auto Layout warnings and the simulator console has no unsatisfiable constraints messages.

Note: Xcode/macOS are unavailable in this environment, so final runtime verification must be performed locally in Xcode.
