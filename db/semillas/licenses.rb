# Possible licenses for Profile data
# Id is set because these are lookup tables, mostly static data
licenses = [
  {
    id: 1,
    name: 'Public Domain Dedication and License',
    acronym: 'PDDL',
    url: 'https://opendatacommons.org/licenses/pddl',
    statement: 'This profile data is made available under the Public Domain ' \
      'Dedication and License v1.0 whose full text can be found at: ' \
      '<a rel="license" href="http://www.opendatacommons.org/licenses/pddl/1.0/">' \
        'http://www.opendatacommons.org/licenses/pddl/1.0/' \
      '</a>.'
  },
  {
    id: 2,
    name: 'Attribution License',
    acronym: 'ODC-By',
    url: 'https://opendatacommons.org/licenses/by',
    statement: 'This profile data is made available under the Open Data Commons ' \
      'Attribution License: ' \
      '<a rel="license" href="http://opendatacommons.org/licenses/by/1.0/">' \
        'http://opendatacommons.org/licenses/by/1.0/' \
      '</a>.'
  },
  {
    id: 3,
    name: 'Open Database License',
    acronym: 'ODC-ODbL',
    url: 'https://opendatacommons.org/licenses/odbl',
    statement: 'This SiSLAC database is made available under the Open Database License: ' \
      '<a rel="license" href="http://opendatacommons.org/licenses/odbl/1.0/">' \
        'http://opendatacommons.org/licenses/odbl/1.0/' \
      '</a>. ' \
      'Any rights in individual contents of the database are licensed under the Database Contents License: ' \
      '<a rel="license" href="http://opendatacommons.org/licenses/dbcl/1.0/">' \
        'http://opendatacommons.org/licenses/dbcl/1.0/' \
      '</a>.'
  },
  {
    id: 4,
    name: 'Creative Commons Attribution 4.0 International',
    acronym: 'CC-BY',
    url: 'https://creativecommons.org/licenses/by/4.0',
    statement: 'This work is licensed under a ' \
      '<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">' \
        'Creative Commons Attribution 4.0 International License' \
      '</a>.'
  },
  {
    id: 5,
    name: 'Creative Commons Attribution-NonCommercial 4.0 International',
    acronym: 'CC-BY-NC',
    url: 'https://creativecommons.org/licenses/by-nc/4.0',
    statement: 'This work is licensed under a ' \
      '<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">' \
        'Creative Commons Attribution-NonCommercial 4.0 International License' \
      '</a>.'
  },
  {
    id: 6,
    name: 'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International',
    acronym: 'CC-BY-NC-ND',
    url: 'https://creativecommons.org/licenses/by-nc-nd/4.0',
    statement: 'This work is licensed under a ' \
      '<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">' \
        'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License' \
      '</a>.'
  }
]

licenses.each do |license|
  # If any value was changed by application users, do not touch it
  unless License.exists?(license[:id])
    License.find_or_create_by(license).update_column(:id, license[:id])
  end
end
