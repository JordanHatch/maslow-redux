class NeedCriteriaForm < Rectify::Form
  class CriterionForm < Rectify::Form
    attribute :value, String
    attribute :delete, Boolean

    def deleted?
      self.delete == true
    end
  end

  mimic :need_criteria
  attribute :criteria, Array[CriterionForm]

  def map_model(model)
    self.criteria = model.met_when.map {|value|
      CriterionForm.from_params(value: value)
    }
    self.add_extra_criteria! if self.criteria.size < 1
  end

  def criteria_attributes=(attributes)
    self.criteria = attributes.map {|_, item|
      CriterionForm.from_params(item)
    }.reject(&:deleted?)
  end

  def add_extra_criteria!
    self.criteria << CriterionForm.new
  end

  def to_criteria
    self.criteria.map(&:value)
  end
end
