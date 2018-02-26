IMDB Web Scraper

This project was a coding challenge. Given a month and date, the script should return a JSON object of all actors/actress with the respective birthday in this format:

{ people: [ { name: "Gemma Arterton", photoUrl: "https://images-na.ssl-images-amazon.com/images/M/MV5BOTAwNTMwMzE5OF5BMl5BanBnXkFtZTgwMjYwNzI2MjE@._V1_UX140_CR0,0,140,209_AL_.jpg", profileUrl: "http://www.imdb.com/name/nm2605345", mostKnownWork: { title: "Prince of Persia: The Sands of Time", url: "http://www.imdb.com/title/tt0473075/", rating: 6.6, director: "Louis Leterrier" } }, ... ] } 

### Get Started

1. Install dependencies by running `bundle install`
2. Start your server by running `ruby routes.rb`
3. Go to `http://localhost:4567/birthday/:month/:day` and input two integers, for month and day

Please note: I've actually decided to print each actor/actress object as it's being scraped so you can see it as the API is building the JSON object. Feel free to comment out `p res_arr[-1]` if you don't want the server to show it.


### Technologies

1. Sinatra was used for the front-end routes. I decided to use Sinatra because I was looking for a very simple and lightweight method  for users to hit my API. What's easier than 4 lines of code?

2. Nokigiri was used to do the actual web scraping. Nokigiri is well-known, and dependable so using this was an easy choice.

3. I used Ruby instead of JavaScript simply because Ivy is a Rails shop.

### Decisions

1. The name, photoUrl, profileUrl, mostKnownWork(title), mostKnownWork(url) property of the actor/actress is stored within an array when initially scraped. The reason I did this was because the debugging would be a lot simplier in the long run. If you were to print the array, you'd see exactly the data that go into the JSON object.

Only the rating, and director are NOT stored in an array, and are scraped individually as each actor/actress object is being created.

### Things I Learned

1. Scraping! I've never done this before, and this was a great intro into it. 