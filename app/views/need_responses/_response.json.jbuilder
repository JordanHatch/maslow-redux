json.id need_response_url(need_response.need, need_response, format: :json)
json.name need_response.name
json.response_type do
  json.type need_response.response_type
  json.label need_response.response_type_text
end
json.url need_response.url
json.need do
  json.id need_url(need_response.need, format: :json)
  json.need_id need_response.need.id
end
