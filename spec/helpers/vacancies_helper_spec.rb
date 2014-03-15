require 'spec_helper'

describe VacanciesHelper do
  describe '#mailto_for' do
    it 'should return nil' do
      helper.mailto_for(nil).should be_nil
    end

    it 'should return right mailto string' do
      vacancy = mock_model(Vacancy)

      vacancy.stub(:title).and_return('some_title')
      vacancy.stub(:contact_email).and_return('some@email.com')
      
      helper.mailto_for(vacancy).should eq 'mailto:some@email.com?subject=some_title'
    end
  end

  describe '#title_for' do
    it 'should return nil' do
      helper.title_for(nil).should be_nil
    end

    context 'when Vacancy instance given' do
      it 'should return vacancy title' do
        vacancy = mock_model(Vacancy)
        vacancy.stub(:title).and_return('some_title')
        vacancy.stub(:company_name).and_return('some_company_name')
        helper.title_for(vacancy).should eq '[some_company_name] some_title'.html_safe
      end
    end
  end

  describe '#logo_for' do
    it 'should return nil' do
      helper.logo_for(nil).should be_nil
    end

    context 'when Vacancy instance given' do
      let(:logo) { FactoryGirl.build(:logo) }
      let (:vacancy) { FactoryGirl.build(:vacancy, logo: logo) }

      it 'should return vacancy logo html' do
        helper.logo_for(vacancy).should == [
          %(<div class="company-logo"><div class="logo-container">),
            %(<a data-skip-pjax="" href="http://example.com" target="_blank">),
              %(<img alt="Some company name" src="#{vacancy.logo.image.url(:small)}" />),
            %(</a>),
          %(</div></div>)
        ].join
      end

      it 'should return vacancy logo html' do
        helper.logo_for(vacancy, :normal).should == [
          %(<div class="company-logo"><div class="logo-container">),
            %(<a data-skip-pjax="" href="http://example.com" target="_blank">),
              %(<img alt="Some company name" src="#{vacancy.logo.image.url(:normal)}" />),
            %(</a>),
          %(</div></div>)
        ].join
      end

      it 'should return vacancy logo html' do
        vacancy.stub(:company_website).and_return(nil)
        helper.logo_for(vacancy).should == [
          %(<div class="company-logo"><div class="logo-container">),
            %(<img alt="Some company name" src="#{vacancy.logo.image.url(:small)}" />),
          %(</div></div>)
        ].join
      end

      context 'and no logo file attached' do
        before { vacancy.stub(:logo).and_return(nil) }
        
        it 'should return fallback logo html' do
          helper.logo_for(vacancy).should == [
            %(<div class="company-logo"><div class="logo-container">),
              %(<a data-skip-pjax="" href="http://example.com" target="_blank">),
                %(<img alt="Some company name" src="/assets/no_logo.png" />),
              %(</a>),
            %(</div></div>)
          ].join
        end

        it 'should return fallback logo html' do
          vacancy.stub(:company_website).and_return(nil)
          helper.logo_for(vacancy).should == [
            %(<div class="company-logo"><div class="logo-container">),
              %(<img alt="Some company name" src="/assets/no_logo.png" />),
            %(</div></div>)
          ].join
        end
      end
    end
  end

  describe '#build_share_link_to' do
    it 'should return nil' do
      helper.build_share_link_for(nil, nil).should be_nil
    end

    context 'when arguments given' do
      let(:vacancy) { FactoryGirl.build(:vacancy) }

      before :each do
        Date.stub_chain(:today, :strftime).and_return('jan')
      end

      it 'should return nil' do
        helper.build_share_link_for(:unknown_network, vacancy).should be_nil
      end

      it 'should return twitter share link' do
        url = vacancy_url(vacancy, {
          utm_source: 'twitter',
          utm_medium: 'referral',
          utm_campaign: 'jan'
        })
        
        result = URI.parse 'https://twitter.com/share'
        result.query = URI.encode_www_form(
          text: title_for(vacancy),
          url: url,
          hashtags: 'appletunity',
          via: 'appletunity'
        )
        
        helper.build_share_link_for(:twitter, vacancy).should eq result.to_s
      end

      it 'should return facebook share link' do
        url = vacancy_url(vacancy, {
          utm_source: 'facebook',
          utm_medium: 'referral',
          utm_campaign: 'jan'
        })

        result = URI.parse('https://facebook.com/sharer/sharer.php')
        result.query = URI.encode_www_form(u: url)
        
        helper.build_share_link_for(:facebook, vacancy).should eq result.to_s
      end

      it 'should return google+ share link' do
        url = vacancy_url(vacancy, {
          utm_source: 'gplus',
          utm_medium: 'referral',
          utm_campaign: 'jan'
        })

        result = URI.parse('https://plus.google.com/share')
        result.query = URI.encode_www_form(url: url)
        
        helper.build_share_link_for(:gplus, vacancy).should eq result.to_s
      end
    end
  end

  describe '#format_website_url_for' do
    let(:vacancy) { FactoryGirl.build(:vacancy) }

    it 'should return nil' do
      helper.format_website_url_for(nil).should be_nil
    end

    it 'should return nil' do
      vacancy.company_website = nil
      helper.format_website_url_for(vacancy).should be_nil
    end

    it 'should return nil' do
      vacancy.company_website = 'bad url'
      helper.format_website_url_for(vacancy).should be_nil
    end

    context 'when http is not present' do
      before { vacancy.company_website = url }

      let(:url) { "#{('a'..'z').to_a.shuffle[0,8].join}.com" }
      
      it 'should return url started with http://' do
        helper.format_website_url_for(vacancy).should == "http://#{url}"
      end
    end
  end
end