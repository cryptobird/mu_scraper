defmodule MuScraper do
   @rss "http://mysteriousuniverse.org/feed/podcast"

   def retrieve do
      response = HTTPoison.get! @rss
      response.body
      |> Floki.parse
      |> Floki.find("item")
      |> List.first
      |> Floki.find("content:encoded")
      |> List.first
      |> Floki.text
      |> Floki.parse
      |> Floki.find("h3 + ul")
      |> List.last
      |> Floki.find("a")
      |> Enum.map(&Floki.text/1)
      |> Enum.each(&IO.puts/1)
   end
end
