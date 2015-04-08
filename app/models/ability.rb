class Ability
  include CanCan::Ability

  def initialize(user)
    can [ :read, :index ], Need

    if user.viewer?
      can [ :index, :create ], :bookmark
    end

    if user.admin?
      can [ :create, :update, :close, :reopen ], Need
    end

    can :validate, Need if user.admin?
  end
end
