class Search
  def self.str_to_search(arg)
    arg.gsub(/((\W|^|\s)(of|on|in|from|i|you|he|she|it|is|are|r|s|we|they|m|who|am|me|whom|her|him|us|them|my|mine|his|hers|your|yours|our|ours|their|theirs|whose|its|that|which|where|why|a|the|as|an|over|under|to|whith|whithout|by|at|into|onto|work|job|looking|Responsibilities|responsibilities|Aug|Jul|Projects|Dec|Mrs|Mr|experience)(\s|$|\W))/,' ')
  end

  def self.str_to_highlight(arg)
    arg = arg.join if arg.class == Array
    if arg.present?
      self.str_to_search(arg).split(" ")
    else
      ""
    end
  end
end