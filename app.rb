require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  @exchange_key = ENV.fetch("EXCHANGE_RATE_KEY")

  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{@exchange_key}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)

  @currencies = @parsed_response.fetch("currencies")

  erb(:homepage)
end

get("/:first_currency") do
  @exchange_key = ENV.fetch("EXCHANGE_RATE_KEY")

  @the_symbol = params.fetch("first_currency")

  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{@exchange_key}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)

  @currencies = @parsed_response.fetch("currencies")

  erb(:first_currency)
end

get("/:first_currency/:second_currency") do
  @exchange_key = ENV.fetch("EXCHANGE_RATE_KEY")

  @first = params.fetch("first_currency")
  @second = params.fetch("second_currency")

  # Construct the URL string
  @url = "https://api.exchangerate.host/convert?from=#{@first}&to=#{@second}&amount=1&access_key=#{@exchange_key}"
  
  @raw_response = HTTP.get(@url)
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)

  @amount = @parsed_response.fetch("result")
  
  erb(:second_currency)
end
