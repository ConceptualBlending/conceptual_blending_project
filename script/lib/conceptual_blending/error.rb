module ConceptualBlending
  class Error < ::StandardError; end

  class ConnectionError < Error; end
  class HetsError < Error; end
  class MedusaError < Error; end
  class TimeoutError < Error; end
  class UserError < Error; end
end
