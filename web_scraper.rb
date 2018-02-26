require 'Nokogiri'
require 'open-uri'
require 'pry'

HEADER = "http://www.imdb.com"


# main function that delegates scraping to 'def scrape_page'
def fetch_data(month, day)
    page = Nokogiri::HTML(open("http://www.imdb.com/search/name?birth_monthday=#{month}-#{day}"))
    res_arr = []
    
    url = scrape_page(page, res_arr)
    while next_page?(page)
        new_url = next_page?(page)
        page = change_page(new_url)
        scrape_page(page, res_arr)
    end

    # this is the obj that will be turned to json
    return_obj = {
        "people": res_arr
    }
end

def scrape_page(page, res_arr)
    name_arr = scrape_name(page)
    photo_url_arr = scrape_photo_url(page)
    profile_url_arr = scrape_profile_url(page)
    most_known_work_arr = scrape_most_known_work(page)
    most_known_work_url_arr = scrape_most_known_work_url(page)

    i = 0
    while i < page.css('div.lister-item').length
        if most_known_work_arr[i]
            most_known_work_url = HEADER + most_known_work_url_arr[i]
            movie_page = fetch_movie_page(most_known_work_url)
            rating = scrape_rating(movie_page)
            director = scrape_director(movie_page)
        else
            most_known_work_url = nil
            movie_page = nil
            rating = nil
            director = nil
        end

        res_arr.push(
            {
                "name": name_arr[i],
                "photoURL": photo_url_arr[i],
                "profileURL": HEADER + profile_url_arr[i],
                "mostKnownWork": {
                    "title": most_known_work_arr[i],
                    "url": most_known_work_url,
                    "rating": rating,
                    "director": director,
                }
            }
        )
        
        p res_arr[-1]

        i += 1
    end
end

# HELPER METHODS

# checks for "next link on the page"
def next_page?(page)
    url = page.css('a.lister-page-next')
    if url.empty?
        return nil
    else
        url[0].attributes["href"].value
    end
end

# changes the page if next_page? returns true
def change_page(new_url)
    Nokogiri::HTML(open(HEADER + new_url))
end


# HELPER METHODS BELOW ACTUALLY DO THE SCRAPING
def scrape_name(page)
    page.css('div.lister-item').css('h3.lister-item-header').css('a').text.split("\n").map { |name| name[1..-1]}
end

def scrape_profile_url(page)
    page.css('div.lister-item').css('h3.lister-item-header').map do |url|
        url.css('a')[0].attributes["href"].value
    end
end

def scrape_photo_url(page)
    page.css('div.lister-item').css('div.lister-item-image').css('a').css('img').map do |url|
        url.attributes['src'].value
    end
end

def scrape_most_known_work(page)
    page.css('div.lister-item').css('div.lister-item-content').map do |title|
        if title == []
            nil
        else
            title.css("p.text-muted").css("a").children.text[1..-2]
        end
    end
end

def scrape_most_known_work_url(page)
    page.css('div.lister-item').css('div.lister-item-content').map do |url|
        if url.css("p.text-muted").empty?
            nil
        else
            url.css("a")[1].attributes["href"].value
        end
    end
end

def fetch_movie_page(most_known_work_url)
    Nokogiri::HTML(open(most_known_work_url))
end

def scrape_rating(movie_page)
    if movie_page.css('div.ratingValue')[0]
        movie_page.css('div.ratingValue')[0].children[1].children.children.text
    else 
        nil
    end
end

def scrape_director(movie_page)
    if movie_page.css('div.credit_summary_item')[0].css('span').empty?
        nil
    else
        movie_page.css('div.credit_summary_item')[0].css('span')[0].css('a').css('span').text
    end
end