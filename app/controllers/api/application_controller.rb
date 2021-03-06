module Api
  class ApplicationController < ::ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :underscore_params!

    private

    def underscore_params!
      params.deep_transform_keys!(&:underscore)
    end
  end
end
