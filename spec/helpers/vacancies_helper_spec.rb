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
      before :each do
        @vacancy = mock_model(Vacancy)
        @vacancy.stub(:company_name).and_return('some_company_name')
        @vacancy.stub_chain(:logo, :url).and_return('/assets/some_logo.png')
      end
      
      it 'should return no logo image tag' do
        @vacancy.stub(:logo?).and_return(false)
        helper.logo_for(@vacancy).should eq %(<img alt="some_company_name" src="/assets/no_logo.png" />)
      end

      it 'should return vacancy logo image tag' do
        @vacancy.stub(:logo?).and_return(true)
        helper.logo_for(@vacancy).should eq %(<img alt="some_company_name" src="/assets/some_logo.png" />)
      end

      it 'should return vacancy logo image tag with class' do
        @vacancy.stub(:logo?).and_return(true)
        s = %(<img alt="some_company_name" class="well" src="/assets/some_logo.png" />)
        helper.logo_for(@vacancy, :medium, class: 'well').should eq s
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

        result = URI.parse 'https://facebook.com/sharer/sharer.php'
        result.query = URI.encode_www_form u: url
        
        helper.build_share_link_for(:facebook, vacancy).should eq result.to_s
      end

      it 'should return google+ share link' do
        url = vacancy_url(vacancy, {
          utm_source: 'gplus',
          utm_medium: 'referral',
          utm_campaign: 'jan'
        })

        result = URI.parse 'https://plus.google.com/share'
        result.query = URI.encode_www_form url: url
        
        helper.build_share_link_for(:gplus, vacancy).should eq result.to_s
      end
    end
  end
end