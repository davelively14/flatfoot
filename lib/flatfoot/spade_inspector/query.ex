defmodule Flatfoot.SpadeInspector.Query do
  def build(ward_account) do
    %{q: "to:#{ward_account.handle}"}
  end
end
