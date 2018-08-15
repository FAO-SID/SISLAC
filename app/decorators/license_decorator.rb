class LicenseDecorator < ApplicationDecorator
  def full_name
    "#{source.name} (#{source.acronym})"
  end
end
