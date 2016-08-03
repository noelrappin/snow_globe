class UserPolicy

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def same_user?
    user == record
  end

  def show?
    same_user? || user.admin?
  end

  def update?
    same_user? || user.admin?
  end

  def edit?
    same_user? || user.admin?
  end

  # START: simulate_policy
  def simulate?
    user.admin? && !same_user?
  end
  # END: simulate_policy

end
