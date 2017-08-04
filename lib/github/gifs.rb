module Github
  class Gifs
    # initialize
    # ------------------------------------------
    # Sanitize comment for gif matching
    # Called from Github::Client
    #
    # == Arguments
    # comment - String - The comment retrieved from the Github payload
    def initialize(comment)
      @comment = comment.downcase
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
    # Returns a gif object if it matches the comment
    #
    # == Arguments
    # objects - Object - The DB query of gifs
    def find_gif(objects)
      objects.detect { |object| match?(object.keyword) }
    end

    # match?
    # ------------------------------------------
    # Returns true if the keywords matches the @comment
    # Note: Both strings have been sanitized for case insensitivity
    def match?(keyword)
      @comment.include? keyword.downcase
    end
  end
end
