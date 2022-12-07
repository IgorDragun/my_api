# frozen_string_literal: true

module ApiExceptions
  class UserNotFound < StandardError; end
  class ShopNotFound < StandardError; end
  class ItemsNotFound < StandardError; end
  class ItemNotFound < StandardError; end
end
