require 'spec_helper'

describe FrontendHelper do
  describe '#concat_css_class' do
    it 'should return nil' do
      helper.concat_css_class.should be_nil
    end
    
    it 'should return nil' do
      helper.concat_css_class(nil).should be_nil
    end

    it 'should return concatenated css classes' do
      helper.concat_css_class('one', 'two').should == 'one two'
    end

    it 'should return concatenated css classes' do
      helper.concat_css_class('one two', 'three').should == 'one two three'
    end

    it 'should return concatenated css classes' do
      helper.concat_css_class('one two ', ' three ').should == 'one two three'
    end
  end

  describe '#spinner_button_tag' do
    it 'should return nil' do
      helper.spinner_button_tag.should be_nil
    end
    
    it 'should return nil' do
      helper.spinner_button_tag(nil).should be_nil
    end

    it 'should return button tag' do
      helper.spinner_button_tag('Submit').should eq(
        %(<button data-disable-with="#{helper.spinner}" name="button" type="submit">Submit</button>)
      )
    end

    it 'should return button tag' do
      helper.spinner_button_tag('Submit', class: 'btn').should eq(
        %(<button class="btn" data-disable-with="#{helper.spinner}" name="button" type="submit">Submit</button>)
      )
    end
  end

  describe '#spinner_file_field_tag' do
    it 'should return nil' do
      helper.spinner_file_field_tag.should be_nil
    end
    
    it 'should return nil' do
      helper.spinner_file_field_tag(nil).should be_nil
    end

    it 'should return file field tag' do
      helper.spinner_file_field_tag(:image, 'File').should eq(
        %(<div class="input file" data-disable-with="#{helper.spinner}"><span>File</span><input id="image" name="image" type="file" /></div>)
      )
    end

    it 'should return file field tag' do
      helper.spinner_file_field_tag(:image, 'File', class: 'btn').should eq(
        %(<div class="input file btn" data-disable-with="#{helper.spinner}"><span>File</span><input id="image" name="image" type="file" /></div>)
      )
    end
  end
end