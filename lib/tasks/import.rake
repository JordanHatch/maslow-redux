namespace :import do

  desc "Imports needs given a CSV url"
  task :needs, [:csv_url, :max_responses, :max_met_when_criteria] => :environment do |t, args|
    csv_url = args[:csv_url]
    max_responses = args[:max_responses].to_i
    max_met_when_criteria = args[:max_met_when_criteria].to_i

    NeedImporter.new(
      csv_url: csv_url,
      max_responses: max_responses,
      max_met_when_criteria: max_met_when_criteria,
    ).run!
  end

end
