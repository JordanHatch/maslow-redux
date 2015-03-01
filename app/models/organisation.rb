class Organisation
  include Mongoid::Document

  field :name, type: String
  field :slug, type: String
  field :govuk_status, type: String, default: ""
  field :abbreviation, type: String, default: ""
  field :parent_ids, type: Array, default: []
  field :child_ids, type: Array, default: []

  def name_with_abbreviation_and_status
    if abbreviation.present? && abbreviation != name
      # Use square brackets around the abbreviation
      # as Chosen doesn't like matching with
      # parentheses at the start of a word
      "#{name} [#{abbreviation}] (#{status})"
    else
      "#{name} (#{status})"
    end
  end
end
