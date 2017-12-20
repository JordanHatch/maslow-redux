json.status 'ok'

json.need do
  json.partial! 'needs/basic_info', need: need
end

json.need_response do
  json.partial! 'need_responses/response', need_response: need_response
end

json.need_performance_point do
  json.partial! 'performance_point', performance_point: performance_point
end
