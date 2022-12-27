# frozen_string_literal: true

module ApiExceptions
  class CommonError < StandardError; end
  class UserNotFound < StandardError; end
  class ShopNotFound < StandardError; end
  class ItemsNotFound < StandardError; end
  class ItemNotFound < StandardError; end
  class NotEnoughMoney < StandardError; end
  class NotEnoughItems < StandardError; end
  class ItemAlreadyBought < StandardError; end
  class SellerNotFound < StandardError; end
  class InventoryNotFound < StandardError; end
  class ActiveTradesDoNotExist < StandardError; end
  class PassiveTradesDoNotExist < StandardError; end
  class TradeNotFound < StandardError; end
  class TradeCanNotBeCanceled < StandardError; end
  class TradeCanNotBeDeclined < StandardError; end
end
