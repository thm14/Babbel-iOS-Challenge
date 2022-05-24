# Babbel-iOS-Challenge

### How much time was invested?
Overall ~ 7 hours in total.
### How was the time distributed?
- **~1 hour** to conceptualise and model the game engine, game view model interfaces and to setup new project with relevant dependencies.
- **~1.5 hours** in total to develop both the Game UI and Results Dialog UI using XIBs and AutoLayout.
- **~2 hours** to implement the game logic as well as the view model business logic of the game view and results popup dialog.
- **~1.5 hours** spent on designing and writing unit tests. 
- Rest of the time was spent on testing the game logic, and refining any bugs or improvements I could find/think of. 

### Decisions made to solve certain aspects of the game

- Used **MVVM+C** architecture as it helps with loosely-coupled navigation, better testability overall while also keeping the view controllers leaner.
- Implemented a **GameViewModel** that deals with the game state logic.
- Implemented a **GameEngine** which is responsible for generating words, evaluating user selections and calculation of scores. 
- Used protocols to define properties and functionality which are then conformed to in concrete impelementations. This helps with dependency inversion. 
- Used **two data structures ( an array and a dictionary)** to hold the word pairs provided in the words file.
- A wordpairs array is used to shuffle the wordpairs around and generate random incorrect wordpairs.
- A wordpairs dictionary, where **English text is used as key, and Spanish translation stored as value** is used to evaluate whether a given user selection is a correct wordpair with **O(1) lookup time.**
- Used **arc4random_uniform()** to generate a random number between 0 and 3, and added logic such that a correct wordpair is generated with a **chance of 25%** even for a small list of words.
- Used observables (using RxSwift) to listen to user events and to update round results in the UI accordingly.
- The final score shown at the end of the game is calculated based on the number of correct attempts over the total number of attempts possible.

### Decisions made because of restricted time

- Opted to use **XIBs for UI development** because of prior familiarity and development time gains because of it. If I had more time, I would have preferred to write the UI programmatically as Nibs and interface builder based views can cause issues. Eg: merge conflicts when multiple devs are working on the same storyboard/XIB, difficulties in maintenance (Xcode version specific issues) etc. 
- FileLoader could have been implemented to load files on a background thread. Since the wordlist in this case is a fairly smaller list it was overlooked.
- Prioriized writing unit tests for GameEngine to ensure correctness of the game logic, followed by the GameViewModel for the same in Game state. 

### What would be the first thing to improve or add if there had been more time
- Design a better UI for the game.
- Write more unit tests to test the views. 
- Introduce additional features like a history of previous scores, support multiple users, a leaderboard etc.
- Add a persistence layer to cache previous scores.
