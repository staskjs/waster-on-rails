class WorkTime < ActiveRecord::Base
  def get
  end

  def in?
    direction == 'in'
  end

  def out?
    direction == 'out'
  end
end
