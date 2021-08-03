require_dependency Rails.root.join('app', 'models', 'budget').to_s

class Budget
  CURRENCY_SYMBOLS = %w[€ $ £ RON].freeze
end
