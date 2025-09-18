<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>README combiné - app & app_2</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #fafafa;
      margin: 2em;
      line-height: 1.6;
      color: #333;
    }
    h1, h2 {
      color: #2c3e50;
    }
    pre {
      background: #f4f4f4;
      border-left: 5px solid #2980b9;
      padding: 1em;
      overflow-x: auto;
      font-family: monospace;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    code {
      font-family: monospace;
      color: #c7254e;
    }
    a {
      color: #2980b9;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    section {
      margin-bottom: 3em;
    }
  </style>
</head>
<body>

  <h1>📄 README Combiné pour les scripts Ruby <code>app_2</code> et <code>app</code></h1>

  <section>
    <h2>1. Script <code>app_2</code> - Scraping des Mairies et Emails</h2>
    <p>
      Ce script récupère les noms des mairies en Île-de-France ainsi que leurs adresses e-mail à partir du site 
      <a href="https://lannuaire.service-public.fr/navigation/ile-de-france/mairie" target="_blank">service-public.fr</a>.
    </p>

    <h3>Exemple de code</h3>
    <pre><code>require 'nokogiri'
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
</code></pre>

    <h3>Fonctionnement</h3>
    <ul>
      <li>Ouvre la page listant les mairies</li>
      <li>Récupère les liens relatifs et noms des mairies</li>
      <li>Pour chaque mairie, ouvre sa page dédiée</li>
      <li>Scrape l'adresse email si disponible</li>
      <li>Retourne un hash avec les noms en clés et emails en valeurs</li>
    </ul>

    <h3>Exemple de sortie</h3>
    <pre><code>{
  "Mairie de Paris" => "contact@paris.fr",
  "Mairie de Versailles" => "contact@versailles.fr",
  ...
}</code></pre>
  </section>

  <section>
    <h2>2. Script <code>app</code> - Scraping des Cryptomonnaies et Prix</h2>
    <p>
      Ce script scrape les noms et prix des cryptomonnaies listées sur 
      <a href="https://coinmarketcap.com/all/views/all" target="_blank">CoinMarketCap</a>.
    </p>

    <h3>Exemple de code</h3>
    <pre><code>require 'http'
require 'nokogiri'
require 'open-uri'

def super_scrap
  url = "https://coinmarketcap.com/all/views/all"
  html = URI.open(url)
  page = Nokogiri::HTML(html)

  crypto_name = page.xpath('//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[2]/div/a[2]')
  array_name = crypto_name.map { |node| node.text.strip }

  crypto_currencies = page.xpath('//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[5]/div/span')
  array_currencies = crypto_currencies.map { |node| node.text.strip }

  hash_crypto = array_name.zip(array_currencies).map { |name, price| { name => price } }
  return hash_crypto
end

puts super_scrap
</code></pre>

    <h3>Fonctionnement</h3>
    <ul>
      <li>Ouvre la page listant toutes les cryptomonnaies</li>
      <li>Scrape tous les noms</li>
      <li>Scrape tous les prix</li>
      <li>Associe chaque nom à son prix dans un tableau de hashes</li>
      <li>Affiche le résultat</li>
    </ul>

    <h3>Exemple de sortie</h3>
    <pre><code>[
  { "Bitcoin" => "$27,450.22" },
  { "Ethereum" => "$1,730.34" },
  { "Solana" => "$19.45" },
  ...
]</code></pre>

    <h3>Remarques importantes</h3>
    <ul>
      <li>Les sélecteurs XPath sont sensibles aux changements de la structure HTML du site.</li>
      <li>Pour un usage intensif, privilégiez l'API officielle de CoinMarketCap.</li>
    </ul>
  </section>

  <section>
    <h2>⚙️ Instructions d'exécution</h2>
    <p>Placez les scripts dans un fichier Ruby (ex: <code>app.rb</code> ou <code>app_2.rb</code>) et lancez-les via la console :</p>
    <pre><code>ruby app.rb
# ou
ruby app_2.rb
</code></pre>
  </section>

  <section>
    <h2>✍️ Auteur</h2>
    <p>Script Ruby développé par [Ton Nom]</p>
  </section>

</body>
</html>
