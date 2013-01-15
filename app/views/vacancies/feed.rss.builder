xml.instruct! :xml, :version => '1.0'

xml.rss :version => '2.0'  do
  xml.channel do
    xml.title [t('appletunity'), t('best_vacancies')].join(' - ')
    xml.link vacancies_url
    xml.language('ru-ru')

    @vacancies.each do |v|
      url = vacancy_url(v, {
        utm_source: 'rss',
        utm_medium: 'referral',
        utm_campaign: Date.today.strftime('%b').downcase
      })

      xml.item do
        xml.title v.title
        xml.description v.rendered_body
        xml.pubDate v.created_at
        xml.link url
        xml.guid url
      end
    end
  end
end
