# DiffableDataSourcePractice

An iOS practice project demonstrating **UICollectionViewDiffableDataSource** and **UICollectionViewCompositionalLayout** by building an App Store–style interface.

## Overview

This project replicates the multi-section layout found in Apple's App Store app. It uses two modern UIKit APIs introduced in iOS 13:

- **`UICollectionViewDiffableDataSource`** – type-safe, snapshot-driven data source that automatically animates inserts, deletes, and moves.
- **`UICollectionViewCompositionalLayout`** – composable layout system that supports distinct layouts per section, including orthogonal (horizontal) scrolling.

App data is loaded from a bundled JSON file (`appstore.json`) and decoded into strongly-typed Swift models.

## Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 13.0+ |
| Xcode | 11.0+ |
| Swift | 5.0+ |

## Project Structure

```
CollectionViewsPractice/
├── Models/
│   ├── App.swift                  # App data model
│   ├── Section.swift              # Section data model
│   ├── SelfConfiguringCell.swift  # Protocol for self-configuring cells
│   └── Bundle+Decodable.swift     # Bundle extension for JSON loading
├── View Controllers/
│   └── AppsViewController.swift   # Main collection view controller
├── Views/
│   ├── FeaturedCell.swift         # Large featured app card cell
│   ├── MediumTableCell.swift      # Medium row cell (icon + text + download)
│   ├── SmallTableCell.swift       # Small row cell (icon + name)
│   └── SectionHeader.swift        # Reusable section header view
└── Resources/
    ├── appstore.json              # Bundled app data
    └── Assets.xcassets            # Image assets
```

## Architecture

### Data Flow

```
appstore.json
     │
     ▼
Bundle.decode([Section].self)
     │
     ▼
AppsViewController
     │
     ├── createDataSource()  ──►  UICollectionViewDiffableDataSource<Section, App>
     │
     └── reloadData()        ──►  NSDiffableDataSourceSnapshot  ──►  dataSource.apply()
```

### Layout

`createCopositionLayout()` builds a `UICollectionViewCompositionalLayout` with three distinct section types:

| Section Type | Layout | Scroll Direction |
|---|---|---|
| `featured` (default) | Full-width card, ~350 pt tall | Horizontal, group-paging centered |
| `mediumTable` | 3 rows per group, ~55% width | Horizontal, group-paging centered |
| `smallTable` | Full-width vertical list | Vertical |

## Key Components

### Models

#### `App`
Represents a single app entry decoded from JSON.

```swift
struct App: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let image: String   // name of the image asset
    let iap: Bool       // has in-app purchases
}
```

#### `Section`
Represents a collection view section containing multiple `App` items.

```swift
struct Section: Decodable, Hashable {
    let id: Int
    let type: String    // "featured" | "mediumTable" | "smallTable"
    let title: String
    let subtitle: String
    let items: [App]
}
```

#### `SelfConfiguringCell`
A protocol that enforces a consistent interface for all cell types.

```swift
protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with app: App)
}
```

### Views

#### `FeaturedCell`
A large card cell used in the top "featured" section. Displays a tagline (all-caps, blue), app name, subheading, and a full-bleed app image. Laid out with a vertical `UIStackView`.

#### `MediumTableCell`
A medium-height row used in "mediumTable" sections. Shows a rounded app icon, app name, subheading, and a download button using the `icloud.and.arrow.down` SF Symbol.

#### `SmallTableCell`
A compact row used in "smallTable" sections. Displays a small rounded app icon alongside the app name.

#### `SectionHeader`
A reusable supplementary view shown above `mediumTable` and `smallTable` sections. Contains a thin separator, a bold title label, and a secondary subtitle label.

### Bundle+Decodable

A generic `Bundle` extension that loads and decodes any `Decodable` type from a JSON file in the main bundle.

```swift
extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T
}
```

### AppsViewController

The single view controller that drives the entire screen. Responsibilities:

- Loads section data from `appstore.json` at initialization.
- Builds the compositional layout via `createCopositionLayout()`.
- Creates and configures the diffable data source via `createDataSource()`.
- Applies the initial snapshot via `reloadData()`.
- Uses a generic `configure<T: SelfConfiguringCell>()` helper to dequeue and configure typed cells without force-casting.

## Getting Started

1. Clone the repository.
2. Open `CollectionViewsPractice.xcodeproj` in Xcode.
3. Select a simulator running iOS 13 or later.
4. Press **⌘R** to build and run.

No external dependencies are required.

## Concepts Demonstrated

- **Diffable Data Source** – snapshot-based updates eliminate manual `reloadData()` / `performBatchUpdates()` calls and enable automatic diff animations.
- **Compositional Layout** – each section independently defines its item, group, and section sizes using fractional, absolute, or estimated dimensions.
- **Orthogonal Scrolling** – `.groupPagingCentered` behavior gives featured and medium-table sections a horizontal paging carousel feel within a vertically scrolling collection view.
- **Self-Configuring Cells** – the `SelfConfiguringCell` protocol combined with the generic `configure<T>()` method keeps the data source closure clean and type-safe.
- **Programmatic UI** – all views are built entirely in code using `UIStackView`, Auto Layout anchors, and `UIFontMetrics` for Dynamic Type support.
- **Dynamic Type** – fonts use `UIFont.preferredFont(forTextStyle:)` and `UIFontMetrics` so text scales with the user's accessibility size settings.
- **Dark Mode** – semantic colors (`label`, `secondaryLabel`, `systemBackground`, `quaternaryLabel`) ensure the UI automatically adapts to light and dark appearances.
