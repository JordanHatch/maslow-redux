class Ability
  include CanCan::Ability

  def initialize(user)
    can [ :read, :index, :see_revisions_of ], Need

    if user.viewer?
      can [ :index, :create ], :bookmark
    end

    if user.editor?
      can [ :create, :update, :close, :reopen, :perform_actions_on ], Need
    end

    can :validate, Need if user.admin?
  end
end
