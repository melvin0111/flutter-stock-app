# MP Report

## Team

- Name(s): Melvin Cabrera
- AID(s): A20471594

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [ ] The app builds without error
- [ ] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [ ] Android emulator
- [ ] There are at least 3 separate screens/pages in the app
- [ ] There is at least one stateful widget in the app, backed by a custom model class using a form of state management
- [ ] Some user-updateable data is persisted across application launches
- [ ] Some application data is accessed from an external source and displayed in the app
- [ ] There are at least 5 distinct unit tests, 5 widget tests, and 1 integration test group included in the project

## Questionnaire

Answer the following questions, briefly, so that we can better evaluate your work on this machine problem.

1. What does your app do?
   My app is a stock exploration and journaling application. It allows users to search stocks/crypto, add them to their favorites(dashboard),
   and write notes about each stock into there journal. The app lets you manage all of your favorite stocks that are updated in real time and help 
   you discover potential new stocks for you to invest! 

2. What external data source(s) did you use? What form do they take (e.g., RESTful API, cloud-based database, etc.)?

   The external data source I used was the Alpha Vantage Restful API which includes all of the stock/crypto data for me to grab and put onto the app dynamically through api calls.

3. What additional third-party packages or libraries did you use, if any? Why?

   I used the Provider package to the statemanagement on the whole app, updating the UI dynamically. I also used the 'sqflite_common_ffi' as the database to store all of the notes. I
   used the added libraries already like the flutter_test and integration_test for the units/widgets/integration tests.

4. What form of local data persistence did you use?

   I used an SQLite database, implemented using the sqflite package, which was already added to the pubspec.yaml file.

5. What workflow is tested by your integration test?

   The integration test checks the functionality of searching for and adding a stock to favorites, navigating to the dashboard, adding a note to the stock, and verifying if the note 
   appears in the journal. However, I was not able to get it fully functional. 


## Summary and Reflection

My main focus was to create an app with  journaling functions for stocks that users really like. The app allows users to add, edit, and delete notes for their favorite stocks using the SQLite database 
for local storage. I included the provider package for the state management, which has been great for managing the entire app effectively. To enhance user experience, I added the explore page where users 
can browse popular and trending stocks. I also included features such as sorting stocks in different orders and refreshing the dashboard to reflect any real time updates.The biggest challenge I faced was 
the API's strict limit of fewer than 25 calls per day, which significantly restricted real-time updates for stock data. I looked into alternative resources but most of them required a really expensive 
subscription. My solution was to add a static list of these stocks as a fallback in case users can't access the relevant information when the API limits are touched.



I really enjoyed this challenge as it allowed me to explore my interests and develop an app that I would genuinely love to use. It was an exciting experience to have the creative freedom to design and 
implement features while applying the skills we learned throughout the semester. I wish I had more time to add additional features to make the app even better, but overall, it was a rewarding experience.
The only part I found frustrating was the difficulty in finding good REST APIs with generous limits. Many APIs had restrictive daily call limits, which made it harder to build a fully dynamic app. I 
wish there were more resources or recommendations for APIs that would better support projects like this. On the other hand, I thoroughly enjoyed learning about and implementing unit testing for the
first time. It gave me valuable insight into how important testing is as a software engineer.