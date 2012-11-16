require "sinatra/tag-helpers/version"

module Sinatra
  module TagHelpers
    # tag with no content
    def tag(tag_type, attributes = {})
      "<#{ tag_type } #{ to_attributes(attributes) }>"
    end

    def close_tag(tag_type)
      "</#{ tag_type }>"
    end

    # tag with content
    def content_tag(tag_type, tag_content, attributes = {})
      "#{ tag(tag_type, attributes) }#{ tag_content }#{ close_tag(tag_type) }"
    end

    # converts a hash into HTML style attributes
    def to_attributes(hash)
      hash.collect do |key, value|
        # for things like data: { stuff: 'hey' }
        if value.is_a? Hash
          value.collect do |k, v|
            "#{ key }-#{ k }=\"#{ v }\""
          end
        else
          value.is_a?(TrueClass) ? key.to_s : "#{ key }=\"#{ value }\""
        end
      end.join(' ').chomp
    end
  end
end
