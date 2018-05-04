class Settings < ActiveRecord::Base
  serialize :value

  def self.[](var)
    find_by_var(var).try :value
  end

  def self.[]=(var, value)
    setting = find_or_initialize_by(var: var)
    setting.value = value
    setting.save!

    value
  end

  def self.method_missing(meth, *args, &block)
    if [:find_by_var, :find_or_initialize_by].include?(meth)
      super
    elsif meth =~ /=\Z/
      self[meth.to_s.chop] = args[0]
    else
      self[meth]
    end
  end
end
