I18n.available_locales.each do |locale|
  next if SiteCustomization::ContentBlock.find_by(locale: locale, name: "top_links")

  I18n.with_locale(locale) do
    SiteCustomization::ContentBlock.create!(
      locale: locale,
      name: "top_links",
      body: %Q(
        <li>
          <a href="https://transparencia.santiagodecompostela.gal/portada/#{locale}">
            #{I18n.t("sites.transparency.title")}
          </a>
        </li>
        <li>
          <a href="https://datos.santiagodecompostela.gal/#{locale}">
            #{I18n.t("sites.open_data.title")}
          </a>
        </li>
      )
    )
  end
end

lg_weather = { es: "cas", gl: "gal" }

I18n.available_locales.each do |locale|
  next if SiteCustomization::ContentBlock.find_by(locale: locale, name: "footer")

  I18n.with_locale(locale) do
    SiteCustomization::ContentBlock.create!(
      locale: locale,
      name: "footer",
      body: %Q(
        <li class="inline-block">
          <a href="http://www.santiagodecompostela.gal/tempo.php?lg=#{lg_weather[locale]}" title="#{I18n.t("sites.weather.title")}">
            <span class="show-for-sr">#{I18n.t("sites.weather.title")}</span>
            <span class="icon-otempo" aria-hidden="true"></span>
          </a>
        </li>
      )
    )
  end
end

header_widget_card = Widget::Card.new(label: nil, link_url: "http://consulproject.org/", header: true)

I18n.available_locales.each do |locale|
  I18n.with_locale(locale) do
    header_widget_card.update!(title: "Consul Santiago de Compostela",
                              description: "Prow scuttle parrel provost Sail ho shrouds spirits boom mizzenmast yardarm. Pinnace holystone mizzenmast quarter crow's nest nipperkin grog yardarm hempen halter furl. Swab barque interloper chantey doubloon starboard grog black jack gangway rutters.",
                              link_text: "VOTAR")
  end
end
