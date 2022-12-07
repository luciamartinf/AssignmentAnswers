require 'rest-client'
require 'json'

# == Annotation
#
# Class that collects functions to get annotations
# function to fetch annotations from the web, and functions to search for KEGG and GO annotations.
#
# == Summary
# 
# This can be used to find KEGG and GO annotations.
#
class Annotation
    
    # Class method fetch to access an URL via code, donated by Mark Wilkinson.

    #
    # Access an URL, function donated by Mark Wilkinson.
    #
    # @param [String] url URL
    # @param [String] headers headers
    # @param [String] user username, default ""
    # @param [String] pass password, default ""
    #
    # @return [String, false] the contents of the URL, or false if an exception occured
    #
    def self.fetch(url:, headers: {accept: "*/*"}, user: "", pass: "")
        response = RestClient::Request.execute({
            method: :get,
            url: url.to_s,
            user: user,
            password: pass,
            headers: headers})
        return response
        
        rescue RestClient::ExceptionWithResponse => e
            $stderr.puts e.inspect
            response = false
            return response  
        
        rescue RestClient::Exception => e
            $stderr.puts e.inspect
            response = false
            return response  

        rescue Exception => e
            $stderr.puts e.inspect
            response = false
            return response 
    end 

    #
    # Given a gene id, returns its KEGG annotations (KEGG ID and KEGG pathway) in a hash
    #
    # @param [string] gene id as a String
    # @return [kegg_hash] KEGG annotations of a gene as Hash
    #
    def Annotation.kegg_annotation(gene_id)
        kegg_hash = {}
        response = Annotation.fetch(url:"http://togows.org/entry/kegg-genes/ath:#{gene_id}/pathways.json")
        if response # if fetch was successful
            body_hash = JSON.parse(response.body)[0] # turns the JSON file into a ruby hash
            unless body_hash.nil?
                body_hash.each do |kegg_id, pathway_name|
                    kegg_hash[kegg_id] = pathway_name # add a new element to the kegg_hash
                end
            end
        end
        return kegg_hash
    end

    #
    # Given a gene id, returns its GO annotations (GO ID and Biological function) in a hash
    #
    # @param [string] gene id as String
    # @return [go_hash] go annotations of a gene as Hash
    #
    def Annotation.go_annotation(gene_id)
        go_hash = {}
        response = Annotation.fetch(url:"http://togows.org/entry/ebi-uniprot/#{gene_id}/dr.json" )
        if response # if fetch was successful
            body_hash = JSON.parse(response.body)[0] # turns the JSON file into a ruby hash
            unless body_hash["GO"].nil?
                body_hash["GO"].each do |go_info|
                    if go_info[1] =~ /^P:/ # we are only interested on the biological processes
                        go_id = go_info[0]
                        go_process = go_info[1].split(":")[1] # we only add the part name of the process
                        go_hash[go_id] = go_process # add a new element to the go_hash 
                    end
                end
            end
            return go_hash
        end
    end

end