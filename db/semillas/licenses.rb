# Possible licenses for Profile data
# Id is set because these are lookup tables, mostly static data
licenses = [
  { 
    id: 1,
    name: 'Public Domain Dedication and License',
    acronym: 'PDDL',
    url: 'https://opendatacommons.org/licenses/pddl',
    statement: 'This profile data is made available under the Public Domain ' \
      'Dedication and License v1.0 whose full text can be found at: '\
      'http://www.opendatacommons.org/licenses/pddl/1.0/.'
  },
  { 
    id: 2,
    name: 'Attribution License',
    acronym: 'ODC-By',
    url: 'https://opendatacommons.org/licenses/by',
    statement: 'This profile data is made available under the Open Data Commons ' \
      'Attribution License: http://opendatacommons.org/licenses/by/1.0/.'
  },
  { 
    id: 3,
    name: 'Open Database License',
    acronym: 'ODC-ODbL',
    url: 'https://opendatacommons.org/licenses/odbl',
    statement: 'This profile data is made available under the Open Database ' \
      'License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in ' \
      'individual contents of the database are licensed under the Database ' \
      'Contents License: http://opendatacommons.org/licenses/dbcl/1.0/'
  }
]

licenses.each do |license|
  # If any value was changed by application users, do not touch it
  unless License.exists?(license[:id])
    License.find_or_create_by(license).update_column(:id, license[:id])
  end
end
