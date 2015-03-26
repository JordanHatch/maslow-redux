class Need < ActiveRecord::Base
  has_many :revisions, class_name: "NeedRevision"

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :tag_types, through: :tags

  has_many :decisions
  has_many :activity_items

  belongs_to :canonical_need, class_name: 'Need'

  before_validation :remove_blank_met_when_criteria

  default_scope ->{ order('id desc') }
  scope :with_tag_id, -> (tag_id) {
    joins(:taggings).where("taggings.tag_id" => tag_id)
  }

  validates :role, :goal, :benefit, presence: true

  validates :yearly_user_contacts, :yearly_site_views, :yearly_need_views, :yearly_searches,
            numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 0 }
  validates :canonical_need, presence: true, if: -> { canonical_need_id.present? }

  def need_id
    id
  end

  def self.by_ids(ids)
    Need.where(id: ids)
  end

  def self.find_by_need_id(id)
    self.find(id)
  end

  def save_as(user)
    action = persisted? ? 'update' : 'create'

    # This uses ActiveModel::Dirty's `changes` method to return a list of
    # changed attributes, along with their previous/next values, before saving.
    #
    # We have to assign it before we save, because it gets cleared once a record
    # is saved.
    #
    changed_attributes = changes

    save && record_revision(action, user, changed_attributes)
  end

  def reopen_as(author)
    self.canonical_need = nil
    save_as(author)
  end

  def per_page
    50
  end

  def to_param
    need_id.to_s
  end

  def changesets
    (revisions + [nil]).each_cons(2).map {|revision, previous|
      notes = Note.where(revision: revision.id)
      Changeset.new(revision, previous, notes)
    }
  end

  def latest_decision(decision_type)
    decisions.latest(decision_type)
  end

  def add_more_criteria
    met_when << ""
  end

  def remove_criteria(index)
    met_when.delete_at(index)
  end

  def duplicate?
    canonical_need.present?
  end

  def closed?
    duplicate?
  end

  def joined_tag_types
    tag_types.includes(:tags).distinct(:id)
  end

  def tags_of_type(tag_type_id)
    tags.of_type(tag_type_id)
  end

  def tag_ids_of_type(tag_type_id)
    tags_of_type(tag_type_id).map(&:id)
  end

  def set_tags_of_type(tag_type, tags)
    set_tag_ids_of_type(tag_type, tags.map(&:id))
  end

  def set_tag_ids_of_type(tag_type, new_tag_ids)
    existing_tag_ids = tag_ids_of_type(tag_type)
    updated_tag_ids = tag_ids - existing_tag_ids + new_tag_ids

    self.tag_ids = updated_tag_ids
  end

private
  def method_missing(method, *args, &block)
    if (m = method.to_s.match(/^tag_ids_of_type_(\d+)$/))
      return self.send(:tag_ids_of_type, m[1])
    elsif (m = method.to_s.match(/^tag_ids_of_type_(\d+)=$/))
      return self.send(:set_tag_ids_of_type, m[1], *args)
    end

    super(method, *args, &block)
  end

  def record_revision(action, user, changes)
    activity_items.create(
      item_type: action,
      user: user,
      data: {
        changes: filtered_changes(changes),
        snapshot: attributes,
      }
    )
  end

  def filtered_changes(changes)
    changes.tap {|changes|
      met_when = changes['met_when']

      if met_when.present? &&
          met_when.first.empty? &&
          met_when.last.reject(&:blank?).empty?
        changes.delete('met_when')
      end
    }
  end

  def remove_blank_met_when_criteria
    if met_when
      met_when.delete_if(&:empty?)
    end
  end
end
