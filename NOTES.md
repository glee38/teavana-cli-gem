###Here is a quick breakdown of how to get started:
1. Plan your gem, imagine your interface
2. Start with the project structure - google: "how to build a ruby gem"
3. Start with the entry point - the file run
4. Force that to build the CLI interface
5. Stub out the interface
6. Start making things real
7. Discover objects
8. Program

###1: Plan your gem, imagine your interface
What kind of gem are you looking to make? How do you want the user to interact with the gem via the CLI?

For example: Teavana CLI Gem

```
Home
Welcome to Teavana!
What kind of tea are you looking for today?
1. Green Tea
2. Black Tea
3. White Tea
...etc.

#user enters "1"
Home > Green Tea
Here are a list of green teas available:
1. Organic Imperial Matcha Singles: 10-Pack - 19.95
2. Organic Peach Matcha Singles: 10-Pack - 19.95
3. Gyokuro Imperial Green Tea - 19.98
...etc.
Which tea would you like to know more about?
Enter "home" to go back to the full list of teas.

#user enters "3"
Home > Green Tea > Gyokuro Imperial Green Tea

RATING
4.4/5 stars

PRICE
19.98

DESCRIPTION

Gyokuro bushes are covered in shade two weeks before 
harvesting, which creates a light but very complex 
blend and a luscious deep dark green color. The 
shading helps the leaves to retain chlorophyll, 
which concentrates both the green tea taste and 
nutrients, making this a bright and flavorful favorite.

TASTING NOTES
Rich, almost full-bodied, smooth taste with sweet 
ending and complex notes

CAFFEINE LEVEL
3

CAFFEINE GUIDE
4: 40+ MG
3: 26-39 MG
2: 16-25 MG
1: 1-15 MG
0: CAFFEINE-FREE

INGREDIENTS
Green tea
```
