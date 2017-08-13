defmodule FlatfootWeb.Spade.WardResultView do
  use FlatfootWeb, :view
  alias FlatfootWeb.Spade.WardResultView

  def render("ward_result.json", %{ward_result: ward_result}) do
    %{
      id: ward_result.id,
      rating: ward_result.rating,
      from: ward_result.from,
      msg_id: ward_result.msg_id,
      msg_text: ward_result.msg_text,
      ward_account_id: ward_result.ward_account_id,
      backend_id: ward_result.backend_id,
      timestamp: ward_result.updated_at |> NaiveDateTime.to_iso8601
    }
  end

  def render("ward_result_list.json", %{ward_results: ward_results}) do
    %{
      ward_results: render_many(ward_results, WardResultView, "ward_result.json")
    }
  end
end
