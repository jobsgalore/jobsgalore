class Option
  URGENT = :urgent
  HIGHLIGHT = :highlight


  def self.select_options(option: ,type:, id:)
      case option
      when URGENT
        self.urgent(type: type, id: id)
      when HIGHLIGHT
        self.highlight(type: type, id: id)
      else
        raise "Option: unidentified option"
      end
  end

  private

  def self.urgent(type:, id:)
    self.select_class(type).find_by_id(id).urgent_on
  end

  def self.highlight(type:, id:)
    self.select_class(type).find_by_id(id).highlight_on
  end

  def self.select_class(type)
    case type
    when "job"
      Job
    when "resume"
      Resume
    else
      raise "Option: unidentified class"
    end
  end
end