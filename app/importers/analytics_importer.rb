class AnalyticsImporter

  def initialize(logger: Rails.logger, need_id: nil)
    @logger = logger
    @need_id = need_id
  end

  def run!
    need_responses.each do |response|
      import_analytics_for_response(response)
    end
  end

private
  attr_reader :logger, :need_id

  def need_responses
    if need_id.present?
      Need.find(need_id).need_responses.with_url
    else
      NeedResponse.includes(:need).with_url
    end
  end

  def import_analytics_for_response(response)
    logger.info "RESPONSE ##{response.id} (Need #{response.need.id})"

    begin
      each_date_in_range do |date|
        logger.info "\tDATE #{date}"

        if data_point_already_exists?(date, response)
          logger.info "\t\tNot a recent date, and data already exists – skipping."
          next
        end

        data_point = fetch_data_point(date, response)
        create_performance_point_for_response(response, data_point)
      end
    rescue PerformanceSources::AnalyticsDataPoint::URLNotInScope
      logger.info "\t\tURL is out of scope, skipping"
    end
  end

  def each_date_in_range(&block)
    date_range.each(&block)
  end

  def date_range
    (3.months.ago.to_date..Date.today)
  end

  def fetch_data_point(date, response)
    PerformanceSources::AnalyticsDataPoint.new(date, response.url)
  end

  def create_performance_point_for_response(response, data_point)
    point = response.performance_points.find_or_initialize_by(metric_type: :pageviews,
                                                             date: data_point.date)
    point.value = data_point.pageviews
    point.save!

    logger.info "\t\tPerformance point saved"
  end

  def data_point_already_exists?(date, response)
    date < 1.week.ago &&
      response.performance_points.where(metric_type: :pageviews, date: date).any?
  end

end
