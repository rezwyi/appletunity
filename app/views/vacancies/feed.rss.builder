xml.instruct! :xml, :version => '1.0'

xml.rss :version => '2.0'  do
  xml.channel do
    xml.title [t('appletunity'), t('best_vacancies')].join(' - ')
    xml.link vacancies_url
    xml.language('ru-ru')

    @vacancies.each do |vacancy|
      xml.item do
        xml.title vacancy.title
        xml.description vacancy.rendered_body
        xml.pubDate vacancy.created_at
        xml.link vacancy_url(vacancy)
        xml.guid vacancy_url(vacancy)
      end
    end
  end
end