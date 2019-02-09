module Concerns
  module Followable
    extend ActiveSupport::Concern

    included do
      has_many :follows, as: :followable
      has_many :teams, through: :follows
    end

    def follow(team)
      follows.find_or_initialize_by(team: team).save
    end

    def unfollow(team)
      follows.where(team: team).destroy_all
    end

    def followed_by?(team)
      follows.where(team: team).any?
    end
  end
end
