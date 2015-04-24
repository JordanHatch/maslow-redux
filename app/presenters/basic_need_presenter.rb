class BasicNeedPresenter
  def initialize(need)
    @need = need
  end

  def as_json
    {
      id: @need.need_id,
      role: @need.role,
      goal: @need.goal,
      benefit: @need.benefit,
      met_when: @need.met_when
    }
  end
end
