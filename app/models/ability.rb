class Ability
  include CanCan::Ability

  def initialize(user)
    can [ :read, :index ], Need
    can [ :index, :create ], :bookmark
    can :index, ActivityItem
    can :read, NeedPerformancePoint
    can :read, TagType
    can :read, Tag

    if user.commenter? || user.admin?
      can :create, :note
    end

    if user.bot? || user.admin?
      can :update, NeedPerformancePoint
    end

    if user.admin?
      can [ :create, :update, :destroy ], NeedResponse
      can [ :create, :update, :close, :reopen ], Need
      can :manage, :settings
    end
  end
end
