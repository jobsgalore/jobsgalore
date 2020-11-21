require './lib/server_dictionary.rb'
class Dictionary
    include Virtus.model
    attribute :id, Integer
    attribute :name, String

    def self.where(*arg)
      t = Time.now
      query = arg[0].downcase.split(' ')
      arg[0]= query.last
      query.delete_at(query.size-1)
      @connect = ServerDictionary.instance
      array_words = @connect.where(*arg)
      array_words.map! do |word|
        self.new(id:word[:id], name:(query + Array(word[:name])).join(' '))
      end
      Rails.logger.debug("Dictionary: speed of query #{(Time.now-t)*1000} ms")
      array_words
    end

end