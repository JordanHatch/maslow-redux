class NeedEvidenceForm < Rectify::Form
  class EvidenceItemForm < Rectify::Form
    mimic :evidence_item

    attribute :value, String
    attribute :evidence_type_id, Integer

    validate :validate_value_format

    def evidence_type
      @evidence_type ||= EvidenceType.find(evidence_type_id)
    end

    def quantitative?
      evidence_type.quantitative?
    end

    def validate_value_format
      if quantitative? && value.present?
        errors.add(:value, 'must be a number') unless self.value =~ /\A\d+\Z/
      end
    end
  end

  mimic :need
  attribute :evidence_items, Array[EvidenceItemForm]

  def map_model(model)
    EvidenceType.all.each do |type|
      unless model.evidence_items.find_by(evidence_type_id: type.id)
        evidence_items << model.evidence_items.build(evidence_type_id: type.id)
      end
    end
  end

  def evidence_items_attributes=(attributes)
    self.evidence_items = attributes.map {|_, item|
      EvidenceItemForm.from_params(item)
    }
  end

  def valid?
    super &&
      self.evidence_items.reject(&:valid?).empty?
  end
end
