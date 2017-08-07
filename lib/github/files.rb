module Github
  class Files
    # initialize
    # ------------------------------------------
    # Takes an array of Github Files responses
    #
    # === Arguments
    # files - Array - Github pull request files
    #
    # Example Github File Object
    # {
    #   :sha=>"a725b3fabb884eae7ef55a9fb4790c433005905d",
    #   :filename=>"lib/github/payload.rb",
    #   :status=>"modified", :additions=>4, :deletions=>0, :changes=>4,
    #   :blob_url=>"https://github.com/jordanskomer/gifhub/blob/57c404bfb403a532e23f3bac42859c6fd601a93b/
    #               lib/github/payload.rb",
    #   :raw_url=>"https://github.com/jordanskomer/gifhub/raw/57c404bfb403a532e23f3bac42859c6fd601a93b/
    #               lib/github/payload.rb",
    #   :contents_url=>"https://api.github.com/repos/jordanskomer/gifhub/contents/lib/github/
    #                   payload.rb?ref=57c404bfb403a532e23f3bac42859c6fd601a93b",
    #   :patch=>"@@ -92,6 +92,10 @@ def base_branch\n       payload[\"pull_request\"][\"base\"][\"ref\"]\n
    #            end\n \n+    def files\n+\n+    end\n+\n     def action\n       payload[\"action\"]\n     end"
    # }
    def initialize(files)
      @files = files
    end

    # method_missing
    # ------------------------------------------
    # Override the method missing to dynamically create methods
    # that parse the files array for the method name
    def method_missing(meth, *args, &block)
      retrieve(meth.to_s)
    end

    private

    # retrieve
    # ------------------------------------------
    # Returns an array of the attributes taken from the file objects
    #
    # === Arguments
    # attribute - string - the name of the attribute to retrieve from the files Github object
    def retrieve(attribute)
      attributes = []
      @files.each do |file|
        attributes.push(file[attribute.to_s]) if file[attribute.to_s].present?
      end
      attributes
    end
  end
end
