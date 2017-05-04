defmodule Flatfoot.Web.Spade.WardResultView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.Spade.WardResultView

  def render("ward_result.json", %{ward_result: ward_result}) do
    %{
      id: ward_result.id,
      rating: ward_result.rating,
      from: ward_result.from,
      msg_id: ward_result.msg_id,
      msg_text: ward_result.msg_text
    }
  end

  def render("ward_result_list.json", %{ward_results: ward_results}) do
    %{
      ward_results: render_many(ward_results, WardResultView, "ward_result.json")
    }
  end
end
