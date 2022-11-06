require './SeedStock'
require './Gene'
require './HybridCross'

class FileMaster

    def FileMaster.load_from_file(filename, my_class)
        file = File.open(filename)
        # if header = true, esto puede ser una opcion que le indiques
        header = file.readline.downcase.split()

        object_list = []
        file.each_with_index do |line,j| 
            records = line.chop.split("\t") # el chop elimina el \n del final de linea

            hash = {}

            records.each_with_index do |r, i|
                hash[header[i]] = r

            end

            object_list[j] = my_class.new_from_hash(hash)

        end

        return object_list

    end

    def FileMaster.create_updated_file(filename, my_class)

        header = my_class.get_header

        open(filename,"w+") do |f|
            f.puts header
            f.puts my_class.get_all
        end

    end

end