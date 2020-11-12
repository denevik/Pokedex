## Architecture
Project consist of three modules:
- `Pokexed` - Main module with the list of pokemons and detailed page which contains a large high-resolution pokemon image, his basic weights and the pokemon unique number!   
- `PokexedAPI` - API wrapper for https://pokeapi.co.
- `PokedexStyle` - Wrapper for UI parts in the application. Always helpful. Cut and share everything you use so often.

It's very important to use decomposition for modules! In the nearest future I am planing to split it more and replace more "magic numbers". To make the app more flexibe and easy to support.

We still can use some pods. But, at this moment, I want you to show that we can achieve everything even without help!

## Data
All data downloaded from https://pokeapi.co stay in-app while it is running. I used URLSession due to time limits. But I will implement Operation + Queue in future for much more stable and smooth loading.
Everything maps to the app models. I used `print` instead of some logger pod. Just for simple error handling and notifications. But I want you to know that I know that often `print` usage is BAD! We need our memory. Let her serve.

## Test coverage
It will be covered with the tests in the future, I promise.

## UI
Gorgeous UI with in inspiration of the good old days. Colorful and detailed with everything you need. He will make you smile and rewatch Pokemons siries again!

## Caching?
No! But I want to. Core Data, in my opinion, best option for this, because of large amount of data. But it will be implemented in future releases. 
