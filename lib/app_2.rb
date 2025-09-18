require 'nokogiri'
require 'open-uri'

def super_scrap
  url = "https://lannuaire.service-public.fr/navigation/ile-de-france/mairie"
  html = URI.open(url)
  page = Nokogiri::HTML(html)

  mairie_links = page.css("a").select { |link| link['data-test'] == "href-link-annuaire" }

  hash_mairies = {}

  mairie_links.each do |link|
    nom = link.text.strip
    relative_url = link['href']
    full_url = URI.join("https://lannuaire.service-public.fr", relative_url)

    begin
      html2 = URI.open(full_url)
      page2 = Nokogiri::HTML(html2)

      email_link = page2.at_css("a.send-mail")
      email = email_link ? email_link.text.strip : "Email non trouvé"

      hash_mairies[nom] = email

    rescue => e
      puts "Erreur sur #{nom} : #{e.message}"
      hash_mairies[nom] = "Erreur de récupération"
    end
  end

  return hash_mairies
end


resultat = super_scrap
puts resultat

