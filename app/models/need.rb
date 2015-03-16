class Need < ActiveRecord::Base
  # has_and_belongs_to_many :organisations
  has_many :revisions, class_name: "NeedRevision"
  has_one :status, class_name: "NeedStatus"

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  before_validation :default_status_to_proposed
  before_validation :remove_blank_met_when_criteria

  default_scope ->{ order('id desc') }

  validates :role, :goal, :benefit, :status, presence: true
  # validates_associated :status

  validates :yearly_user_contacts, :yearly_site_views, :yearly_need_views, :yearly_searches,
            numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 0 }

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
    save && reload && record_revision(action, user)
  end

  def reopen_as(author)
    self.duplicate_of = nil
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

  def add_more_criteria
    met_when << ""
  end

  def remove_criteria(index)
    met_when.delete_at(index)
  end

  def duplicate?
    duplicate_of.present?
  end

  def has_invalid_status?
    status.description == "not valid"
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

  def record_revision(action, user = nil)
    revisions.create(
      action_type: action,
      snapshot: attributes,
      author: user
    )
  end

  def default_status_to_proposed
    self.status ||= NeedStatus.new(description: NeedStatus::PROPOSED)
  end

  def remove_blank_met_when_criteria
    if met_when
      met_when.delete_if(&:empty?)
    end
  end
end
