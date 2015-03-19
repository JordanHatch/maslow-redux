module DecisionsHelper

  def decision_type_options
    Decision.decision_types.keys.map {|key|
      [decision_type_label(key), key]
    }
  end

  def decision_outcome_options(decision_type_key)
    Decision.decision_type_outcomes(decision_type_key).map {|outcome|
      [decision_outcome_label(decision_type_key, outcome), outcome]
    }
  end

  def decision_type_label(decision_type)
    t("decisions.types.#{decision_type}")
  end

  def decision_outcome_label(decision_type, outcome, variant = 'long')
    t("decisions.outcomes.#{decision_type}.#{outcome}.#{variant}")
  end

end
