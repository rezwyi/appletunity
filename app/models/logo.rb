class Logo < ActiveRecord::Base
  class FingerprintError < AppSpecificError; end

  MINIMAL_DIMENSION = 150
  
  has_many :logoables, dependent: :destroy
  has_attached_file :image, styles: {small: '80x80>', normal: '150x150>'}

  validates_attachment :image, presence: true,
    content_type: {content_type: %w(image/jpeg image/jpg image/png)},
    size: {in: 0..10.megabytes}

  validate :check_image_fingerprint!
  validate :check_image_dimensions, unless: -> { force? || errors.any? }

  protected

  def check_image_fingerprint!
    return unless image_fingerprint
    if (duplicate = Logo.find_by_image_fingerprint(image_fingerprint))
      raise FingerprintError.new('Already exists', duplicate) unless duplicate.force?
    end
  end

  def check_image_dimensions
    dimensions = Paperclip::Geometry.from_file(image.queued_for_write[:original].path)
    if dimensions.width < MINIMAL_DIMENSION || dimensions.height < MINIMAL_DIMENSION
      errors.add :image, I18n.t('dimensions', scope: 'activerecord.errors.models.logo.attributes.image')
    end
  end
end