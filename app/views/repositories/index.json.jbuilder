json.array!(@repositories) do |repository|
  json.extract! repository, :id, :name, :url, :pulled_at
  json.url repository_url(repository, format: :json)
end
