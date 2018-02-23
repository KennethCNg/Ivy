require 'Nokogiri'
require 'open-uri'

STORE = {
    "page" => Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')), # page variables changes if there is a next page
    "header" => "http://www.imdb.com",
    "item_header" => Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')).css('h3.lister-item-header'),
    "item_content_header" => Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')).css('div.lister-item-content'),
    "most_known_work_template" => Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')).css('div.lister-item-content').css('p.text-muted').css('a'),
    "most_known_work_length" => Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')).css('p.text-muted').css('a').text.split("\n")[0].length,
    "titles" => Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')).css('div.lister-item-content').css('p.text-muted').css('a').text.split("\n").map { |title| title[1..-1] },
    "name_arr" => [],
    
}

def fetch_data

    return_obj = {
        "people": STORE["name_arr"],
    }
    
    scrape_page

    # until next_page?    
        # if next_page?
            # change_page
        # end
        # scrape_page
    # end

    return_obj
end


def scrape_page
    i = 0
    name_count = STORE["item_header"].length
    
    while i < name_count

        name = name(i)
        photo_url = photo_url(i)
        profile_URL = profile_URL(i)

        # MOST KNOWN WORK
        most_known_work = most_known_work(i)
        most_known_work_URL = most_known_work_URL(i)

        # MOVIE PAGE
        movie_page = movie_page(most_known_work_URL)
        rating = rating(movie_page)
        director = director(movie_page)

        STORE["name_arr"].push(
            {
                "name": name,
                "photoUrl": photo_url,
                "profileUrl": profile_URL,
                "most_known_work": {
                    "title": most_known_work,
                    "url": most_known_work_URL,
                    "rating": rating,
                    "director": director,
                }
            }
        )
        i += 1
    end

    
end

def next_page?
    url = STORE["page"].css('a.lister-page-next')[0].attributes["href"].value
    if url
        # change_page(STORE[header] + url)
        puts "it works"
    else
        puts "it doesnt work"
    end
end

def change_page(new_url)
    
end

def director(movie_page)
    movie_page.css('div.credit_summary_item')[0].css('span')[0].css('a').css('span').text
end

def rating(movie_page)
    movie_page.css('div.ratingValue')[0].children[1].children.children.text
end

def movie_page(most_known_work_URL)
    Nokogiri::HTML(open(most_known_work_URL))
end

def most_known_work_URL(i)
    STORE["header"] + STORE["most_known_work_template"][i].attributes["href"].value
end

def name(i)
    STORE["item_header"][i].children.children.text.split("\n")[0].split("  ")[1]
end

def photo_url(i)
    STORE["page"].css('div.lister-item-image').css('a').css('img')[i].values[2]
end

# def photo_url(i)
#     STORE["header"] + STORE["item_header"][i].css('a')[0].attributes["href"].value
# end

def most_known_work(i)
    STORE["titles"][i]
end

def profile_URL(i)
    STORE["header"] + STORE["item_header"][i].css('a')[0].attributes["href"].value
end

p fetch_data

# len = Nokogiri::HTML(open('http://www.imdb.com/search/name?birth_monthday=02-02')).css('p.text-muted').css('a').text.split("\n")[1].length
# .slice(1, len).split("\n")[1]