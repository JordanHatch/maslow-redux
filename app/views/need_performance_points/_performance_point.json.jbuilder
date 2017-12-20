json.id performance_point_need_response_url(need,
                                            need_response,
                                            performance_point.metric_type,
                                            performance_point.date,
                                            format: :json)
json.metric_type performance_point.metric_type
json.date performance_point.date
json.value performance_point.value
json.updated_at performance_point.updated_at
