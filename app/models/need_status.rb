require "ostruct"
require "active_model"

class NeedStatus
  include Mongoid::Document

  embedded_in :need

  field :description, type: String
  field :reasons, type: Array
  field :additional_comments, type: String
  field :validation_conditions, type: String


  COMMON_REASONS_WHY_INVALID = [
    "it has typos or acronyms that aren’t defined",
    "it’s incomplete or imprecise",
    "it contains sensitive or politically controversial information",
    "it’s an organisational need or isn’t properly defined as a user need",
    "it’s an acceptance criterion of another need",
    "it’s not in proposition",
  ]

  PROPOSED = "proposed"
  NOT_VALID = "not valid"
  VALID = "valid"
  VALID_WITH_CONDITIONS = "valid with conditions"

  validates :description, presence: true, inclusion: { in: [PROPOSED, NOT_VALID, VALID, VALID_WITH_CONDITIONS] }

  validates :reasons, presence: true, if: Proc.new { |s| s.description == NOT_VALID }
  validates :validation_conditions, presence: true, if: Proc.new { |s| s.description == VALID_WITH_CONDITIONS }

  before_validation :clear_inconsistent_fields

  # attr_reader :description, :reasons, :additional_comments, :validation_conditions
  #
  # validates :description, inclusion: { in: [PROPOSED, NOT_VALID, VALID, VALID_WITH_CONDITIONS] },
  #           presence: { message: "You need to select the new status" }
  #
  # validates :reasons, if: Proc.new { |s| s.description == NOT_VALID },
  #           presence: { message: "A reason is required to mark a need as not valid" }
  # validates :validation_conditions, if: Proc.new { |s| s.description == VALID_WITH_CONDITIONS },
  #           presence: { message: "The validation conditions are required to mark a need as valid with conditions" }

  # def initialize(options)
  #   options = OpenStruct.new(options) if options.is_a?(Hash)
  #
  #   @description = options.description
  #   @reasons = options.reasons
  #   @additional_comments = options.additional_comments
  #   @validation_conditions = options.validation_conditions
  # end

  def common_reasons_why_invalid
    @reasons & COMMON_REASONS_WHY_INVALID
  end

  def other_reasons_why_invalid
    ((@reasons || []) - COMMON_REASONS_WHY_INVALID).first
  end

  def as_json
    additional_attributes = case description
                            when VALID then
                              if additional_comments.present?
                                { additional_comments: additional_comments }
                              else
                                {}
                              end
                            when NOT_VALID then
                              { reasons: reasons }
                            when VALID_WITH_CONDITIONS then
                              { validation_conditions: validation_conditions }
                            else
                              {}
                            end
    { description: description }.merge(additional_attributes)
  end
private
  def clear_inconsistent_fields
    if description != NOT_VALID && reasons != nil
      self.reasons = nil
    end

    if description != VALID && additional_comments != nil
      self.additional_comments = nil
    end

    if description != VALID_WITH_CONDITIONS && validation_conditions != nil
      self.validation_conditions = nil
    end
  end
end
