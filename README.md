## Architecture
Project consist of three modules:
- `Pokedex` - Main module with the list of pokemons and detailed page which contains a large high-resolution pokemon image, his basic weights and the pokemon unique number!   
- `PokedexAPI` - API wrapper for https://pokeapi.co.
- `PokedexStyle` - Wrapper for UI parts in the application. Always helpful. Cut and share everything you use so often.

![](https://github.com/denevik/Pokedex/blob/master/repo_preview.png)

## Coverage
- [X] Use Swift 5.3.
- [X] Set target to SDK iOS 11.
- [X] The UI must be created without the use of Xib or Storyboard, it must be dynamic and it must support both iPhone and iPad.
- [ ] Use no more than 2 (two) external libraries and motivate their use. I did not use any pods. Instead, I create my own network layer and connected it as a lib to the main project.
- [ ] You can use CocoaPods, Carthage, or SwiftPM; provide motivation for your choice. Already described.
- [X] Use MVVM pattern.
- [X] Verify build completes successfully before considering the project complete!
- [X] Publish code on a github public repository, or in a zip archive.
- [ ] Use at most 1 (one) external library (and motivate its use). Did not use any of the external libraries!
- [ ] Make the app work offline too. Wanted to use core data, but the UI part took a lot of time. I did choose UI. By the way, I prefer core data for this task because it is the best way to store and work with that many items.
- [ ] Write Unit Tests. No unit and UI test due to task time limitation, but I have experience with it. I worked with Quick and Nimble and I am able to provide tests with it. Also, I am familiar with XCTests.
- [X] Customize the project with something you believe can be useful for this app. I did big attention to UX/UI part. It costs me a lot of time. Because of that, I did not write tests and offline mode with core data.

Additional points:
- [X] Pokemon Search. Included 3 error types: not enough letter, no matches, or request issue. Additionally searches within already loaded pokemons. Added loading indicator while loading pokemon from the server.
- [X] Terrific cell UI instead of simple collection view cells with image and name.
- [X] Gorgeous pokemon details controller instead of image and some text with basic stuff.
- [X] Split network layer into separate framework instead of using all network logic in the same one.
- [X] Add additional framework for UI style parts such as fonts, background colors for pokemons, and label for pokemon details page.
- [X] Providing app icons like app icon and the back arrow for the detailed screen.
- [X] Dynamic UI update for colors according to list or detailed controller.
- [X] Move all `magic numbers` to constants.

## NB:
 - I used `print` to log error messages but I'll have you know that this is bad way for logging. Better to use logger instead but in our example we are not using pods.
 - `pokeapi` has issue with pokemons id's, after some 800+ id changed not to 1000 but to 10000+. That's why I have to use long id label like - `#00001`.
 - I did not have any experience with prefetching on my projects. This is why I used all download procesess by network layer, but I know that prefetching way better with collection view and cancellation operations for better performance. I will learn it soon.
 
