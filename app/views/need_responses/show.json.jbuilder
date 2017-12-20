json.status 'ok'

json.need do
  json.partial! 'needs/basic_info', need: need
end

json.need_response do
  json.partial! 'response', need_response: need_response
end
