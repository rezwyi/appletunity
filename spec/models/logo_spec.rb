require 'spec_helper'

describe Logo do
  it { should have_attached_file(:image) }
  it { should validate_attachment_content_type(:image).allowing('image/jpeg', 'image/jpg', 'image/png')}
  it { should validate_attachment_content_type(:image).rejecting('text/plain', 'text/xml', 'image/tiff') }
  it { should validate_attachment_size(:image).in(0..10.megabytes) }

  describe 'fingerprint' do
  	# Force logo creation
  	before { logo }
    
    let(:logo) { FactoryGirl.create(:logo) }

    it 'should raise fingerprint error' do
    	expect { FactoryGirl.create(:logo) }.to raise_error(Logo::FingerprintError)
    end
  end
end