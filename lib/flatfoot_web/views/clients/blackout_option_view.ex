defmodule FlatfootWeb.BlackoutOptionView do
  use FlatfootWeb, :view
  alias FlatfootWeb.BlackoutOptionView

  def render("index.json", %{blackout_options: blackout_options}) do
    %{data: render_many(blackout_options, BlackoutOptionView, "blackout_option.json")}
  end

  def render("show.json", %{blackout_option: blackout_option}) do
    %{data: render_one(blackout_option, BlackoutOptionView, "blackout_option.json")}
  end

  def render("error.json", %{error: error}) do
    %{errors: error}
  end

  def render("blackout_option.json", %{blackout_option: blackout_option}) do
    %{
      id: blackout_option.id,
      start: blackout_option.start,
      stop: blackout_option.stop,
      threshold: blackout_option.threshold,
      exclude: blackout_option.exclude,
      user_id: blackout_option.user_id
    }
  end
end
