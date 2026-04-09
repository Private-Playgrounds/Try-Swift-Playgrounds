# Try Swift Playgrounds

To everyone joining iOS Private Playgrounds, welcome.

This project is where you'll add and share what you build in the workshop.
Create your folder, add your view, and make it available from the list in `Playgrounds/ContentView.swift`.

## Add Your Work

1. Open `Playgrounds.xcodeproj` in Xcode.
2. Create a folder for your work at `Playgrounds/<ParticipantName>/`.
3. Use `Playgrounds/WorkshopSample/WorkshopSampleView.swift` as a reference for your view.
4. Add your Swift files inside `Playgrounds/<ParticipantName>/`.
5. Register your entry in `Playgrounds/ContentView.swift` with a new `NavigationLink`.
6. Run the `Playgrounds` scheme and confirm your entry appears in the list.

## Example

```swift
List {
    // Add one entry per participant here.
    // Keep your view in `Playgrounds/<ParticipantName>/`.
    
    NavigationLink {
        YourSampleView()
    } label: {
        Text("Your Sample")
    }
    
    NavigationLink {
        WorkshopSampleView()
    } label: {
        Text("Workshop Sample")
    }
    
}
```

## Notes

- Use your participant name for the folder, for example `Playgrounds/Alex/`.
- Use a clear label in `Playgrounds/ContentView.swift` so people can find your work quickly.

## Start Exploring

See the [Start Exploring guide](docs/start-exploring.md).

## Workshop Theme Ideas

See the [Workshop Theme Ideas guide](docs/workshop-theme-ideas.md).
