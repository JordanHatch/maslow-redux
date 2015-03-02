class Organisation < ActiveRecord::Base
  validates :name, presence: true

  def name_with_abbreviation_and_status
    if abbreviation.present? && abbreviation != name
      # Use square brackets around the abbreviation
      # as Chosen doesn't like matching with
      # parentheses at the start of a word
      "#{name} [#{abbreviation}]"
    else
      "#{name}"
    end
  end
end
