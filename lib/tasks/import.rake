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

  namespace :analytics do
    desc "Imports analytics data on responses for the specified need"
    task :single_need, [:need_id] => :environment do |t, args|
      need_id = args[:need_id]

      AnalyticsImporter.new(
        need_id: need_id,
        logger: Logger.new(STDOUT),
      ).run!
    end

    desc "Imports analytics data on responses for all needs"
    task :all => :environment do |t, args|
      AnalyticsImporter.new(
        logger: Logger.new(STDOUT),
      ).run!
    end
  end

end
