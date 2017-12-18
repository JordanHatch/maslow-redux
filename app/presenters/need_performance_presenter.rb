class NeedPerformancePresenter
  def initialize(query)
    @query = query
  end

  def stacked_performance
    results.map {|response, points|
      {
        name: response.name,
        data: graph_data_for(points)
      }
    }
  end

  def has_data_to_display?
    results.any?
  end

  def current_time_period
    query.time_period
  end

  def current_time_group
    query.time_group
  end

  def available_time_periods
    translate_labels(:time_periods, [ :week, :month, :quarter ])
  end

  def available_time_groups
    translate_labels(:time_groups, [ :day, :week, :month ])
  end

private
  attr_reader :query

  def results
    query.results
  end

  def translate_labels(type, values)
    values.map {|value|
      [ I18n.t("performance.graphs.#{type}.#{value}"), value ]
    }
  end

  def graph_data_for(points)
    points.map {|point|
      [
        point.date.strftime('%b %d, %Y'),
        point.value
      ]
    }
  end
end
