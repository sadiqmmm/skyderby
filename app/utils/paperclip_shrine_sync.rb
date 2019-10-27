module PaperclipShrineSync
  def self.included(model)
    model.before_save do
      Paperclip::AttachmentRegistry.each_definition do |klass, name, _options|
        write_shrine_data(name) if changes.key?(:"#{name}_file_name") && klass == self.class
      end
    end
  end

  def write_shrine_data(name)
    attachment = send(name)
    attacher   = Shrine::Attacher.from_model(self, name)

    if attachment.size.present?
      attacher.set shrine_file(attachment)

      attachment.styles.each do |derivative_name, style|
        attacher.merge_derivatives(derivative_name => shrine_file(style))
      end
    else
      attacher.set nil
    end
  end

  private

  def shrine_file(object)
    if object.is_a?(Paperclip::Attachment)
      shrine_attachment_file(object)
    else
      shrine_style_file(object)
    end
  end

  # If you'll be using a `:prefix` on your Shrine storage, or you're storing
  # files on the filesystem, make sure to subtract the appropriate part
  # from the path assigned to `:id`.
  def shrine_attachment_file(attachment)
    Shrine.uploaded_file(
      storage: :cache,
      id: attachment.path,
      metadata: {
        'size' => attachment.size,
        'filename' => attachment.original_filename,
        'mime_type' => attachment.content_type
      }
    )
  end

  # If you'll be using a `:prefix` on your Shrine storage, or you're storing
  # files on the filesystem, make sure to subtract the appropriate part
  # from the path assigned to `:id`.
  def style_to_shrine_data(style)
    Shrine.uploaded_file(
      storage: :cache,
      id: style.attachment.path(style.name),
      metadata: {}
    )
  end
end
