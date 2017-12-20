json.status 'ok'

json.need do
  json.partial! 'needs/basic_info', need: need
end

json.need_responses need.need_responses, partial: 'response', as: :need_response
