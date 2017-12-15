class NeedPerformanceQuery

  attr_reader :responses, :metric_type, :time_period, :time_group

  class InvalidTimePeriod < StandardError; end
  class InvalidTimeGroup < StandardError; end

  def initialize(responses, metric_type:, time_period:, time_group:)
    @responses = responses
    @metric_type = metric_type

    @time_period = time_period
    @time_group = time_group
  end

  def results
    with_responses do
      scope = base_scope.public_send(time_period_scope)

      if time_group_scope.present?
        scope = scope.public_send(time_group_scope)
      end

      scope
    end
  end

private
  def base_scope
    NeedPerformancePoint.for_metric(metric_type)
                         .for_responses(responses)
  end

  def time_period_scope
    case time_period
    when :week then :this_week
    when :month then :this_month
    when :quarter then :this_quarter
    else
      raise InvalidTimePeriod, time_period
    end
  end

  def time_group_scope
    case time_group
    when :day then nil
    when :week then :by_week
    when :month then :by_month
    else
      raise InvalidTimeGroup, time_group
    end
  end

  def with_responses(&block)
    yield(block).group_by(&:need_response)
  end


end
