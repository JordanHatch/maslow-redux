module Concerns
  module Filterable
    extend ActiveSupport::Concern

    included do
      helper_method :active_filters, :available_filters
    end
    
    def active_filters
      tag_filters.group_by(&:tag_type_identifier)
    end

    def available_filters
      tuples = filterable_tag_types.map {|tag_type|
        [tag_type, tag_type.tags]
      }
      Hash[tuples]
    end

  private
    def filtered_needs
      # Iterate over each tag we wish to filter by, narrowing the scope for
      # each tag.
      #
      scope = base_scope
      tag_filters.each do |tag|
        scope = base_scope.with_tag_id(tag)
      end
      scope
    end

    def filterable_tag_types
      TagType.all
    end

    def tag_filters
      # Iterate over each tag type. For each tag type, check if there is a
      # matching parameter set. If so, look up the tag ID or return nil.
      #
      # We then `compact` the array so that only matching tags are returned.
      #
      filterable_tag_types.map {|tag_type|
        collection = tag_type.tags
        collection.where(id: params[tag_type.identifier]).first
      }.compact
    end

    def base_scope
      Need
    end
  end
end
