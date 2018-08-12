# FillMyPantry

# How To Run

1. Clone this project.
2. The app uses cocoa pods. Go to root directory of the project and run `pod install`.
2. Open .xcworkspace file and run the app.

# App Features

Fill My Pantry is a simple grocery shopping list App.

1. You can create, delete and update shopping Lists.
2. In shopping List, you can add, delete grocery items and can mark an item as completed and also can mark that back to uncompleted.
3. You can add items from the catalog or by searching for grocery item.
4. There is a search functionality, where you can search for a grocery and the suggestion will come based on that. Currently maintaining 307 grocery items in the grocery catalog.
5. You can rename the shopping List and can export the shopping list to your friends.

# Technical 

1. User will be anonymously authenticated using FirebaseAuth service first time user opens the app.
2. All the shopping list user data is saved in firestore database. So, this data is persisted and available for future.
3. Used Rxswift with firebase services to make call backs cleaner.









