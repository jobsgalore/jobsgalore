class LazyHash < Hash
  def []key
    val = super.[]key
    if val.respond_to?(:call)
      val = val.call
      super.[]key = val
    end
    val
  end
end
