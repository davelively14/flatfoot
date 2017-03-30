defmodule Flatfoot.Factory do
  use ExMachina.Ecto, repo: Flatfoot.Repo

  def user_factory do
    %Flatfoot.Clients.User{
      username: Faker.Internet.user_name,
      email: Faker.Internet.free_email,
      password: Faker.Code.isbn
    }
  end
end
