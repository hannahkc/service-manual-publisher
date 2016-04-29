class GuideForm
  DEFAULT_UPDATE_TYPE = "major"
  DEFAULT_SLUG = "/service-manual/"

  include ActiveModel::Model

  attr_reader :guide, :edition, :user
  attr_accessor :author_id, :body, :change_note, :change_summary, :content_owner_id, :description, :slug,
    :summary, :title, :type, :update_type, :version

  delegate :persisted?, to: :guide

  def initialize(guide:, edition:, user:)
    @guide = guide
    @edition = edition
    @user = user

    self.author_id = next_author_id
    self.body = edition.body
    self.change_note = edition.change_note
    self.change_summary = edition.change_summary
    self.content_owner_id = edition.content_owner_id
    self.description = edition.description
    self.slug = guide.slug || DEFAULT_SLUG
    self.summary = edition.summary
    self.title = edition.title
    self.type = guide.type
    self.update_type = next_update_type
    self.version = next_edition_version

    if edition.published?
      self.change_note = nil
      self.change_summary = nil
    end
  end

  def save
    guide.slug = slug
    edition.author_id = author_id
    edition.body = body
    edition.content_owner_id = content_owner_id
    edition.description = description
    edition.state = Edition::STATES.first
    edition.summary = summary
    edition.title = title
    edition.update_type = update_type
    edition.version = version

    if guide.save
      true
    else
      promote_errors_for(guide)
      promote_errors_for(edition)

      false
    end
  end

  def to_param
    guide.id.to_s
  end

  def model_name
    ActiveModel::Name.new(Guide)
  end

  def assign_attributes(attributes)
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

private

  def next_edition_version
    if edition.published?
      edition.version + 1
    else
      edition.version || 1
    end
  end

  def next_update_type
    if edition.published?
      DEFAULT_UPDATE_TYPE
    else
      edition.update_type || DEFAULT_UPDATE_TYPE
    end
  end

  def next_author_id
    if edition.published?
      user.id
    else
      edition.author ? edition.author.id : user.id
    end
  end

  def promote_errors_for(model)
    model.errors.each do |attrib, message|
      errors.add(attrib, message)
    end
  end
end
