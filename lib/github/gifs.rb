module Github
  class Gifs
    # initialize
    # ------------------------------------------
    # Sanitize keyword for gif matching
    # Called from Github::Client
    #
    # == Arguments
    # keyword - String - The keyword retrieved from the Github payload
    def initialize(keywords)
      @keywords = keywords
    end

    # method_missing
    # ------------------------------------------
    # Override the method missing to dynamically create methods
    # that correspond to the github_types and activation methods in the DB
    def method_missing(meth, *args, &block)
      args = meth.to_s.split("_", 2)
      find_gif(Gif.where(github_type: args[0], activate: args[1]))
    end

    private

    # find_gif
    # ------------------------------------------
    # Returns a gif object if it matches the keyword
    #
    # == Arguments
    # objects - Object - The DB query of gifs
    def find_gif(objects)
      objects.detect { |object| match?(object.keyword) }
    end

    # match?
    # ------------------------------------------
    # Returns true if the keywords matches the @keyword
    # Note: Both strings have been sanitized for case insensitivity
    def match?(gif_keyword)
      @keywords.detect { |keyword| keyword.downcase.include? gif_keyword.downcase }
    end
  end
end
