# frozen_string_literal: true

module ApiExceptions
  class BaseExceptions < StandardError; end

  class CommonError < BaseExceptions; end
  class UserNotFound < BaseExceptions; end
  class ShopNotFound < BaseExceptions; end
  class ItemsNotFound < BaseExceptions; end
  class ItemNotFound < BaseExceptions; end
  class NotEnoughMoney < BaseExceptions; end
  class BuyerDoesNotHaveEnoughMoney < BaseExceptions; end
  class NotEnoughItems < BaseExceptions; end
  class ItemAlreadyBought < BaseExceptions; end
  class SellerNotFound < BaseExceptions; end
  class InventoryNotFound < BaseExceptions; end
  class ActiveTradesDoNotExist < BaseExceptions; end
  class PassiveTradesDoNotExist < BaseExceptions; end
  class TradeNotFound < BaseExceptions; end
  class TradeCanNotBeCanceled < BaseExceptions; end
  class TradeCanNotBeDeclined < BaseExceptions; end
  class TradeCanNotBeAccepted < BaseExceptions; end
end
