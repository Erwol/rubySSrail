class Order < ActiveRecord::Base
  attr_accessor :card_type, :card_number, :card_expiration_month, :card_expiration_year,
                :card_verification_value

  has_many :order_items
  has_many :articles, :through => :order_items

  validates_presence_of :order_items,
                        :message => '¡Su carrito de la compra está vacío! ' +
                            'Por favor, añada al menos un artículo.'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :phone_number, :in => 7..20

  validates_length_of :ship_to_first_name, :in => 2..255
  validates_length_of :ship_to_last_name, :in => 2..255
  validates_length_of :ship_to_address, :in => 2..255
  validates_length_of :ship_to_city, :in => 2..255
  validates_length_of :ship_to_postal_code, :in => 2..255
  validates_length_of :ship_to_country_code, :in => 2..255

  validates_length_of :customer_ip, :in => 7..15
  validates_inclusion_of :status, :in => %w(abierto procesado cerrado fallido)

  validates_inclusion_of :card_type, :in => ['Visa', 'MasterCard', 'American Express', 'Discover'], :on => :create
  validates_length_of :card_number, :in => 13..19, :on => :create
  validates_inclusion_of :card_expiration_month, :in => %w(1 2 3 4 5 6 7 8 9 10 11 12), :on => :create
  validates_inclusion_of :card_expiration_year, :in => %w(2013 2014 2015 2016 2017 2018), :on => :create
  validates_length_of :card_verification_value, :in => 3..4, :on => :create

  def total
    sum = 0
    order_items.each do |item|
      sum += item.price * item.amount
    end
    sum
  end

  def process
    begin
      raise 'No se puede procesar un pedido que ya fue cerrado.' if self.cerrado?
      active_merchant_payment
    rescue => e
      logger.error("El pedido #{id} falló debido a una excepción: #{e}.")
      self.error_message = "Excepción elevada: #{e}"
      self.status = 'fallido'
    end
    save!
    self.procesado?
  end

  def active_merchant_payment
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::AuthorizeNetGateway.default_currency = 'USD'
    ActiveMerchant::Billing::AuthorizeNetGateway.wiredump_device = STDERR
    ActiveMerchant::Billing::AuthorizeNetGateway.wiredump_device.sync = true
    self.status = 'fallido' # order status by default

    # the card verification value is also known as CVV2, CVC2, or CID
    creditcard = ActiveMerchant::Billing::CreditCard.new(
        :brand              => card_type,
        :number             => card_number,
        :month              => card_expiration_month,
        :year               => card_expiration_year,
        :verification_value => card_verification_value,
        :first_name         => ship_to_first_name,
        :last_name          => ship_to_last_name
    )

    # buyer information
    shipping_address = {
        :first_name => ship_to_first_name,
        :last_name  => ship_to_last_name,
        :address1   => ship_to_address,
        :city       => ship_to_city,
        :zip        => ship_to_postal_code,
        :country    => ship_to_country_code,
        :phone      => phone_number,
    }

    # order information
    details = {
        :description      => 'Compra en merchuca',
        :order_id         => self.id,
        :email            => email,
        :ip               => customer_ip,
        :billing_address  => shipping_address,
        :shipping_address => shipping_address
    }

    if creditcard.valid? # validating the card automatically detects the card type
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new( # use the test account
          :login     => '9gJ75BNqb',
          :password  => '5EG234b233dwSzA9'
      # the statement ":test = 'true'" tells the gateway to not to process transactions
      )

      response = gateway.purchase(self.total, creditcard, details)

      if response.success?
        self.status = 'procesado'
      else
        self.error_message = response.message
      end
    else
      self.error_message = 'Tarjeta de crédito no válida'
    end
  end

  def procesado?
    self.status == 'procesado'
  end

  def fallido?
    self.status == 'fallido'
  end

  def cerrado?
    self.status == 'cerrado'
  end

  def cerrado
    self.status = 'cerrado'
    save!
  end
end
