# Parse WoSIS database from the official dump
require 'wosis/sources/csv_source'
require 'wosis/transformations/filter_by_country'
require 'wosis/transformations/filter_by_profile'
require 'wosis/transformations/find_or_create_profile'
require 'wosis/transformations/find_or_create_layer'

# AN/ANT is deprecated, so it's not recognizable by 'countries' gem. We have to
# treat it as an exception until we develop something for obsolete data.
#
# See https://github.com/FAO-GSP/SISLAC/issues/3
LAC = %w{
  ABW AIA ARG ATG BES BHS BLM BLZ BMU BOL BRA BRB CHL COL CRI CUB CUW CYM DMA
  DOM ECU FLK GLP GRD GTM GUF GUY HND HTI JAM KNA LCA MAF MEX MSR MTQ NIC PAN
  PER PRI PRY SGS SLV SUR SXM TCA TTO UMI URY VCT VEN VGB VIR XCL
  ANT
}

class Wosis
  attr_reader :file_prefix

  def initialize(file_prefix:)
    raise ArgumentError if file_prefix.empty?

    @file_prefix = file_prefix
  end

  def import!
    import_profiles! profiles_file_name
    import_layers! layers_file_name
  end

  def import_profiles!(file)
    job = Kiba.parse do
      source CsvSource, file

      transform FilterByCountry, iso_codes: LAC
      transform FindOrCreateProfile, release_date: Date.new(2016, 07)
    end

    Kiba.run(job)
  end

  def import_layers!(file)
    job = Kiba.parse do
      source CsvSource, file

      transform FilterByProfile
      transform FindOrCreateLayer
    end

    Kiba.run(job)
  end

  def profiles_file_name
    "#{file_prefix}_profiles.txt"
  end

  def layers_file_name
    "#{file_prefix}_layers.txt"
  end
end
