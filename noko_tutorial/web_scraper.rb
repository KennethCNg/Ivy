# require 'HTTParty'
require 'Nokogiri'
require 'open-uri'
# require 'JSON'
# require 'Pry'
# require 'csv'
# require 'net/http'
page = Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02'))

itemHeader = page.css('h3.lister-item-header')
name = page.css('h3.lister-item-header')[3].children.children.text.split("\n")[0].split("  ")[1]

images = page.css('div.lister-item-image').css('a').css('img')[1].values[2]

link = page.css('h3.lister-item-header')[0].css('a')[0].attributes["href"].value
header = "http://www.imdb.com"
# p header + link

# page.css('div.lister-item-content')[1] <- this index determines the actress
itemContentHeader = page.css('div.lister-item-content')
mostKnownWork = page.css('div.lister-item-content')[0].children[3].children[3].children.text.split("\n")[0]
# p mostKnownWork = mostKnownWork.slice(1, mostKnownWork.length - 1)

mostKnownWorkUrl = page.css('div.lister-item-content')[1].children[3].children[3].attributes["href"].value
# header + mostKnownWorkLink

page1 = Nokogiri::HTML(open(header + mostKnownWorkUrl))
rating = page1.css('div.ratingValue')[0].children[1].children.children.text
# rating = page1.css('div.ratingValue')[0].children[1].children.children.text

directorName = page1.css('div.credit_summary_item')[0].children[3].children[1].children[0].children.text
# directorName = page1.css('div.credit_summary_item')[0].children[3].children[1].children[0].children.text

nameCount = page.css('h3.lister-item-header').length

nameArr = []

i = 0
while i < nameCount
    nameArr.push(
        {
            "name": itemHeader[i].children.children.text.split("\n")[0].split("  ")[1],
            "photoUrl": page.css('div.lister-item-image').css('a').css('img')[i].values[2],
            "profileUrl": header + itemHeader[i].css('a')[0].attributes["href"].value,
            "mostKnownWork": {
                "title": itemContentHeader[i].children[3].children[3].children.text.split("\n")[0],
                "url": header + itemContentHeader[i].children[3].children[3].attributes["href"].value,
                "rating": rating,
                "director": directorName,
            }
        }
    )
    i += 1
end

test = {
    "people": nameArr,
}

nameArr.length