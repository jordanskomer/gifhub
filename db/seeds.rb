puts "| ---   Prepopulating Gifs"

GIFS = [
  {
    keyword: "squerge",
    url: "http://i.giphy.com/3og0IuECgoRILJUAfu.gif",
    github_type: "squerge",
    activate: "on_merge",
  },
  {
    keyword: "merge",
    url: "https://media.giphy.com/media/3o7btP3U51GnFkj4f6/giphy.gif",
    github_type: "merge",
    activate: "on_merge",
  },
  {
    keyword: "i'll allow it",
    url: "https://media.giphy.com/media/YKypDIKxXXfDq/giphy.gif",
    github_type: "comment",
    activate: "instant",
  },
  {
    keyword: "changelog",
    url: "https://media.giphy.com/media/V48T5oWs3agg0/giphy.gif",
    github_type: "file_name",
    activate: "instant",
  },
  {
    keyword: "release",
    url: "https://media.giphy.com/media/E3cQDsj7pUpwI/giphy.gif",
    github_type: "branch",
    activate: "on_merge",
  },
  {
    keyword: "hotfix",
    url: "https://media.giphy.com/media/3oEduKoCblNVAgAbYI/giphy.gif",
    github_type: "branch",
    activate: "on_merge",
  },
  {
    keyword: "pushit",
    url: "https://media.giphy.com/media/xjn2lgqupGjzW/giphy.gif",
    github_type: "comment",
    activate: "instant",
  },
  {
    keyword: "readme",
    url: "https://media.giphy.com/media/WRZK60jaKkDaU/giphy.gif",
    github_type: "comment",
    activate: "instant",
  },
  {
    keyword: "conflict",
    url: "https://media.giphy.com/media/HAS2zKAMG0cWA/giphy.gif",
    github_type: "comment",
    activate: "instant",
  },
  {
    keyword: "reading",
    url: "https://media.giphy.com/media/bI3cX9brTVLfq/giphy.gif",
    github_type: "comment",
    activate: "instant",
  },

].freeze

GIFS.each do |gif|
  Gif.create(
    keyword: gif[:keyword],
    url: gif[:url],
    github_type: gif[:github_type],
    activate: gif[:activate],
  )
  puts "|       Created Gif"
end
