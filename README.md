# Lightning Animation
This is a simple set of views written in SwiftUI. It has a lightning animation and a rain animation.

## Installation
You can install the package using Swift Package Manager
```markdown
dependencies: [
    .package(url: "https://github.com/doorhinge-apps/LightningAnimation.git", branch: "main")
]
```

## Usage
Import the package in files you want to use it in.
```swift
import LightningAnimation
```

### Lightning Bolts
The lightningInterval parameter accepts a Double value. It changes how many seconds between each lightning bolt.
```swift
LightningBolt(lightningInterval: 3.0)
```

### Rain
You can display a rain animation using the rain view in the package.
```swift
Rain()
```
