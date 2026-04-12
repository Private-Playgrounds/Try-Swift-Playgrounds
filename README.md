> [!WARNING]
> **Public APIs Only**
>
> - App Store apps may **only use public APIs**.
>
> - This workshop is **not about shipping to the App Store**.
>
> - Today's examples are for **debugging and personal experimentation**.
>
> ---
> App Review Guidelines 2.5.1  
> https://developer.apple.com/app-store/review/guidelines/#software-requirements

# Try Swift Playgrounds

To everyone joining iOS Private Playgrounds, welcome.

This project is where you'll add and share what you build in the workshop.
Create your folder, add your view, and make it available from the list in `Playgrounds/ContentView.swift`.

## Add Your Work

Work on your own branch and merge your changes through a pull request.

1. Create a branch for your work.
2. Open `Playgrounds.xcodeproj` in Xcode.
3. Create a folder for your work at `Playgrounds/<ParticipantName>/`.
4. Use the samples in `Playgrounds/WorkshopSample/` as references for your view.
5. Add your Swift files inside `Playgrounds/<ParticipantName>/`.
6. Register your entry in `Playgrounds/ContentView.swift` with a new `NavigationLink`.
7. Run the `Playgrounds` scheme and confirm your entry appears in the list.
8. Commit and push your branch.
9. Open a pull request into `main`, then merge it when your sample is ready. You do not need to wait for workshop staff approval.

### Example

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

### Repository Layout

```text
Playgrounds/
  ContentView.swift         # Register your NavigationLink here with a clear label
  WorkshopSample/           # Reference implementation for participants
  <ParticipantName>/        # Add your work here, for example `Alex`
Docs/                       # Guides for exploration, private API patterns, and workshop ideas
PrivateInterfaces/          # Reference interface files used in the workshop
```

## Start Exploring

When you start looking for private APIs, begin with runtime inspection so you can see what is actually present on the object in front of you. After that, use declarations and headers to broaden the search.

### Explore with po

- `po` allows you to check raw data from runtime objects.
- Start here when you already know the target view or object and want to inspect what is visible at runtime.

#### Commands

| Command | What it shows |
| --- | --- |
| [`_ivarDescription`](Docs/start-exploring/ivar-description.md) | Check the list of instance variables for a specific object. |
| [`_shortMethodDescription`](Docs/start-exploring/short-method-description.md) | Quickly inspect the available methods on a class or object. |
| [`_methodDescription`](Docs/start-exploring/method-description.md) | Inspect method information in more detail. |

### Explore with headers.82flex.com

- [headers.82flex.com](https://headers.82flex.com) is a convenient site for browsing iOS framework headers.
- Use it when you want to search by name quickly or get a rough sense of where a type is declared.

## Private API Calling Patterns

These are the main calling patterns covered in the workshop docs and samples.

Use these patterns after you know the key, selector, symbol, or class name you want to try.

| Pattern | Use it when |
| --- | --- |
| [Key-Value Coding](Docs/private-api-calling-patterns/key-value-coding.md) | You know the property name and want to read or set it through Objective-C Key-Value Coding. |
| [Calling Objective-C Methods by Selector](Docs/private-api-calling-patterns/calling-objective-c-methods-by-selector.md) | You know the selector name and want to call the Objective-C method from Swift. |
| [Resolving Symbols with dlsym](Docs/private-api-calling-patterns/resolving-symbols-with-dlsym.md) | You know the exported symbol name and want to resolve it at runtime with `dlsym()`. |
| [Adding an Objective-C Header](Docs/private-api-calling-patterns/adding-header-files.md) | You want to expose a private Objective-C type to Swift and refer to it directly by name. |

## Workshop Theme Ideas

These are just starting points 🚀 Feel free to explore beyond them and try any fun idea that catches your interest.

See [Workshop Theme Ideas](Docs/workshop-theme-ideas.md) for previews and more details.

| Difficulty | Theme |
| --- | --- |
| ★ | Show a custom view controller above the message area of `UIAlertController`. |
| ★ | Present `UISheetPresentationController` as a full-screen sheet with interactive dismissal, like Apple Music Now Playing. |
| ★★ | Show a `Menu` independently from its source view with `showsMenuFromSource`. |
| ★★ | Apply `VariableBlur` to any view with `UIBlurEffect`. |
| ★★ | Show `UISheetPresentationController` from the left side on iPad. |
| ★★ | Show a custom view inside `UIMenu`. |
| ★★★ | Keep the background glassy for `UISheetPresentationController` even with the large detent. |
| ★★★★★ | Enable glass on the medium detent of `UISheetPresentationController`. The default medium detent looks subdued. |

## Interoperability Requests

- To submit an interoperability request, see [Interoperability requests](https://developer.apple.com/support/interoperability-requests/).
- To browse the current request list, see the [Interoperability request tracker](https://developer.apple.com/file/?file=interoperability-request-tracker).
