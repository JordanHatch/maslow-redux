require "active_model"

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

  embeds_one :status, class_name: "NeedStatus", inverse_of: :need, cascade_callbacks: true
  validates :status, presence: true
  validates_associated :status

  before_save :assign_new_id, on: :create

  has_and_belongs_to_many :organisations
  has_many :revisions, class_name: "NeedRevision"

  # before_validation :default_booleans_to_false
  before_validation :default_status_to_proposed
  default_scope order_by([:_id, :desc])

  def per_page
    50
  end

  def to_param
    need_id
  end

  def changesets
    (revisions + [nil]).each_cons(2).map {|revision, previous|
      notes = Note.where(revision: revision.id)
      Changeset.new(revision, previous, notes)
    }
  end

  NUMERIC_FIELDS = ["yearly_user_contacts", "yearly_site_views", "yearly_need_views", "yearly_searches"]

  validates :role, :goal, :benefit, presence: true
  NUMERIC_FIELDS.each do |field|
    validates_numericality_of field, :only_integer => true, :allow_blank => true, :greater_than_or_equal_to => 0
  end

  def self.by_ids(ids)
    Need.in(need_id: ids)
  end

  def self.find_by_need_id(id)
    self.where(need_id: id).first
  end

  def record_revision(action, user = nil)
    rev = revisions.build(
      action_type: action,
      snapshot: attributes,
      author: user
    )
    puts rev.inspect
    rev.save!
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

  def artefacts
    []
  end

  def save_as(user)
    action = persisted? ? 'update' : 'create'
    save && reload && record_revision(action, user)
  end

  def reopen_as(author)
    self.duplicate_of = nil
    save_as(author)
  end

  def has_invalid_status?
    status.description == "not valid"
  end

private
  def assign_new_id
    last_assigned = Need.order_by([:need_id, :desc]).first
    self.need_id ||= (last_assigned.present? && last_assigned.need_id >= INITIAL_NEED_ID) ? last_assigned.need_id + 1 : INITIAL_NEED_ID
  end

  def default_status_to_proposed
    self.status ||= NeedStatus.new(description: NeedStatus::PROPOSED)
  end

  def author_atts(author)
    {
      "name" => author.name,
      "email" => author.email,
      "uid" => author.uid
    }
  end

  def remove_blank_met_when_criteria
    if met_when
      met_when.delete_if(&:empty?)
    end
  end

  def strip_newline_from_textareas(attrs)
    # Rails prepends a newline character into the textarea fields in the form.
    # Strip these so that we don't send them to the Need API.
    ["legislation", "other_evidence"].each do |field|
      attrs[field].sub!(/\A\n/, "") if attrs[field].present?
    end
  end
end
