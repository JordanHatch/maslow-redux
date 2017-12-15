require 'rails_helper'

RSpec.describe GoogleAnalyticsService do

  subject { GoogleAnalyticsService.new }

  let(:mock_legato_user) { double('Legato::User') }
  let(:website_url) { 'http://example.org' }
  let(:profiles) {
    [
      OpenStruct.new(id: 5),
      OpenStruct.new(id: 7, attributes: { 'websiteUrl' => website_url }),
      OpenStruct.new(id: 9),
    ]
  }
  let(:view_id) { 7 }

  before do
    allow(Legato::User).to receive(:new).and_return(mock_legato_user)
    allow(subject).to receive(:access_token).and_return('12345')

    allow(mock_legato_user).to receive(:profiles).and_return(profiles)
  end

  describe '#profile' do
    it 'returns the profile matching the configured Google Analytics view' do
      allow(subject).to receive(:view_id).and_return(view_id)

      expect(subject.profile.id).to eq(view_id)
    end

    it 'raises an exception if the profile is not present' do
      allow(subject).to receive(:view_id).and_return(6)

      expect { subject.profile }.to raise_error(GoogleAnalyticsService::ProfileNotFound)
    end
  end

  describe '#website_url' do
    it 'returns the website URL from the profile' do
      allow(subject).to receive(:view_id).and_return(view_id)

      expect(subject.website_url).to eq(website_url)
    end
  end


end
