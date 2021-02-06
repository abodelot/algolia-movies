require './app/services/data_importer'

namespace :data do
  task import: :environment do
    DataImporter.new.run!('records.json')
  end
end
