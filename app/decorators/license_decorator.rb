class LicenseDecorator < ApplicationDecorator
  def full_name
    "#{source.name} (#{source.acronym})"
  end

  def link
    h.link_to full_name, url, target: '_blank'
  end

  def statement
    h.raw source.statement
  end
end
