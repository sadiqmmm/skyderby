module MobileFormatOverride
  extend ActiveSupport::Concern

  included do
    before_action :set_mobile_variant

    helper_method :mobile?, :mobile_app?
  end

  def set_mobile_variant
    return unless mobile?

    request.variant = :mobile
  end

  def mobile?
    browser.device.mobile? || mobile_app? || mobile_param?
  end

  def mobile_app?
    browser.ua.start_with? 'turbolinks-view'
  end

  def mobile_param?
    params[:mobile] == '1'
  end
end
