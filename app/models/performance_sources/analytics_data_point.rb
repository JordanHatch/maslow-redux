module PerformanceSources
  class AnalyticsDataPoint
    attr_reader :date, :url

    class URLNotInScope < StandardError; end

    class PathReport
      extend Legato::Model

      metrics :pageviews
      filter(:for_path) {|path| matches(:pagePath, path) }
    end

    def initialize(date, url)
      @date = date
      @url = url

      raise(URLNotInScope, url) unless url_in_scope?
    end

    def pageviews
      result.present? ? result.pageviews : 0
    end

  private
    def result
      @result ||= fetch_result
    end

    def profile
      @profile ||= GoogleAnalyticsService.new.profile
    end

    def fetch_result
      query = PathReport.for_path(path)
      results = query.results(profile, start_date: date,
                                       end_date: date)
      results.each.first
    end

    def path
      begin
        URI.parse(url).path
      rescue
        nil
      end
    end

    def url_in_scope?
      url =~ base_url_pattern
    end

    def base_url_pattern
      /\Ahttps?:\/\/#{base_url.host}/
    end

    def base_url
      URI.parse(
        profile.attributes['websiteUrl']
      )
    end

  end
end
