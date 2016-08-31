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
      |> Enum.map(&song_parse/1)
   end

   def song_parse(song) do
      [_ | tail] = List.flatten(Regex.scan(~r/(.+)–(.+)via/, song))
      [artist | title] = tail
      song = %{artist: String.trim(artist), title: String.trim(List.first(title))}
      Map.put(song, :gp_link, google_play_link(song))
   end

   def google_play_link(song) do
      title = Regex.replace(~r/\s/, song.title, "+")
      artist = Regex.replace(~r/\s/, song.artist, "+")
      "https://play.google.com/music/listen?u=0#/sr/#{title}+#{artist}" 
   end
end
