require 'singleton'
class ServerDictionary
  include Singleton

  attr_accessor :arr_word

  def initialize
    Rails.logger.debug("ServerDictionary::initialize: load dictionary")
    @arr_word = index(File.open('db/dictionary.txt').map{|file| file.delete("\n")})
  end

  def where(query=nil, arg={limit:10})
    Rails.logger.debug("ServerDictionary::where query = \'#{query}\' limit = \'#{arg[:limit]}\'")
    rez=[]
    if query
      i=0
      list_of_words = @arr_word[:"#{query[0]}"]
      if list_of_words.present?
        list_of_words.each do |name|
          if i<arg[:limit]
            if name >=query
              rez<<{id: i,name:name}
              i+=1
            end
          else
            break;
          end
        end
      else
        rez<<{id: i,name:query}
      end
    end
    rez
  end


  private

  def index(arg)
    Rails.logger.debug("ServerDictionary::index: add index")
    index = {}
    arg.each do |word|
      index[:"#{word[0]}"] ?  index[:"#{word[0]}"] << word : index[:"#{word[0]}"] = [word]
    end
    index
  end

end