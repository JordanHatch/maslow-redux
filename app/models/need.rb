class Need
  include Mongoid::Document

  INITIAL_NEED_ID = 1

  field :need_id, type: Integer
  field :role, type: String
  field :goal, type: String
  field :benefit, type: String
  field :organisation_ids, type: Array, default: []
  field :met_when, type: Array
  field :yearly_user_contacts, type: Integer
  field :yearly_site_views, type: Integer
  field :yearly_need_views, type: Integer
  field :yearly_searches, type: Integer
  field :other_evidence, type: String
  field :legislation, type: String
  field :applies_to_all_organisations, type: Boolean, default: false
  field :duplicate_of, type: Integer, default: nil

  has_and_belongs_to_many :organisations
  has_many :revisions, class_name: "NeedRevision"
  embeds_one :status, class_name: "NeedStatus", inverse_of: :need, cascade_callbacks: true

  before_save :assign_new_id, on: :create
  before_validation :default_status_to_proposed
  before_validation :remove_blank_met_when_criteria

  default_scope ->{ order_by([:_id, :desc]) }

  validates :role, :goal, :benefit, :status, presence: true
  validates_associated :status

  validates :yearly_user_contacts, :yearly_site_views, :yearly_need_views, :yearly_searches,
            numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 0 }

  def self.by_ids(ids)
    Need.in(need_id: ids)
  end

  def self.find_by_need_id(id)
    self.where(need_id: id).first
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

private
  def record_revision(action, user = nil)
    revisions.create(
      action_type: action,
      snapshot: attributes,
      author: user
    )
  end

  def assign_new_id
    last_assigned = Need.order_by([:need_id, :desc]).first
    self.need_id ||= (last_assigned.present? && last_assigned.need_id >= INITIAL_NEED_ID) ? last_assigned.need_id + 1 : INITIAL_NEED_ID
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
