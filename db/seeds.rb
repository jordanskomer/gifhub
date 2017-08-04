puts "| ---   Prepopulating Gifs"

GIFS = [
  {
    keyword: "",
    gif: "http://i.giphy.com/3og0IuECgoRILJUAfu.gif",
    perform_on: :squerge,
    when: :on_merge,
  },
  {
    keyword: "",
    gif: "https://media.giphy.com/media/3o7btP3U51GnFkj4f6/giphy.gif",
    perform_on: :merge,
    when: :on_merge,
  },
  {
    keyword: "i'll allow it",
    gif: "https://media.giphy.com/media/YKypDIKxXXfDq/giphy.gif",
    perform_on: :comment,
    when: :instant,
  },
  {
    keyword: "changelog",
    gif: "https://media.giphy.com/media/V48T5oWs3agg0/giphy.gif",
    perform_on: :file_name,
    when: :instant,
  },
  {
    keyword: "release",
    gif: "https://media.giphy.com/media/E3cQDsj7pUpwI/giphy.gif",
    perform_on: :branch,
    when: :on_merge,
  },
].freeze

GIFS.each do |gif|
  Gif.create(
    keyword: gif[:keyword],
    gif: gif[:gif],
    perform_on: gif[:perform_on],
    when: gif[:when],
  )
  puts "|       Created Gif"
end
