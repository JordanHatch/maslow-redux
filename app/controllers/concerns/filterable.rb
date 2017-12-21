module Concerns
  module Filterable
    extend ActiveSupport::Concern

    class Filter < Struct.new(:key, :label, :type, :values); end
    class Value < Struct.new(:key, :label); end

    included do
      helper_method :active_filters, :available_filters
    end

    def active_filters
      tag_filters.group_by(&:tag_type_identifier)
    end

    def available_filters
      available_tag_filters +
        available_metadata_filters
    end

  private
    def available_tag_filters
      filterable_tag_types.map {|tag_type|
        tags = tag_type.tags.map {|tag|
          Value.new(tag.id, tag.name)
        }
        Filter.new(tag_type.identifier, tag_type.name, :select, tags)
      }
    end

    def available_metadata_filters
      [
        Filter.new(:show_closed, I18n.t('filters.show_closed.label'), :checkbox)
      ]
    end

    def filtered_needs
      scope = base_scope

      if params[:show_closed] == '1'
        scope = scope.unscope(:where)
      end

      if tag_filters.any?
        scope = scope.with_tag_id(tag_filters.map(&:id))
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
      Need.excluding_closed_needs
    end
  end
end
