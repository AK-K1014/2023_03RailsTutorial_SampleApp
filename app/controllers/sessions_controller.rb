class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # 
      forwarding_url = session[:forwarding_url]
      reset_session      # ログインの直前に必ずこれを書くこと
      # params[:session][:remember_me] paramsのチェックボックスがオンの時は'1'になり、オフの時は'0'になります。
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      # 転送先URLが存在する場合はそこにリダイレクトし、転送先URLが「nil」の場合はユーザーのプロフィールにリダイレクト出来るようになる。
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    # logged_in?がtrueの場合に限ってlog_outを呼び出すようにする
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
