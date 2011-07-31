module Wonkavision
  module Sample
    class Config < Hash
      include Wonkavision::MessageMapper::IndifferentAccess
    end
  end
end