require 'rails_helper'

RSpec.describe NeedImporter do

  let(:csv) { file_fixture('need_import.csv') }
  let(:csv_url) { 'http://example.org/needs.csv' }
  let(:logger) { Rails.logger }

  let!(:tag_type_1) { create(:tag_type, name: 'Sections') }
  let!(:tag_type_2) { create(:tag_type, name: 'Organisations') }

  let!(:tag_1) { create(:tag, tag_type: tag_type_1, name: 'Crime and Policing') }
  let!(:tag_2) { create(:tag, tag_type: tag_type_2, name: 'Ministry of Magic') }
  let!(:tag_3) { create(:tag, tag_type: tag_type_2, name: 'Biscuit Standards Authority') }

  before do
    stub_request(:get, csv_url).to_return(status: 200, body: csv)
  end

  describe 'importing needs from a CSV' do
    before do
      importer = NeedImporter.new(csv_url: csv_url, logger: logger)
      importer.run!
    end

    let(:need) { Need.first }

    it 'creates a bot user for imports' do
      user = User.first

      expect(user.bot?).to eq(true)
      expect(user.name).to eq('Maslow needs importer bot')
    end

    it 'imports the basic need details' do
      expect(need.role).to eq('administrator')
      expect(need.goal).to eq('import needs from a CSV')
      expect(need.benefit).to eq('test that it works')

      expect(need.legislation).to eq('CSV Importing Act 2017')
      expect(need.other_evidence).to eq('Requested by five teams in November.')

      expect(need.yearly_user_contacts).to eq(100)
      expect(need.yearly_searches).to eq(1700)
      expect(need.yearly_need_views).to eq(3000)
      expect(need.yearly_site_views).to eq(150000)
    end

    it 'imports the "met when" criteria' do
      expect(need.met_when).to eq([
        'the need is imported',
        'all the fields are present',
      ])
    end

   it 'imports responses to the need' do
      expect(need.need_responses.count).to eq(3)

      expect(need.need_responses.map(&:response_type)).to eq([:content, :service, :other])
      expect(need.need_responses.map(&:name)).to eq(['Example 1', 'Example 2', 'Example 3'])
      expect(need.need_responses.map(&:url)).to eq(['http://example.org/', 'http://example.com/', 'http://example.net/'])
    end

    it 'imports tags with semicolon separation' do
      # NOTE: in the example fixture:
      #   - tags are separated by semicolons
      #   - tag 3 is present as lower case to test case-insensitive matching
      #

      expect(need.tags.of_type(tag_type_1)).to eq([tag_1])
      expect(need.tags.of_type(tag_type_2)).to eq([tag_2, tag_3])
    end
  end

end
