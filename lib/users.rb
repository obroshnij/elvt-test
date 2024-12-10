module Users
  module_function

  def create(**)
    instance = CreateService.call(**)
    instance.user
  end
end
