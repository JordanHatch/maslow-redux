json.status 'ok'

json.need do
  json.partial! 'basic_info', need: need
end

json.links do
  json.need_responses need_responses_url(need, format: :json)
end
