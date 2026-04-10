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

## Repository Layout

```text
Playgrounds/
  ContentView.swift         # Register your NavigationLink here with a clear label
  WorkshopSample/           # Reference implementation for participants
  <ParticipantName>/        # Add your work here, for example `Alex`
Docs/                       # Guides for exploration, private API patterns, and workshop ideas
PrivateInterfaces/          # Reference interface files used in the workshop
```

## Start Exploring

See the [Start Exploring guide](Docs/start-exploring.md).

## Private API Calling Patterns

See the [Private API Calling Patterns guide](Docs/private-api-calling-patterns.md).

## Workshop Theme Ideas

See the [Workshop Theme Ideas guide](Docs/workshop-theme-ideas.md).

## Interoperability Requests

- To submit an interoperability request, see [Interoperability requests](https://developer.apple.com/support/interoperability-requests/).
- To browse the current request list, see the [Interoperability request tracker](https://developer.apple.com/file/?file=interoperability-request-tracker).
