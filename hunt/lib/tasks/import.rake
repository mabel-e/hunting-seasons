require 'roo'

# To run this task, run the following:
# rake import:animals

namespace :import do
  desc "Import animals from spreadsheet"
  task animals: :environment do
    puts 'Importing Animals...'

     # Open animals spreadsheet
    data = Roo::Spreadsheet.open('lib/data/animals.xlsx')
    headers = data.row(1)
    #puts "The data headers are: #{headers}"

    # For each row in the file, create a new animal below:
    numAnimalsAdded = 0
    data.parse.each do |row|

      state = row[0].to_s.titleize
      animal = row[1].to_s.titleize
      category = row[2].to_s

      if Animal.where(name: animal, state:state, category:category).exists?
        next
      end

      if Animal.new(name: animal, state: state, category: category).save
        numAnimalsAdded+=1
      else
        puts "Failed to import animal: #{animal}, #{category}, #{state}"

      end

    end
    puts "The number of animals that were added to the database are: #{numAnimalsAdded}"
    


    num_animals = 0

    data.each_with_index do |row, index|
      next if index == 0

      if Animal.exists?(state: row[0].to_s.titleize,
        name: row[1].to_s.titleize, category: row[2].to_s)
        next
      end

      animal = Animal.new(state: row[0].to_s.titleize,
        name: row[1].to_s.titleize, category: row[2].to_s)

      if !animal.save
        puts "Fail to import animal: #{row}"
        next
      end

      num_animals += 1
    end
    
    puts "Done"
    puts "#{num_animals} animals were imported."
  end
end
