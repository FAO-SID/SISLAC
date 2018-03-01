require 'wosis/sources'
require 'wosis/transformations'

LAC = %w{
  ABW AIA ARG ATG BES BHS BLM BLZ BMU BOL BRA BRB CHL COL CRI CUB CUW CYM DMA
  DOM ECU FLK GLP GRD GTM GUF GUY HND HTI JAM KNA LCA MAF MEX MSR MTQ NIC PAN
  PER PRI PRY SGS SLV SUR SXM TCA TTO UMI URY VCT VEN VGB VIR XCL
}

class Wosis
  attr_reader :file_prefix

  def initialize(file_prefix:)
    @file_prefix = file_prefix
  end

  def import!
    import_profiles!
    # import_layers!
  end

  def import_profiles!
    job = Kiba.parse do
      source ProfilesCsvSource, 'wosis_201607_profiles.txt'
      transform FilterByCountry, iso_codes: LAC
      transform FindOrCreatePerfil
      transform PrettyPrintTransform
    end

    Kiba.run(job)
  end
end
