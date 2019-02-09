class NeedCollectionPresenter

  def initialize(needs)
    @needs = needs
  end

  def as_collection
    needs.map {|need|
      [
        "##{need.id}: #{need.goal.capitalize}",
        need.id
      ]
    }
  end

private
  attr_reader :needs

end
