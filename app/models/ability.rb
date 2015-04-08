class Ability
  include CanCan::Ability

  def initialize(user)
    can [ :read, :index ], Need
    can [ :index, :create ], :bookmark

    if user.viewer?
    end

    if user.admin?
      can :create, Decision
      can [ :create, :update, :close, :reopen ], Need
    end

    can :validate, Need if user.admin?
  end
end
