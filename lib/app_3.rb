require 'nokogiri'
require 'open-uri'
require 'pry'

def super_scrap
  depute = []

  url = "https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"
  html = URI.open(url)
  page = Nokogiri::HTML(html)

  liste_deputes = page.css("ul.col3 a")
  total = liste_deputes.length
  compteur = 0

  liste_deputes.each do |lien|
    compteur += 1

    begin
      nom_complet = lien.text.strip
      nom_sans_titre = nom_complet.gsub(/\A(Mme?|M)\.?\s+/i, '')
      prenom, nom = nom_sans_titre.split(" ", 2)

      # 👉 SUIVI DE PROGRESSION
      puts "[#{compteur}/#{total}] Scraping de #{prenom} #{nom}..."

      # Accès à la page perso
      url_perso = "https://www2.assemblee-nationale.fr" + lien['href']
      html2 = URI.open(url_perso)
      page2 = Nokogiri::HTML(html2)

      # Récupération de l'email
      email_node = page2.at_xpath('//*[@id="main"]/div/div/div/section[2]/div/ul/li[1]/a/span[2]')
      email = email_node ? email_node.text.strip : "Email non disponible"

      # Construction du hash
      depute << {
        prenom: prenom,
        nom: nom,
        email: email
      }

      sleep(0.2)  # ne pas surcharger le serveur

    rescue => e
      puts "❌ Erreur pour #{lien.text.strip} : #{e.message}"
    end
  end

  return depute
end

# Appel de la fonction pour test
puts super_scrap

