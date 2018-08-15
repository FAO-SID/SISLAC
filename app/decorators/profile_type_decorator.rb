class ProfileTypeDecorator < ApplicationDecorator
  def to_s
    source.valor
  end
end
