require 'http'
require 'nokogiri'
require 'open-uri'




def super_scrap
url = "https://coinmarketcap.com/all/views/all"
html = URI.open(url)
page = Nokogiri::HTML(html)
crypto_name = page.xpath('//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[2]/div/a[2]')
array_name = crypto_name.map {|node| node.text.strip}
crypto_currencies =page.xpath('//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[5]/div/span')
array_currencies = crypto_currencies.map {|node| node.text.strip}

hash_crypto = array_name.zip(array_currencies).map {|array_name, array_currencies| {array_name => array_currencies}}
return hash_crypto
end

puts super_scrap

 
