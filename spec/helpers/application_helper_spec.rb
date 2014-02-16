require 'spec_helper'

describe ApplicationHelper do
  describe '#copyright_years' do
    it "should return '2012'" do
      helper.copyright_years(to: 2012).should eq '2012'
    end

    it "should return '2012-2015'" do
      helper.copyright_years(to: 2015).should eq '2012-2015'
    end
  end

  describe '#bootstrapize_flash_key' do
    it 'should be nil' do
      helper.bootstrapize_flash_key(nil).should be_nil
    end

    it 'should be nil' do
      helper.bootstrapize_flash_key(:test).should be_nil
    end

    it "should return 'alert-success'" do
      helper.bootstrapize_flash_key(:message).should == 'alert-success'
    end

    it "should return 'alert-success'" do
      helper.bootstrapize_flash_key(:notice).should == 'alert-success'
    end

    it "should return 'alert-error'" do
      helper.bootstrapize_flash_key(:error).should == 'alert-error'
    end

    it "should return 'alert-error'" do
      helper.bootstrapize_flash_key(:alert).should == 'alert-error'
    end
  end

  describe '#title_and_metas' do
    before { controller.stub(:controller_name).and_return('vacancies') }

    it 'should be html safe' do
      helper.title_and_metas.should be_html_safe
    end

    it 'should set default title and meta tags' do
      helper.title_and_metas.split("\n").should == [
        content_tag(
          :title,
          [I18n.t('ui.text.appletunity'), I18n.t('ui.text.best_vacancies')].join(' - ')
        ),
        tag(:meta, property: 'og:image', content: '/assets/appletunity.png'),
        tag(:meta, name: 'description', content: I18n.t('ui.text.intro'))
      ]
    end

    it 'should set default title and meta tags related to the object' do
      @resource = FactoryGirl.build(:vacancy)

      helper.title_and_metas.split("\n").should == [
        content_tag(
          :title,
          [I18n.t('ui.text.appletunity'), @resource.company_name, @resource.title].join(' - ')
        ),
        tag(:meta, property: 'og:image', content: image_path(@resource.logo)),
        tag(:meta, name: 'description', content: 'Some body')
      ]
    end

    it 'should set default title and meta tags related to the object' do
      @resource = FactoryGirl.build(:vacancy, logo: nil)

      helper.title_and_metas.split("\n").should == [
        content_tag(
          :title,
          [I18n.t('ui.text.appletunity'), @resource.company_name, @resource.title].join(' - ')
        ),
        tag(:meta, property: 'og:image', content: '/assets/appletunity.png'),
        tag(:meta, name: 'description', content: 'Some body')
      ]
    end
  end

  describe '#breadcrumbs' do
    it 'should return nil' do
      helper.breadcrumbs.should be_nil
    end

    context 'when resource present' do
      before { @resource = FactoryGirl.build(:vacancy) }
      
      it 'should return resource related breadcrumbs' do
        html = %(<a href="/">Главная</a><span class="splitter">&raquo;</span><span>Новая вакансия</span>).html_safe
        helper.breadcrumbs.should == content_tag(:div, html, id: 'breadcrumbs')
      end

      context 'and resource persisted' do
        before { @resource.stub(:persisted?).and_return(true) }
        
        it 'should return resource related breadcrumbs' do
          html = %(<a href="/">Главная</a><span class="splitter">&raquo;</span><span>Some title</span>).html_safe
          helper.breadcrumbs.should == content_tag(:div, html, id: 'breadcrumbs')
        end
      end
    end
  end
end