require './SeedStock'
require './Gene'
require './HybridCross'

class FileMaster

    def FileMaster.load_from_file(filename, my_class)

        """
        Class method to retrieve all lines of a specific file as instances of a given class. 
        Returns an array with all objects.
        """

        file = File.open(filename)

        header = file.readline.downcase.split() # get first line in downcase

        object_list = [] # initialize list of objects

        file.each_with_index do |line,j| 

            records = line.chop.split("\t") # chop eliminates the residual \n at the end of the line
            
            # Create hash to identify each record with its header

            hash = {} 

            records.each_with_index do |r, i|
                hash[header[i]] = r
            end

            # Create a new class instance from hash and append it to object_list
            object_list[j] = my_class.new_from_hash(hash)

        end

        return object_list

    end
    
    def FileMaster.create_updated_file(filename, my_class)

        """
        Class method to create an updated file with all of the objects of a given class.
        """

        header = my_class.get_header

        open(filename,"w") do |f|
            f.puts header
            f.puts my_class.get_all
        end

    end

end