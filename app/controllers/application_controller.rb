class ApplicationController < ActionController::Base
  def hello
    render heml: "hello, world!"
  end
end
