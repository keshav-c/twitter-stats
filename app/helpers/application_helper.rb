module ApplicationHelper
  def page_title(base = '')
    suffix = 'Twitter Stats App'
    if base.empty?
      suffix
    else
      [base, suffix].join(' | ')
    end
  end

  def logged_in?
    session[:userinfo].present?
  end
end
