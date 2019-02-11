class Need < ActiveRecord::Base
  include ActiveModel::AttributeMethods
  include Concerns::Followable

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :tag_types, through: :tags

  has_many :activity_items, dependent: :destroy
  has_many :evidence_items, dependent: :destroy
  has_many :need_responses, dependent: :destroy
  has_and_belongs_to_many :proposition_statements

  belongs_to :canonical_need, class_name: 'Need'

  before_validation :remove_blank_met_when_criteria

  default_scope ->{ order('id desc') }
  scope :with_tag_id, -> (tag_id) {
    tag_ids = [tag_id].flatten

    intersection = tag_ids.map {|_|
      'SELECT DISTINCT(need_id) FROM taggings WHERE tag_id = ?'
    }.join(' INTERSECT ')

    need_ids = Tagging.find_by_sql([intersection] + tag_ids).map(&:need_id)

    where(
      id: need_ids
    )
  }
  scope :excluding_closed_needs, ->{ where(canonical_need_id: nil) }

  validates :role, :goal, :benefit, presence: true
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

  def close_as(author, need_id)
    self.canonical_need_id = need_id

    save && record_revision('close', author, changed_attributes)
  end

  def reopen_as(author)
    self.canonical_need = nil

    save && record_revision('reopen', author, changed_attributes)
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

  def respond_to_missing?(method, include_private = false)
    if method.to_s.match(/^tag_ids_of_type_(\d+)$/)
      return true
    elsif method.to_s.match(/^tag_ids_of_type_(\d+)=$/)
      return true
    end

    super
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
