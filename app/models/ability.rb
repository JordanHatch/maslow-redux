class Ability
  include CanCan::Ability

  def initialize(user)
    can [ :read, :index ], Need
    can [ :index, :create ], :bookmark
    can :index, ActivityItem

    if user.commenter? || user.admin?
      can :create, :note
    end

    if user.admin?
      can :create, Decision
      can [ :create, :update, :close, :reopen ], Need
      can :manage, :settings
    end

    can :validate, Need if user.admin?
  end
end
