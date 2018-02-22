require 'Nokogiri'
require 'open-uri'

def fetch_data

    header = "http://www.imdb.com"
    
    page = Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02'))

    itemHeader = page.css('h3.lister-item-header')
    
    nameCount = itemHeader.length

    nameArr = []

    itemContentHeader = page.css('div.lister-item-content')
    i = 0
    while i < nameCount

        name = itemHeader[i].children.children.text.split("\n")[0].split("  ")[1]

        photoURL = page.css('div.lister-item-image').css('a').css('img')[i].values[2]

        profileURL = header + itemHeader[i].css('a')[0].attributes["href"].value

        # MOST KNOWN WORK

        mostKnownWorkTemplate = itemContentHeader.css('p.text-muted').css('a')

        mostKnownWorkLength = mostKnownWorkTemplate.text.split("\n")[0].length

        mostKnownWork = mostKnownWorkTemplate.text.slice(1, mostKnownWorkLength - 1).split("\n")[i]

        mostKnownWorkURL = header + mostKnownWorkTemplate[i].attributes["href"].value

        page1 = Nokogiri::HTML(open(mostKnownWorkURL))

        rating = page1.css('div.ratingValue')[0].children[1].children.children.text
        
        p directorName = page1.css('div.credit_summary_item')[0].css('span')[0].css('a').css('span').text

        nameArr.push(
            {
                "name": name,
                "photoUrl": photoURL,
                "profileUrl": profileURL,
                "mostKnownWork": {
                    "title": mostKnownWork,
                    "url": mostKnownWorkURL,
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
end

p fetch_data
