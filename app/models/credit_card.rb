class CreditCard
  # include ActiveModel::Validations

  # attr_reader :spreedly_card, :how_many
  # delegate :first_name, :last_name, :full_name, :number, :verification_value, :month, :year, to: :spreedly_card, allow_nil: true

  # validates_numericality_of :how_many, only_integer: true
  # validate :incorporate_errors_from_spreedly
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :number, presence: true
  # validates :month, presence: true
  # validates :year, presence: true
  # validates :verification_value, presence: true
  # validates :how_many, presence: true
  
  # def initialize(spreedly_card = nil)
  #   @spreedly_card = spreedly_card
  #   initialize_how_many
  # end

  # private
  # def initialize_how_many
  #   return unless @spreedly_card

  #   @spreedly_card.data.match(/<how_many>(.*)<\/how_many>/) do |match|
  #     @how_many = match[1]
  #   end
  # end

  # def incorporate_errors_from_spreedly
  #   @spreedly_card.errors.each do |error|
  #     errors.add(error[:attribute], I18n.t(error[:key]))
  #   end
  # end
end
